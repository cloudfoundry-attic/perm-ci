#!/bin/bash

set -eu

VERSION="$(cat version/version)"

tar -zxf "${PWD}/perm-bin-dir/perm-${VERSION}.tgz" -C /usr/local/bin

# From capi-ci:
# HACK: change access time on mysql files to copy them into the writable layer
# Context: https://github.com/moby/moby/issues/34390
find /var/lib/mysql/mysql -exec touch -c -a {} +
service mysql restart

pushd perm-rb
  bundle install
  bundle exec rake
popd
