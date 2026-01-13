#!/bin/bash
# Create a branch/bookmark for Linear ticket implementation
# Usage: ./create_branch.sh <LTID>

set -e

if [ -z "$1" ]; then
    echo "Error: LTID required" >&2
    exit 1
fi

if [ -z "$VCS" ]; then
    echo "Error: VCS variable not set" >&2
    exit 2
fi

LTID="$1"

if [ "$VCS" = "jj" ]; then
    jj bookmark create "$LTID"
    echo "Created jj bookmark: $LTID"
elif [ "$VCS" = "git" ]; then
    git checkout -b "$LTID"
    echo "Created git branch: $LTID"
else
    echo "Error: Invalid VCS: $VCS" >&2
    exit 3
fi
