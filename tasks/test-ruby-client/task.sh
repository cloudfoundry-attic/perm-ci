#!/bin/bash

set -eu

tar -zxf "${PWD}/perm-bin-dir/"perm-*.tgz -C /usr/local/bin

pushd perm-rb
  bundle install
  bundle exec rake
popd
