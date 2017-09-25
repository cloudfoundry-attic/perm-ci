#!/bin/bash

set -eu

git --git-dir="${REPO}/.git" rev-parse --abbrev-head HEAD > branch-dir/branch
