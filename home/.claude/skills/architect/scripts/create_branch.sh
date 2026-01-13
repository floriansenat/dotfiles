#!/bin/bash
# Create a branch/bookmark for Linear ticket implementation
# Usage: ./create_branch.sh <LTID>

set -e

if [ -z "$1" ]; then
    echo "Error: LTID required" >&2
    exit 1
fi

LTID="$1"

# Detect VCS (inline detection to avoid external dependency)
if [ -d ".jj" ]; then
    # Create Jujutsu bookmark
    jj bookmark create "$LTID"
    echo "Created jj bookmark: $LTID"
elif [ -d ".git" ]; then
    # Create Git branch
    git checkout -b "$LTID"
    echo "Created git branch: $LTID"
else
    echo "Error: No VCS found (neither .jj nor .git directory)" >&2
    exit 2
fi
