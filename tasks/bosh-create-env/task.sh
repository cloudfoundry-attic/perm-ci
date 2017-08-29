#!/bin/bash

set -eux

STATE_DIR="${PWD}/state-dir"
UPDATED_STATE_DIR="${PWD}/updated-state-dir"
BOSH_DEPLOYMENT_DIR="${PWD}/bosh-deployment"
OPS_FILES="${OPS_FILES:-}"
OPS_FILE="${PWD}/concatenated_ops_file.yml"
BBL_STATE_FILE="bbl-state.json"

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
}

function setup_infrastructure() {
  pushd "$STATE_DIR"
    bbl up \
      --iaas gcp \
      --gcp-zone "$GCP_ZONE" \
      --gcp-region "$GCP_REGION" \
      --gcp-service-account-key "${STATE_DIR}/${GCP_SERVICE_ACCOUNT_KEY_FILE}" \
      --gcp-project-id "${GCP_PROJECT_ID}" \
      --no-director
  popd
}

function concatenate_ops_files() {
  local ops_files
  ops_files=( $OPS_FILES )

  for file in "${ops_files[@]}"; do
    cat "${BOSH_DEPLOYMENT_DIR}/${file}" >> "${OPS_FILE}"
  done
}

function create_env() {
  pushd "$BOSH_DEPLOYMENT_DIR"
    bosh create-env \
      --state "${STATE_DIR}/${ENV_STATE_FILE}" \
      -o "${OPS_FILE}" \
      --vars-store "${STATE_DIR}/${VARS_STORE_FILE}" \
      -l <(bbl bosh-deployment-vars --state-dir "${STATE_DIR}") \
      bosh.yml
  popd
}

function commit_saved_state() {
  local git_status

  pushd "$STATE_DIR"
    git config user.name "${GIT_COMMIT_USERNAME:-"CI Bot"}"
    git config user.email "${GIT_COMMIT_EMAIL:-"cf-permission@pivotal.io"}"

    git_status="$(git status --porcelain)"

    if echo "${git_status}" | grep -q "${BBL_STATE_FILE}"; then
      git commit -m "Update bbl-state.json"
    fi

    if echo "${git_status}" | grep -q "${VARS_STORE_FILE}"; then
      git commit -m "Update ${VARS_STORE_FILE}"
    fi
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
