#!/bin/bash

set -eu

VERSION="$(cat version/version)"

pushd perm-rb
  # Something's busted with the ruby docker image, so this is the workaround
  # https://github.com/bundler/bundler/issues/6162
  export BUNDLE_GEMFILE="${PWD}/Gemfile"
  bundle install
  bundle exec rake
popd

exit 1
