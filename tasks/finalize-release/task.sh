#!/bin/bash
# vim: set ft=sh

set -e -x

FINAL_RELEASE_DIR=$PWD/final-release-tarball
FINAL_RELEASE_REPO=$PWD/final-release-repo

CANDIDATE_DIR=$PWD/release-tarball

VERSION=$(cat ./version/version)
if [ -z "$VERSION" ]; then
  echo "missing version number"
  exit 1
fi

git clone ./release-repo "$FINAL_RELEASE_REPO"

echo "$BOSH_PRIVATE_CONFIG" > "$FINAL_RELEASE_REPO/config/private.yml"

cd "$FINAL_RELEASE_REPO"

RELEASE_YML=$PWD/releases/concourse/concourse-${VERSION}.yml
FINAL_RELEASE_TGZ=$FINAL_RELEASE_DIR/concourse-${VERSION}.tgz

# work-around Go BOSH CLI trying to rename blobs downloaded into ~/.root/tmp
# into release dir, which is invalid cross-device link
export HOME=$PWD

git config --global user.email "cf-permissions@pivotal.io"
git config --global user.name "CI Bot"

if ! [ -e "${RELEASE_YML}" ]; then
  echo "finalizing release"
  bosh -n finalize-release --version "$VERSION" "${CANDIDATE_DIR}"/perm-*.tgz
  git add -A
  git commit -m "release v${VERSION}"
  git tag -f "v${VERSION}"
fi

bosh -n create-release --tarball "${FINAL_RELEASE_TGZ}" "${RELEASE_YML}"
