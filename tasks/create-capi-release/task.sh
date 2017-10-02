#!/bin/bash

set -eu

TASKS_DIR="${PWD}/perm-ci"
TIMESTAMP="$(date +%s)"

set +u
# shellcheck source=/dev/null
source /usr/local/share/chruby/chruby.sh
chruby 2.4.2
set -u

export SYNC_BLOBS="true"
export TARBALL_NAME="${RELEASE_NAME}-release-${TIMESTAMP}-for-perm"

mv release-dir/parent-repo release
"${TASKS_DIR}/tasks/create-release/task.sh"
