#!/bin/bash

PERM_HOSTNAME=localhost
PERM_PORT=6283
VERSION="$(cat version/version)"

tar -zxf "./perm-bin-dir/perm-${VERSION}.tgz" -C /usr/local/bin

CF_RUN_PERM_SPECS=true ./capi-ci/ci/test-unit/run_cc_unit_tests
