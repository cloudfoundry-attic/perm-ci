#!/bin/bash

set -eu

VERSION="$(cat version/number)"
OUTPUT_DIR="${PWD}/release-output"

mkdir -p "$OUTPUT_DIR"

if [[ -z "$RELEASE_NAME" ]]; then
  echo "\$RELEASE_NAME parameter not set"
  exit 1
fi

if [[ -z "$VERSION" ]]; then
  echo "\$VERSION not found"
  exit 1
fi

pushd release > /dev/null
  bosh create-release \
    --name "$RELEASE_NAME" \
    --version "$VERSION" \
    --tarball "${OUTPUT_DIR}/${TARBALL_NAME}-${VERSION}.tgz"
popd > /dev/null
