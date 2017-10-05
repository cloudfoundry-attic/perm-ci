#!/bin/bash

set -eu

PERM_PACKAGE="code.cloudfoundry.org/perm"
# shellcheck disable=SC2153
PERM_PATH="${PERM_GOPATH}/src/${PERM_PACKAGE}"

GOPATH="$PERM_GOPATH"

# Workaround because of
# https://github.com/maxbrunsfeld/counterfeiter/issues/75
# Add another GOPATH that's secretly the perm vendor directory
ln -s "${PERM_PATH}/vendor" "${PERM_PATH}/src"

pushd "${PERM_PATH}" > /dev/null
  GOPATH=$GOPATH:$PERM_PATH go generate ./...
popd > /dev/null

unlink "${PERM_PATH}/src"
