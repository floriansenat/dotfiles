#!/usr/bin/env python3
"""Detect which VCS is in use: jj or git."""
import subprocess
import sys
from pathlib import Path

def detect_vcs(path="."):
    """Return 'jj' if jj repo, 'git' if git repo, None otherwise."""
    path = Path(path).resolve()

    # Check for jj
    try:
        result = subprocess.run(
            ["jj", "root"],
            cwd=path,
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            return "jj"
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass

    # Check for git
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--git-dir"],
            cwd=path,
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            return "git"
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass

    return None

if __name__ == "__main__":
    vcs = detect_vcs()
    if vcs:
        print(vcs)
        sys.exit(0)
    else:
        print("No VCS detected", file=sys.stderr)
        sys.exit(1)
