#!/usr/bin/env python3
"""
Detect pnpm package name from file path or workspace configuration.
"""
import json
import sys
from pathlib import Path
from typing import Optional

def find_package_json(file_path: Path) -> Optional[Path]:
    """Walk up from file_path to find nearest package.json"""
    current = file_path if file_path.is_dir() else file_path.parent
    while current != current.parent:
        pkg_json = current / "package.json"
        if pkg_json.exists():
            return pkg_json
        current = current.parent
    return None

def get_package_name(package_json_path: Path) -> Optional[str]:
    """Extract name from package.json"""
    try:
        with open(package_json_path) as f:
            data = json.load(f)
            return data.get("name")
    except (json.JSONDecodeError, FileNotFoundError):
        return None

def main():
    if len(sys.argv) < 2:
        print("Usage: detect_package.py <file_path>", file=sys.stderr)
        sys.exit(1)

    file_path = Path(sys.argv[1]).resolve()

    if not file_path.exists():
        print(f"Error: Path does not exist: {file_path}", file=sys.stderr)
        sys.exit(1)

    pkg_json = find_package_json(file_path)
    if not pkg_json:
        print("Error: No package.json found in directory tree", file=sys.stderr)
        sys.exit(1)

    pkg_name = get_package_name(pkg_json)
    if not pkg_name:
        print("Error: No 'name' field in package.json", file=sys.stderr)
        sys.exit(1)

    print(pkg_name)

if __name__ == "__main__":
    main()
