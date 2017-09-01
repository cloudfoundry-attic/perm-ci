#!/bin/sh

set -eu

export GOPATH="${PWD}/gopath"
export PATH="${GOPATH}/bin:${PATH}"

cd "${GOPATH}/src/code.cloudfoundry.org/perm"
go install code.cloudfoundry.org/perm/vendor/github.com/onsi/ginkgo/ginkgo

ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
