#!/bin/bash

set -eu

WORKSPACE="${HOME}/workspace"
PERM_PACKAGE="code.cloudfoundry.org/perm"
# shellcheck disable=SC2153
PERM_PATH="${PERM_GOPATH}/src/${PERM_PACKAGE}"
PROTOS_PATH="${WORKSPACE}/perm-protos"

GOPATH="$PERM_GOPATH"
go install "${PERM_PACKAGE}/vendor/github.com/gogo/protobuf/protoc-gen-gofast"

PATH="${GOPATH}/bin:${PATH}"

RUBY_PROTOC_PLUGIN="$(which grpc_tools_ruby_protoc_plugin)"
: "${RUBY_PROTOC_PLUGIN:?"Did not find grpc_tools_ruby_protoc_plugin"}"

protoc \
  --gofast_out=plugins=grpc:"${PERM_PATH}/protos" \
  --ruby_out="${PERM_RB_PATH}/lib/perm/protos" \
  --plugin=protoc-gen-grpc="$RUBY_PROTOC_PLUGIN" \
  --grpc_out="${PERM_RB_PATH}/lib/perm/protos" \
  -I="${PROTOS_PATH}:${PERM_PATH}/vendor" \
  "${PROTOS_PATH}/"*.proto
