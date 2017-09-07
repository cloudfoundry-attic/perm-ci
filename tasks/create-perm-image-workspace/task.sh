#!/bin/sh

set -eu

tar -zxf "${PWD}/perm-bin-dir/perm-*.tgz" -C perm-image-workspace
cp perm-image-src/Dockerfile perm-image-workspace
