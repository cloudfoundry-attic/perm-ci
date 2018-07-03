#!/bin/sh

set -eu

export GOPATH="${PWD}/gopath"
export PATH="${GOPATH}/bin:${PATH}"

# We don't need to care about authentication here,
# and for some reason the MySQL driver has trouble authenticating if we require authentication.
# Ergo, no authentication in unit tests!
mysqld_safe --skip-grant-tables > /dev/null &
trap "killall -u mysql" EXIT

cd "${GOPATH}/src/code.cloudfoundry.org/perm"

go fmt ./...

DIRECTORIES="./cmd ./integration ./pkg ./protos ./test"

echo "########################"
echo "# go vet output"
echo "########################"
set +e
go tool vet -all -shadow $DIRECTORIES
set -e
echo "########################"
echo "# end go vet output"
echo "########################"

go install golang.org/x/tools/cmd/goimports
echo "########################"
echo "# goimports output"
echo "########################"
echo "The following files have import mismatches with goimports:"
goimports -l $DIRECTORIES
echo "########################"
echo "# end goimports output"
echo "########################"

go install code.cloudfoundry.org/perm/vendor/github.com/onsi/ginkgo/ginkgo
ginkgo -r -p -race -randomizeSuites -randomizeAllSpecs
