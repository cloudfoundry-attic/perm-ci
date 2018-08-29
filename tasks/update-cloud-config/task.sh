#!/bin/bash

set -eu

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
cf_deployment_repo="${workspace_dir}/cf-deployment"
env_info="${workspace_dir}/bosh-lite-env-info"

source "${env_info}/metadata"

cat > add-tcp-router-port.yml <<EOF
- type: replace
  path: /vm_extensions/name=cf-tcp-router-network-properties/cloud_properties/ports/-
  value:
    host: ${TCP_PORT}
EOF

bosh int "${cf_deployment_repo}/iaas-support/bosh-lite/cloud-config.yml" -o add-tcp-router-port.yml > updated-cloud-config.yml

echo "Updating cloud-config..."
bosh -n update-cloud-config updated-cloud-config.yml

echo "Done."
