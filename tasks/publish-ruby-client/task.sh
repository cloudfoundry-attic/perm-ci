#!/bin/bash

set -eu

VERSION="$(cat version/version)"

mkdir -p ${HOME}/.gem
cat << EOF > ${HOME}/.gem/credentials
---
:rubygems_api_key: ${RUBYGEMS_API_KEY}
EOF
chmod 0600 ${HOME}/.gem/credentials

pushd perm-rb
  # Something's busted with the ruby docker image, so this is the workaround
  # https://github.com/bundler/bundler/issues/6162
  export BUNDLE_GEMFILE="${PWD}/Gemfile"
  bundle install
  for GEMSPEC in *.gemspec; do
    gem build ${GEMSPEC}
  done
  for GEM in *.gem; do
    gem push ${GEM}
  done
popd
