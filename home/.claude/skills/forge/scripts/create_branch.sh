#!/bin/bash
# Create branch (git) or bookmark (jj) based on VCS type
# Usage: create_branch.sh <vcs_type> <branch_name>

set -e

VCS_TYPE="$1"
BRANCH_NAME="$2"

if [ -z "$VCS_TYPE" ] || [ -z "$BRANCH_NAME" ]; then
    echo "Usage: create_branch.sh <vcs_type> <branch_name>" >&2
    exit 1
fi

case "$VCS_TYPE" in
    git)
        git checkout -b "$BRANCH_NAME"
        echo "Created git branch: $BRANCH_NAME"
        ;;
    jj)
        jj bookmark create "$BRANCH_NAME"
        echo "Created jj bookmark: $BRANCH_NAME"
        ;;
    *)
        echo "Unknown VCS type: $VCS_TYPE" >&2
        exit 1
        ;;
esac
