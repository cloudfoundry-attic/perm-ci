#!/bin/sh

set -eu

GOPATH="${PWD}/release"
VERSION="$(cat version/version)"

go build -o "$BINARY_NAME" "$PACKAGE_PATH"
tar czf "bin-dir/${BINARY_NAME}-${VERSION}.tgz" "$BINARY_NAME"
