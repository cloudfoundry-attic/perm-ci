#!/bin/bash

set -eu

CREDS_PATH="${PWD}/environment-directory/creds.yml"
METADATA_PATH="${PWD}/terraform/metadata"
EXTERNAL_IP="$(bosh interpolate "$METADATA_PATH" --path /external_ip)"
SYSTEM_DOMAIN="$(bosh interpolate "$METADATA_PATH" --path /system_domain)"
CONFIG_PATH="${PWD}/cats-config-dir/integration_config.json"

function login_to_credhub() {
  local uaa_ca
  local credhub_ca
  local credhub_username
  local credhub_password
  uaa_ca="$(bosh interpolate "$CREDS_PATH" --path /default_ca/ca)"
  credhub_ca="$(bosh interpolate "$CREDS_PATH" --path /credhub_ca/ca)"
  credhub_username="credhub-cli"
  credhub_password="$(bosh interpolate "$CREDS_PATH" --path /credhub_cli_password)"
  credhub api "https://${EXTERNAL_IP}:8844" --ca-cert "${credhub_ca}" --ca-cert "${uaa_ca}"
  credhub login -u "${credhub_username}" -p "${credhub_password}"
}

function get_cf_credentials() {
  local admin_password
  admin_password="$(credhub get -n /bosh-lite/cf/cf_admin_password --output-json)"
  ADMIN_USERNAME=admin
  ADMIN_PASSWORD="$(echo "${admin_password}" | jq -r -e .value)"
}

function store_config() {
  cat > "$CONFIG_PATH" <<EOF
{
  "api": "api.${SYSTEM_DOMAIN}",
  "apps_domain": "${SYSTEM_DOMAIN}",
  "admin_user": "${ADMIN_USERNAME}",
  "admin_password": "${ADMIN_PASSWORD}",
  "skip_ssl_validation": true,
  "use_http": false,
  "include_apps": true,
  "include_backend_compatibility": false,
  "include_capi_experimental": false,
  "include_capi_no_bridge": false,
  "include_container_networking": false,
  "include_credhub" : false,
  "include_detect": false,
  "include_docker": false,
  "include_internet_dependent": false,
  "include_isolation_segments": false,
  "include_persistent_app": false,
  "include_private_docker_registry": false,
  "include_privileged_container_support": false,
  "include_route_services": false,
  "include_routing": true,
  "include_routing_isolation_segments": false,
  "include_security_groups": false,
  "include_services": true,
  "include_ssh": false,
  "include_sso": false,
  "include_tasks": false,
  "include_v3": true,
  "include_zipkin": false
}
EOF
}

function main() {
  login_to_credhub
  get_cf_credentials
  store_config
}

main
