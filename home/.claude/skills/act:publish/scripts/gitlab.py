#!/usr/bin/env python3
"""GitLab helpers for the publish skill."""

import json
import subprocess
import sys


def glab_api(path: str):
    result = subprocess.run(
        ["glab", "api", path],
        capture_output=True, text=True, check=True
    )
    return json.loads(result.stdout)


def get_current_user() -> dict:
    """Returns {id, username, name}."""
    user = glab_api("user")
    return {"id": user["id"], "username": user["username"], "name": user["name"]}


def get_project_labels(project_path: str = "kalos/app"):
    """Returns sorted list of label names for the project."""
    encoded = project_path.replace("/", "%2F")
    labels = []
    page = 1
    while True:
        page_labels = glab_api(f"projects/{encoded}/labels?per_page=100&page={page}")
        if not page_labels:
            break
        labels.extend(label["name"] for label in page_labels)
        if len(page_labels) < 100:
            break
        page += 1
    return sorted(labels)


def get_current_bookmark() -> str:
    """Returns the current jj bookmark name."""
    result = subprocess.run(
        ["jj", "bookmark", "list", "--revisions", "@"],
        capture_output=True, text=True
    )
    for line in result.stdout.splitlines():
        name = line.split(":")[0].strip()
        if name and not name.startswith("@"):
            return name
    # fallback: parse from jj log
    result = subprocess.run(
        ["jj", "log", "--no-graph", "-r", "@", "-T", "bookmarks"],
        capture_output=True, text=True
    )
    return result.stdout.strip().split()[0] if result.stdout.strip() else ""


def get_gitlab_project_path() -> str:
    """Detect the GitLab project path from git remote."""
    result = subprocess.run(
        ["git", "remote", "get-url", "origin"],
        capture_output=True, text=True
    )
    url = result.stdout.strip()
    # ssh: git@gitlab.yousign.fr:kalos/app.git
    # https: https://gitlab.yousign.fr/kalos/app.git
    path = url.split(":")[-1].removeprefix("/").removesuffix(".git")
    if "/" in path:
        parts = path.split("/")
        return "/".join(parts[-2:])
    return path


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "labels"

    if cmd == "user":
        user = get_current_user()
        print(f"username={user['username']}")
        print(f"name={user['name']}")

    elif cmd == "labels":
        project = get_gitlab_project_path()
        labels = get_project_labels(project)
        print("\n".join(labels))

    elif cmd == "bookmark":
        print(get_current_bookmark())

    elif cmd == "info":
        project = get_gitlab_project_path()
        user = get_current_user()
        bookmark = get_current_bookmark()
        labels = get_project_labels(project)
        print(json.dumps({
            "project": project,
            "username": user["username"],
            "bookmark": bookmark,
            "labels": labels,
        }, indent=2))
