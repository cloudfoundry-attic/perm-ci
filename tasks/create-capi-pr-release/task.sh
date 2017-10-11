#!/bin/bash

set -eu

set +u
# shellcheck source=/dev/null
source /usr/local/share/chruby/chruby.sh
chruby 2.4.2
set -u

BRANCH="$(cat branch-dir/branch)"
BRANCH_NAME="$(echo "${BRANCH}" | cut -d / -f 2)"
TASKS_DIR="${PWD}/perm-ci"
TIMESTAMP="$(date +%s)"

export SYNC_BLOBS="true"
export TARBALL_NAME="${RELEASE_NAME}-release-${TIMESTAMP}-${BRANCH_NAME}-for-perm"

mv release-dir/parent-repo release
"${TASKS_DIR}/tasks/create-release/task.sh"
