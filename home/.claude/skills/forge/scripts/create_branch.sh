#!/bin/bash
# Create jj bookmark
# Usage: create_branch.sh <branch_name>

set -e

BRANCH_NAME="$1"

if [ -z "$BRANCH_NAME" ]; then
    echo "Usage: create_branch.sh <branch_name>" >&2
    exit 1
fi

jj bookmark create "$BRANCH_NAME"
echo "Created jj bookmark: $BRANCH_NAME"
