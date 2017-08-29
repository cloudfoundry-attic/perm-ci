#!/bin/bash

set -eu

export GOPATH="${PWD}/perm"
export PATH="${GOPATH}/bin:${PATH}"

go install github.com/onsi/ginkgo/ginkgo

pushd "${GOPATH}/src/perm"
  ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
popd
