#!/bin/sh

set -eu

GOPATH="${PWD}/release"

go build -o "bin-dir/${BINARY_NAME}" "$PACKAGE_PATH"
