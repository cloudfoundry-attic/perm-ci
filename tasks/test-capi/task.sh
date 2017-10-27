#!/bin/bash

VERSION="$(cat version/version)"

tar -zxf "./perm-bin-dir/perm-${VERSION}.tgz" -C /usr/local/bin

# Ensure that MySQL is definitely running since we currently only support MySQL,
# and CAPI only starts MySQL if that's what the test run is using.
#
# From capi-ci:
# HACK: change access time on mysql files to copy them into the writable layer
# Context: https://github.com/moby/moby/issues/34390
find /var/lib/mysql/mysql -exec touch -c -a {} +

# We don't need to care about authentication here,
# and for some reason the driver has trouble authenticating if we require authentication.
# Ergo, no authentication in unit tests!
mysqld_safe --skip-grant-tables > /dev/null &
trap "killall -u mysql" EXIT

db[0]="postgres"
db[1]="mysql"

rand=$((RANDOM % 2))
export DB="${db[$rand]}"

CF_RUN_PERM_SPECS=true ./capi-ci/ci/test-unit/run_cc_unit_tests
