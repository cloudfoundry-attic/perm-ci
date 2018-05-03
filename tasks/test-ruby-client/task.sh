#!/bin/bash

set -eu

tar -zxf "${PWD}/perm-bin-dir/perm-*.tgz" -C /usr/local/bin

pushd perm-rb
  # Something's busted with the ruby docker image, so this is the workaround
  # https://github.com/bundler/bundler/issues/6162
  export BUNDLE_GEMFILE="${PWD}/Gemfile"
  bundle install
  bundle exec rake
popd
