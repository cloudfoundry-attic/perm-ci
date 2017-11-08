#!/bin/bash

set -eu

PACKAGE="${PACKAGE:-code.cloudfoundry.org/perm}"
# shellcheck disable=SC2153
PACKAGE_PATH="${PERM_GOPATH}/src/${PACKAGE}"

GOPATH="$PERM_GOPATH"

# Workaround because of
# https://github.com/maxbrunsfeld/counterfeiter/issues/75
# Add another GOPATH that's secretly the perm vendor directory
ln -s "${PACKAGE_PATH}/vendor" "${PACKAGE_PATH}/src"

pushd "${PACKAGE_PATH}" > /dev/null
  GOPATH=$GOPATH:$PACKAGE_PATH go generate ./...
popd > /dev/null

unlink "${PACKAGE_PATH}/src"
