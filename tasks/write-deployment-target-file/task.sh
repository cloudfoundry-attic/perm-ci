#!/bin/bash

set -eu

ENVIRONMENT_DIRECTORY="${PWD}/perm-ci-credentials
TARGET_FILE_PATH="${PWD}/deployment-target-dir/target.yml"

function get_credentials() {
  pushd "${ENVIRONMENT_DIRECTORY}/${ENV_NAME}" > /dev/null
    cryptdo -p "$CRYPTDO_PASSWORD" -- eval "$(bbl print-env)"
    cryptdo -p "$CRYPTDO_PASSWORD" -- JUMPBOX_URL="$(bbl jumpbox-address)"
  popd > /dev/null

  TARGET="${BOSH_ENVIRONMENT}"
  CLIENT="${BOSH_CLIENT}"
  CLIENT_SECRET="${BOSH_CLIENT_SECRET}"
  CA_CERT="${BOSH_CA_CERT}"
  JUMPBOX_SSH="$(cat $JUMPBOX_PRIVATE_KEY)"
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
