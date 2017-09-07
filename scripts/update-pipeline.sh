#!/bin/bash

set -eu

CONCOURSE_TARGET=ci
CREDENTIALS_NOTE_NAME="Perm Pipeline Credentials"
CRYPTDO_PASSWORD_NAME="Perm CI Cryptdo Password"

function check_args() {
  if [[ -z "${1:-}" ]]; then
    echo "Must be called with \`update-pipeline.sh <pipeline>\`"
    exit 1
  fi
}

function check_installed() {
  local command
  command="$1"

  if ! command -v "$command" > /dev/null; then
    echo "$command must be installed"
    exit 1
  fi
}

function update_pipeline() {
  local pipeline
  local config_file
  local cryptdo_password

  pipeline="$1"
  config_file="$(dirname -- "$0")/../pipelines/${pipeline}.yml"
  cryptdo_password="$(lpass show "$CRYPTDO_PASSWORD_NAME" --password)"

  fly -t "$CONCOURSE_TARGET" set-pipeline \
    -p "$pipeline" \
    -c "$config_file" \
    -l <(lpass show "$CREDENTIALS_NOTE_NAME" --notes) \
    -v cryptdo_password="$cryptdo_password"
}

function main() {
  check_args "$@"
  check_installed lpass
  check_installed fly
  # lpass sync
  update_pipeline "$1"
}

main "$@"
