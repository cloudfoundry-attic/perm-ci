#!/bin/bash

set -eu

WORKSPACE="${HOME}/workspace"
PERM_GO_PACKAGE="code.cloudfoundry.org/perm-go"
# shellcheck disable=SC2153
PERM_GO_PATH="${GOPATH}/src/${PERM_GO_PACKAGE}"
PROTOS_PATH="${WORKSPACE}/perm-protos"

go install "${PERM_GO_PACKAGE}/vendor/github.com/gogo/protobuf/protoc-gen-gofast"

RUBY_PROTOC_PLUGIN="$(which grpc_tools_ruby_protoc_plugin)"
: "${RUBY_PROTOC_PLUGIN:?"Did not find grpc_tools_ruby_protoc_plugin"}"

protoc \
  --gofast_out=plugins=grpc:"${PERM_GO_PATH}" \
  --ruby_out="${PERM_RB_PATH}/lib/perm/protos" \
  --plugin=protoc-gen-grpc="$RUBY_PROTOC_PLUGIN" \
  --grpc_out="${PERM_RB_PATH}/lib/perm/protos" \
  -I="${PROTOS_PATH}:${PERM_GO_PATH}/vendor" \
  "${PROTOS_PATH}/"*.proto
