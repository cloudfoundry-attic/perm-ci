#!/bin/bash

set -eu

VERSION="$(cat version/version)"

tar -zxf "${PWD}/perm-bin-dir/perm-${VERSION}.tgz" -C /usr/local/bin

pushd perm-rb
  bundle install
  bundle exec rake
popd
