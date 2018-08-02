#!/bin/bash

set -eux

git config --global user.email "cf-permissions@pivotal.io"
git config --global user.name "CI Bot"

cd cf-deployment-perm

git remote add -f local-develop ../cf-deployment-develop
git checkout perm-develop
git rebase local-develop/develop
cp -a . ../rebased-cf-deployment-perm
