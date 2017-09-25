#!/bin/bash

set -eu

git --git-dir=repo/.git rev-parse --abbrev-head HEAD > branch-dir/branch
