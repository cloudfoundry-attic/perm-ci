#!/bin/sh

set -eu

export GOPATH="${PWD}/perm-release"
export PATH="${GOPATH}/bin:${PATH}"

cd "${GOPATH}/src/code.cloudfoundry.org/cc-to-perm-migrator"
go install code.cloudfoundry.org/cc-to-perm-migrator/vendor/github.com/onsi/ginkgo/ginkgo

ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
