#!/bin/bash

set -eu

CREDS_PATH="${PWD}/environment-directory/creds.yml"
METADATA_PATH="${PWD}/terraform/metadata"

# We use the external IP instead of the system domain because the certs are only valid for the IP
EXTERNAL_IP="$(cat "$METADATA_PATH" | jq -r .external_ip)"

DEPLOYMENT_NAME=cf
CLIENT_ID=admin
CLIENT_SECRET="$(bosh interpolate "$CREDS_PATH" --path /admin_password)"
CA_CERT="$(bosh interpolate "$CREDS_PATH" --path /default_ca/ca --json | jq .Blocks[0] )"

# CA_CERT is already quoted, and jq -r mishandles the newlines for our purposes
cat <<EOF > errand-configuration-directory/config.json
{
  "deployment": "${DEPLOYMENT_NAME}",
  "target": "${EXTERNAL_IP}",
  "client": "${CLIENT_ID}",
  "client_secret": "${CLIENT_SECRET}",
  "ca_cert": ${CA_CERT}
}
EOF
