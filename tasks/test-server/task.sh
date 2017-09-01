#!/bin/bash

set -eu

export GOPATH="${PWD}/perm-release"
export PATH="${GOPATH}/bin:${PATH}"

pushd "${GOPATH}/src/perm"
  go install code.cloudfoundry.org/perm/vendor/github.com/onsi/ginkgo/ginkgo

  ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
popd
