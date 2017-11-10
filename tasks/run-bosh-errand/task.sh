#!/bin/bash

set -eu

CREDS_PATH="${PWD}/environment-directory/creds.yml"
METADATA_PATH="${PWD}/terraform/metadata"

# We use the external IP instead of the system domain because the certs are only valid for the IP
export BOSH_ENVIRONMENT="$(cat "$METADATA_PATH" | jq -r .external_ip)"

export BOSH_CLIENT_SECRET="$(bosh interpolate "$CREDS_PATH" --path /admin_password)"
export BOSH_CA_CERT="$(bosh interpolate "$CREDS_PATH" --path /default_ca/ca)"

bosh run-errand "${BOSH_ERRAND_NAME}"
