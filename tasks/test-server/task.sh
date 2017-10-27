#!/bin/sh

set -eu

export GOPATH="${PWD}/gopath"
export PATH="${GOPATH}/bin:${PATH}"

# We don't need to care about authentication here,
# and for some reason the driver has trouble authenticating if we require authentication.
# Ergo, no authentication in unit tests!
mysqld_safe --skip-grant-tables > /dev/null &
trap "killall -u mysql" EXIT

cd "${GOPATH}/src/code.cloudfoundry.org/perm"
go install code.cloudfoundry.org/perm/vendor/github.com/onsi/ginkgo/ginkgo

ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
