#!/bin/bash

set -eu

indent() {
  sed -e 's/^/  /'
}

indent_contents_of() {
  indent < "$1"
}

ENVIRONMENT_DIRECTORY="${PWD}/perm-ci-credentials"
TARGET_DIR="${PWD}/deployment-target-dir"
TARGET_FILE_PATH="${TARGET_DIR}/target.yml"
VARS_FILE_PATH="${TARGET_DIR}/vars.yml"

SYSTEM_DOMAIN="${ENV_NAME}.perm.cf-app.com"

function get_credentials() {
  pushd "${ENVIRONMENT_DIRECTORY}/${ENV_NAME}" > /dev/null
    cryptdo -p "$CRYPTDO_PASSWORD" -- cat bbl-state.json > bbl-state.json.decrypted
    mv bbl-state.json.decrypted bbl-state.json

    pushd vars > /dev/null
      for file in *.enc; do
        cryptdo -p "$CRYPTDO_PASSWORD" -- cat "${file%%.enc}" > "${file%%.enc}.decrypted"
      done

      for file in *.decrypted; do
        mv "${file}" "${file%%.decrypted}"
      done
    popd > /dev/null

    TARGET="$(bbl director-address)"
    CLIENT="$(bbl director-username)"
    CLIENT_SECRET="$(bbl director-password)"
    CA_CERT="$(bbl director-ca-cert)"
    JUMPBOX_SSH_KEY="$(bbl ssh-key)"
    JUMPBOX_URL="$(bbl jumpbox-address)"
  popd > /dev/null
}

function store_target_file() {
  cat <<-EOF > "${TARGET_FILE_PATH}"
---
deployment: "${DEPLOYMENT_NAME}"
target: "${TARGET}"
client: "${CLIENT}"
client_secret: "${CLIENT_SECRET}"
ca_cert: |
$(indent_contents_of <( echo "${CA_CERT}" ))
jumpbox_url: "${JUMPBOX_URL}:22"
jumpbox_ssh_key: |
$(indent_contents_of <( echo "${JUMPBOX_SSH_KEY}" ))
EOF
}

function store_vars_file() {
  cat <<-EOF > "${VARS_FILE_PATH}"
---
system_domain: "${SYSTEM_DOMAIN}"
EOF
}

function cleanup_decrypted_files() {
  shopt -s globstar
  pushd "${ENVIRONMENT_DIRECTORY}/${ENV_NAME}" > /dev/null
    for file in **/*.enc; do
      rm -f "${file%%.enc}"
    done
  popd > /dev/null
}

function main() {
  get_credentials
  store_target_file
  store_vars_file
}

trap cleanup_decrypted_files EXIT

main
