#!/bin/bash

set -eux

GOPATH="$PERM_GOPATH"
go install "code.cloudfoundry.org/perm/vendor/github.com/gogo/protobuf/protoc-gen-gofast"

PATH="${GOPATH}/bin:${PATH}"

protoc \
  --gofast_out=plugins=grpc:"${GOPATH}/bin" \
  --ruby_out="${PERM_RB_PATH}/lib/perm/protos" \
  --plugin=protoc-gen-grpc="$(which grpc_tools_ruby_protoc_plugin)" \
  --grpc_out="${PERM_RB_PATH}/lib/perm/protos" \
  -I="${PERM_GOPATH}/src/code.cloudfoundry.org/perm:${PERM_GOPATH}/src/code.cloudfoundry.org/perm/vendor" \
  "${PERM_GOPATH}/src/code.cloudfoundry.org/perm/protos/"*.proto
