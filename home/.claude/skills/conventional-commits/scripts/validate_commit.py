#!/usr/bin/env python3
"""
Validate conventional commit messages.

Usage:
  python3 validate_commit.py "feat(dx-1234): add feature"
  python3 validate_commit.py "invalid commit"

Validates against:
- Type must be one of: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test
- Scope (optional) must be in parentheses after type
- Linear ID format: word characters and hyphens (e.g., dx-1234)
- Title required after colon and space
- Format: <type>(<scope>): <title> or <type>: <title>
"""

import sys
import re

ALLOWED_TYPES = {
    "build", "chore", "ci", "docs", "feat", "fix",
    "perf", "refactor", "revert", "style", "test"
}

def validate_commit(message):
    """
    Validate a conventional commit message.

    Returns:
        (is_valid: bool, errors: list[str])
    """
    errors = []

    if not message or not message.strip():
        return False, ["Commit message cannot be empty"]

    message = message.strip()

    # Pattern: type(scope): title or type: title
    # Type: lowercase alphanumeric
    # Scope: optional, in parentheses immediately after type
    # Title: any non-empty text after ": "
    # Must NOT have scope after the colon
    pattern = r'^([a-z]+)(?:\(([^)]+)\))?\:\s+(.+)$'
    match = re.match(pattern, message)

    # Extra check: reject messages with scope-like pattern after colon
    if match and re.search(r':\s*\([^)]+\)', message):
        return False, ["Scope must be in parentheses immediately after type, before the colon"]

    if not match:
        errors.append(
            "Format must be: <type>(<scope>): <title> or <type>: <title>\n"
            f"Got: {message[:80]}"
        )
        return False, errors

    commit_type, scope, title = match.groups()

    # Validate type
    if commit_type not in ALLOWED_TYPES:
        errors.append(
            f"Invalid type '{commit_type}'. Allowed types: " +
            ", ".join(sorted(ALLOWED_TYPES))
        )

    # Validate scope if present
    if scope:
        # Linear ID pattern: word chars and hyphens
        if not re.match(r'^[a-zA-Z0-9\-]+$', scope):
            errors.append(
                f"Invalid scope '{scope}'. Scope must contain only alphanumeric "
                "characters and hyphens (e.g., dx-1234)"
            )

    # Validate title
    if not title.strip():
        errors.append("Title cannot be empty")
    elif len(title) > 100:
        errors.append(f"Title too long ({len(title)} chars). Keep under 100 chars")

    return len(errors) == 0, errors


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 validate_commit.py '<commit message>'")
        print("\nExample:")
        print("  python3 validate_commit.py 'feat(dx-1234): add dashboard'")
        sys.exit(1)

    message = sys.argv[1]
    is_valid, errors = validate_commit(message)

    if is_valid:
        print("✅ Valid commit message")
        sys.exit(0)
    else:
        print("❌ Invalid commit message\n")
        for error in errors:
            print(f"  • {error}")
        sys.exit(1)


if __name__ == "__main__":
    main()
