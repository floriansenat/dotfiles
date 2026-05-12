---
name: act:publish
description: Use when the user asks to publish, push and open a MR, or "créer une MR". Generates a structured MR description via interactive PR Contract template, then pushes and creates the GitLab MR.
---

# Phase 1 — Context Gathering

1. `python3 ~/.claude/skills/act:publish/scripts/gitlab.py info` → get user, bookmark, labels
2. `jj diff --git` → full diff
3. `jj log -r 'trunk()..@' --no-graph` → commits since divergence from trunk. If `trunk()` unset, fall back to `main@origin..@` (this repo has no local `main` bookmark — only remote-tracking `main@origin`). Never use bare `main` in revsets.

# Phase 2 — Analyse & Draft

Read diff + commits. Draft each section — be terse. No filler, no restating what the diff shows. Reviewers scan, they don't read essays.

- **Ch-ch-changes!** — 1 short paragraph focusing on the main change + 1-4 oneliner bullets for other secondary changes. Focus on **why** the change exists (motivation, user/business outcome, constraint being addressed). Do NOT enumerate files, functions, or how the change is implemented — reviewers get that from the diff. If sentence starts to describe a code path or rename mechanics, cut it. Keep it simple, non-author should grasp intent under 30 seconds.
- **Review Focus** — bullet list, 1-3 items. Detect: sensitive files (auth, payments, migrations, config), new patterns, high-complexity areas.
- **Heads Up** — bullet list. Detect: migrations, config changes, breaking changes, deploy requirements. Skip if nothing found.
- **Proof** — leave empty. Author provides.

# Phase 3 — Interactive Template

Present each section via `AskUserQuestion`. Author selects draft or picks "Other" to write their own.

1. **Ch-ch-changes!** — draft as option 1. "Other" to rewrite.
2. **Review Focus** — suggested zones as option 1. "Other" to rewrite.
3. **Heads Up** — if detected: draft as option 1, "Nothing to flag" as option 2. If nothing detected: "Nothing to flag" as option 1. Omit section from final description if "Nothing to flag".
4. **Proof** — no draft. Options: "Tests pass", "Manual QA", "Screenshots attached" as inspiration. Author writes actual proof via "Other".

**Title**: first commit message as option 1, "Other" to rewrite.

# Phase 4 — Publish

1. Assemble validated sections into markdown:

```markdown
## Ch-ch-changes!
{validated content}

## Review Focus
{validated content}

## Heads Up
{validated content — omit section if "Nothing to flag"}

## Proof
{validated content}
```

2. **Ensure commit has a description** — `jj log -r @ --no-graph -T description` must be non-empty. If empty, `jj desc -m "<validated title>" @` before push (reuses the title chosen in Phase 3). Skip if description already set (don't clobber).
3. **Push first, track after** — `jj git push -b <bookmark>`. Then `jj bookmark track <bookmark> --remote=origin` only if not already tracked (ignore failure — tracking is best-effort). Never use deprecated `<bookmark>@<remote>` syntax — always `--remote=<remote>`.
4. `AskUserQuestion` multiSelect with labels (hide "ai-generated"; pre-select Front/Back/RFR/deploy::review-app as relevant)
5. `glab mr create --source-branch <bookmark> --target-branch <target> --title "<title>" --description "<assembled>" --assignee <user> --label "ai-generated,<extras>" --no-editor`

**Target branch**: `main` by default. If stacked, detect parent bookmark via `jj log -r '<bookmark>-' --no-graph -T 'bookmarks'`. **Strip any `@origin` / `@<remote>` suffix** before passing to `glab --target-branch` — glab wants the plain branch name.

**MR exists**: `glab mr update <id> --description "<assembled>" --label "..."`
**Push conflict**: `jj git fetch` then force push if intentional
