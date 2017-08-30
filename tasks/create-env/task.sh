#!/bin/bash

set -eu
set -o pipefail

STATE_DIR="${PWD}/state-dir"
UPDATED_STATE_DIR="${PWD}/updated-state-dir"
BOSH_DEPLOYMENT_DIR="${PWD}/bosh-deployment"
ADDITIONAL_OPS_FILES_DIR="${PWD}/additional-ops-files-dir"
BOSH_DEPLOYMENT_OPS_FILES="${BOSH_DEPLOYMENT_OPS_FILES:-}"
ADDITIONAL_OPS_FILES="${ADDITIONAL_OPS_FILES:-}"
OPS_FILE="${PWD}/concatenated_ops_file.yml"
BBL_STATE_FILE_NAME="bbl-state.json"

function verify_variables() {
  if [[ -z "$GCP_ZONE" ]]; then
    echo "\$GCP_ZONE is a required parameter"
    exit 1
  fi

  if [[ -z "$GCP_REGION" ]]; then
    echo "\$GCP_REGION is a required parameter"
    exit 1
  fi

  if [[ -z "$GCP_SERVICE_ACCOUNT_KEY_FILE" ]]; then
    echo "\$GCP_SERVICE_ACCOUNT_KEY_FILE is a required parameter"
    exit 1
  fi

  if [[ ! -f "${STATE_DIR}/${GCP_SERVICE_ACCOUNT_KEY_FILE}" ]]; then
    echo "\$GCP_SERVICE_ACCOUNT_KEY_FILE does not exist at path ${STATE_DIR}/${GCP_SERVICE_ACCOUNT_KEY_FILE}"
    exit 1
  fi

  if [[ -z "$GCP_PROJECT_ID" ]]; then
    echo "\$GCP_PROJECT_ID is a required parameter"
    exit 1
  fi

  if [[ -z "$ENV_NAME" ]]; then
    echo "\$ENV_NAME is a required parameter"
    exit 1
  fi

  if [[ -z "$VARS_STORE_FILE" ]]; then
    echo "\$VARS_STORE_FILE is a required parameter"
    exit 1
  fi

  if [[ -z "$ENV_STATE_FILE" ]]; then
    echo "\$ENV_STATE_FILE is a required parameter"
    exit 1
  fi

  if [[ -z "$CRYPTDO_PASSWORD" ]]; then
    echo "\$CRYPTDO_PASSWORD is a required parameter"
    exit 1
  fi
}

function setup_infrastructure() {
  pushd "$STATE_DIR"
    cryptdo -passphrase "$CRYPTDO_PASSWORD" -- \
      bbl up \
        --iaas gcp \
        --gcp-zone "$GCP_ZONE" \
        --gcp-region "$GCP_REGION" \
        --gcp-service-account-key "${STATE_DIR}/${GCP_SERVICE_ACCOUNT_KEY_FILE}" \
        --gcp-project-id "$GCP_PROJECT_ID" \
        --name "$ENV_NAME" \
        --no-director
  popd
}

function concatenate_ops_files() {
  local bosh_deployment_ops_files
  local additional_ops_files

  if [[ -n "$BOSH_DEPLOYMENT_OPS_FILES" ]]; then
    bosh_deployment_ops_files=( $BOSH_DEPLOYMENT_OPS_FILES )

    for file in "${bosh_deployment_ops_files[@]}"; do
      echo "file: ${file}"
      cat "${BOSH_DEPLOYMENT_DIR}/${file}" >> "${OPS_FILE}"
    done
  fi

  if [[ -n "$ADDITIONAL_OPS_FILES" ]]; then
    additional_ops_files=( $ADDITIONAL_OPS_FILES )
    for file in "${additional_ops_files[@]}"; do
      cat "${ADDITIONAL_OPS_FILES_DIR}/${file}" >> "${OPS_FILE}"
    done
  fi
}

function create_env() {
  pushd "$STATE_DIR"
    bosh create-env \
      --state "${ENV_STATE_FILE}" \
      -o "${OPS_FILE}" \
      --vars-store "${VARS_STORE_FILE}" \
      -l <(bbl bosh-deployment-vars) \
      "${BOSH_DEPLOYMENT_DIR}/bosh.yml"
  popd
}

function encrypt_and_commit() {
  local file
  local git_status

  file="$1"

  cryptdo-bootstrap -p "$CRYPTDO_PASSWORD" "$file"
  chmod +w "$file"
  git_status="$(git status --porcelain)"

  if echo "$git_status" | grep -q "${file}.enc"; then
    git add "${file}.enc"
    git commit -m "Update ${file}"
  fi
}

function commit_saved_state() {
  local git_status

  pushd "$STATE_DIR"
    git config user.name "${GIT_COMMIT_USERNAME:-"CI Bot"}"
    git config user.email "${GIT_COMMIT_EMAIL:-"cf-permission@pivotal.io"}"

    encrypt_and_commit "$BBL_STATE_FILE_NAME"
    encrypt_and_commit "$VARS_STORE_FILE"
    encrypt_and_commit "$ENV_STATE_FILE"
  popd

  cp -R "$STATE_DIR" "${UPDATED_STATE_DIR}"
}

function main() {
  verify_variables
  concatenate_ops_files
  setup_infrastructure
  create_env
  commit_saved_state
}

main
