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
    JUMPBOX_SSH="$(bbl ssh-key)"
    JUMPBOX_URL="$(bbl jumpbox-address)"

    rm bbl-state.json
    shopt -s extglob
    rm vars/!(*.enc)
  popd > /dev/null
}

function store_target_file() {
  cat > "$TARGET_FILE_PATH" <<EOF
{
  "target": "$TARGET",
  "client": "$CLIENT",
  "client_secret": "$CLIENT_SECRET",
  "ca_cert": "$CA_CERT",
  "jumpbox_url": "$JUMPBOX_URL",
  "jumbox_ssh": "$JUMPBOX_SSH"
}
EOF
}

function main() {
  get_credentials
  store_target_file
}

main
