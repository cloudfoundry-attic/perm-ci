#!/bin/bash

set -eux

git config --global user.email "cf-permissions@pivotal.io"
git config --global user.name "CI Bot"

cd cf-deployment-perm

git remote add -f local-release-candidate ../cf-deployment-release-candidate
git checkout release-candidate-perm
git rebase local-release-candidate/release-candidate
cp -a . ../rebased-cf-deployment-perm
