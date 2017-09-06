#!/bin/sh

set -eu

GOPATH="${PWD}/release"

go build "$PACKAGE_PATH" -o "bin-dir/${BINARY_NAME}"
