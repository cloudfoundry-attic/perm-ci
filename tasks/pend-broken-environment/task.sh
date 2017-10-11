#!/bin/bash

set -eu

ENV_NAME="$(cat environment-name-dir/name)"

git clone pool-repo updated-pool-repo-dir/repo

pushd updated-pool-repo-dir/repo
  git config user.name "$GIT_COMMIT_USERNAME"
  git config user.email "$GIT_COMMIT_EMAIL"

  touch "${POOL_NAME}/pending/${ENV_NAME}"

  git add "${POOL_NAME}/pending/${ENV_NAME}"
  git commit -m "Pend broken environment ${ENV_NAME}"
popd
