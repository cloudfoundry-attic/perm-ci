#!/bin/sh

set -eu

tar -zxf ./perm-bin-dir/perm-*.tgz -C perm-image-workspace
cp perm-image-src/Dockerfile perm-image-workspace
