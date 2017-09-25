#!/bin/bash

set -eu

BRANCH_FILE="${PWD}/branch-dir/branch"

# From https://stackoverflow.com/a/6064223
pushd repo
  branches="$(git for-each-ref --format="%(objectname) %(refname:short)" refs/heads | awk "/^$(git rev-parse HEAD)/ {print \$2}" | head -n 1)"
  num_branches="$(echo "${branches}" | wc -l)"

  if [[ "$num_branches" != 1 ]]; then
    echo "Expected single branch name to match HEAD"
    exit 1
  fi

  branch="$(echo "$branches" | head -n 1)"
  echo "$branch" > "$BRANCH_FILE"
popd
