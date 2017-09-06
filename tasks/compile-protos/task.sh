#!/bin/bash

set -eux

PERM_PACKAGE="code.cloudfoundry.org/perm"
# shellcheck disable=SC2153
PERM_PATH="${PERM_GOPATH}/src/${PERM_PACKAGE}"

GOPATH="$PERM_GOPATH"
go install "${PERM_PACKAGE}/vendor/github.com/gogo/protobuf/protoc-gen-gofast"

PATH="${GOPATH}/bin:${PATH}"

protoc \
  --gofast_out=plugins=grpc:"${PERM_PATH}/protos" \
  --ruby_out="${PERM_RB_PATH}/lib/perm/protos" \
  --plugin=protoc-gen-grpc="$(which grpc_tools_ruby_protoc_plugin)" \
  --grpc_out="${PERM_RB_PATH}/lib/perm/protos" \
  -I="${PERM_PATH}/protos:${PERM_PATH}/vendor" \
  "${PERM_PATH}/protos/"*.proto
