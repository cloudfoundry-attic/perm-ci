#!/bin/bash

set -eu

tar -zxf "${PWD}/perm-bin-dir/perm-*.tgz" -C /usr/local/bin

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
  # Something's busted with the ruby docker image, so this is the workaround
  # https://github.com/bundler/bundler/issues/6162
  export BUNDLE_GEMFILE="${PWD}/Gemfile"
  bundle install
  bundle exec rake
popd
