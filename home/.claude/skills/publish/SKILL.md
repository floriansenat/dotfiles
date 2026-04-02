---
name: publish
description: Push the current jj bookmark and create a GitLab MR. Use when the user asks to publish, push and open a MR, or "créer une MR". Automatically sets "ai-generated" label and current user as assignee, shows available project labels so the user can pick additional ones, and uses bard output as description.
---

1. `python3 ~/.claude/skills/publish/scripts/gitlab.py info` → get user, bookmark, labels
2. `jj bookmark track <bookmark> --remote=origin && jj git push -b <bookmark>`
3. Invoke `bard` skill → description copied to clipboard
4. `AskUserQuestion` multiSelect with labels (hide "ai-generated"; pre-select Front/Back/RFR/deploy::review-app as relevant)
5. `glab mr create --source-branch <bookmark> --target-branch <target> --title "<title>" --description "$(pbpaste)" --assignee <user> --label "ai-generated,<extras>" --no-editor`

**Target branch**: `main` by default. If stacked, detect parent bookmark via `jj log -r '<bookmark>-' --no-graph -T 'bookmarks'` and use it instead.

**MR exists**: `glab mr update <id> --description "$(pbpaste)" --label "..."`
**Push conflict**: `jj git fetch` then force push if intentional
