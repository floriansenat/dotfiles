---
name: pr-description
description: Generate a PR description from the current jj bookmark changes. Use when the user asks to generate, write, or create a PR description, or when preparing a pull request. Triggered by requests like "describe this PR", "generate PR description", "write PR description", or "/pr-description".
---

# PR Description Generator

Generate a PR description by analyzing the current bookmark's changes against main.

## Workflow

1. Get the current bookmark name: `jj bookmark list --conflict`
2. Get the diff against main: `jj diff --from main --stat` for overview, `jj diff --from main` for full diff
3. Get commit messages: `jj log -r 'main..@'`
4. Check if a plan file exists for this session in `~/.claude/plans/` — read the most recent plan file if relevant
5. Generate the description in the format below
6. Copy the final markdown output to clipboard using `pbcopy`

## Output Format

```markdown
## Ch-ch-changes!

- <concise change, focus on why not how>
- <another change>
- ...

## Where is my mind?

<details>
<summary>Plan: <short plan title></summary>

<exact plan content from the plan file>

</details>
```

## Rules

- **Ch-ch-changes!**: each item is concise and short. Focus on **why**, not how. Only explain implementation when it's non-obvious and needs context. Sacrifice grammar for concision.
- **Where is my mind?**: each plan MUST be wrapped in its own `<details><summary>` block. Use the exact plan content. If multiple plans exist, each gets its own `<details>` element. If no plan was used, write "No plan was used for this PR."
- Output raw markdown, do not wrap in a code block
- After generating, pipe the full markdown output to `pbcopy` so the user can paste it directly
