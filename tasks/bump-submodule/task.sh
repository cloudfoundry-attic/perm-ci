#!/bin/bash

set -eu

SUBMODULE_SHA="$(cat submodule-repo/.git/HEAD)"

pushd parent-repo
  pushd "$SUBMODULE_PATH"
    git fetch
    git checkout "$SUBMODULE_SHA"
  popd

  git config user.name "${GIT_COMMIT_USERNAME:-"CI Bot"}"
  git config user.email "${GIT_COMMIT_EMAIL:-"cf-permissions@pivotal.io"}"

  if git diff-index HEAD; then
    git add .
    git commit -m "Bumping ${SUBMODULE_NAME} submodule"
  fi
popd

cp -R parent-repo/* updated-parent-repo
