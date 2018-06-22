#!/bin/sh

set -eu

tar -zxf ./perm-bin-dir/perm-*.tgz -C perm-image-workspace
cp perm-image-src/images/perm/Dockerfile perm-image-workspace

mkdir -p perm-image-workspace/certs
cp perm-certs/certs/* perm-image-workspace/certs/
