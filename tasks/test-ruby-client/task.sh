#!/bin/bash

set -eu

"${PWD}/perm-bin-dir/perm" &
CHILD_PID=$!

function salt_earth() {
  kill -9 "$CHILD_PID"
}

trap salt_earth EXIT

pushd perm-rb
  bundle install
  bundle exec rspec
popd
