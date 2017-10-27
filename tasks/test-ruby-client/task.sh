#!/bin/bash

set -eu

VERSION="$(cat version/version)"

tar -zxf "${PWD}/perm-bin-dir/perm-${VERSION}.tgz" -C /usr/local/bin

# From capi-ci:
# HACK: change access time on mysql files to copy them into the writable layer
# Context: https://github.com/moby/moby/issues/34390
find /var/lib/mysql/mysql -exec touch -c -a {} +

# We don't need to care about authentication here,
# and for some reason the driver has trouble authenticating if we require authentication.
# Ergo, no authentication in unit tests!
mysqld_safe --skip-grant-tables > /dev/null &
trap "killall -u mysql" EXIT

pushd perm-rb
  bundle install
  bundle exec rake
popd
