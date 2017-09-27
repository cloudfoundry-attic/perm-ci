#!/bin/bash

PERM_HOSTNAME=localhost
PERM_PORT=6283
VERSION="$(cat version/version)"

export PERM_RPC_HOST="${PERM_HOSTNAME}:${PERM_PORT}"

tar -zxf "./perm-bin-dir/perm-${VERSION}.tgz" -C perm-bin-dir

./perm-bin-dir/perm --listen-hostname "$PERM_HOSTNAME" --listen-port "$PERM_PORT" > "${PWD}/perm.out.log" &
CHILD_PID=$!

function salt_earth() {
  kill -9 "$CHILD_PID"
}

trap salt_earth EXIT

CF_RUN_PERM_SPECS=true ./capi-ci/ci/test-unit/run_cc_unit_tests
