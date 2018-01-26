#!/bin/bash

set -eu

ENVIRONMENT_DIRECTORY="${PWD}/perm-ci-credentials"
TARGET_FILE_PATH="${PWD}/deployment-target-dir/target.yml"

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
  cat > "$TARGET_FILE_PATH" <<EOF
{
  "deployment": "$DEPLOYMENT_NAME",
  "target": "$TARGET",
  "client": "$CLIENT",
  "client_secret": "$CLIENT_SECRET",
  "ca_cert": "$CA_CERT",
  "jumpbox_url": "$JUMPBOX_URL",
  "jumpbox_ssh_key": "$JUMPBOX_SSH_KEY"
}
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
}

trap cleanup_decrypted_files EXIT

main
