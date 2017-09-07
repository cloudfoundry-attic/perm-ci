#!/bin/bash

set -eu

PERM_HOSTNAME=localhost
PERM_PORT=8888

export PERM_RPC_HOST="${PERM_HOSTNAME}:${PERM_PORT}"

"${PWD}/perm-bin-dir/perm" --listen-hostname "$PERM_HOSTNAME" --listen-port "$PERM_PORT" &
CHILD_PID=$!

function salt_earth() {
  kill -9 "$CHILD_PID"
}

trap salt_earth EXIT

pushd perm-rb
  bundle install
  bundle exec rspec
popd
