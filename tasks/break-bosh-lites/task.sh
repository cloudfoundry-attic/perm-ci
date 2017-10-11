#!/bin/bash

set -eu

TRIGGER_PATH="${PWD}/updated-pool-repo-dir/repo/${TRIGGER_PATH}"

git clone pool-repo updated-pool-repo-dir/repo

pushd updated-pool-repo-dir/repo
  git config user.name "$GIT_COMMIT_USERNAME"
  git config user.email "$GIT_COMMIT_EMAIL"

  # If there are no files in the glob it will expand to the directory path
  # Prevent this behavior: https://www.cyberciti.biz/faq/bash-loop-over-file/
  shopt -s nullglob

  for env_path in "${PWD}/${POOL_NAME}/pending/"*; do
    env="$(basename "$env_path")"

    git mv "${env_path}" "./${POOL_NAME}/unclaimed"
    git commit -m "Break $env"

    echo "$env" > "${TRIGGER_PATH}"

    git add "${TRIGGER_PATH}"
    git commit -m "Trigger destruction of $env"
  done
popd
