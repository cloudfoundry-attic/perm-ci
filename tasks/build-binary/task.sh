#!/bin/sh

set -eu

GOPATH="${PWD}/release"
VERSION="$(cat version/version)"

go build -o "bin-dir/${BINARY_NAME}-${VERSION}" "$PACKAGE_PATH"
