---
name: forge
description: Implementation orchestration skill for feature development. Use when user requests to implement features, bug fixes, or code changes that require planning, VCS management, linting, and testing. Triggers on implementation requests like "implement feature X", "build Y", "add functionality Z", "forge this", or when structured implementation workflow is needed. Supports optional TDD with Aegis and code review with Warden.
model: opus
---

# Forge

Implementation orchestrator that manages the full development workflow from planning to testing.

## Workflow

Execute steps sequentially:

### 1. Detect VCS

Run `scripts/detect_vcs.py` to determine if using jj or git. Store result in context for subsequent steps.

### 2. Create Branch/Bookmark

Generate descriptive branch name from task. Use `scripts/create_branch.sh <vcs_type> <branch_name>`.

### 3. Create Plan

Invoke Architect skill to create implementation plan. Wait for plan approval.

### 4. Optional: TDD with Aegis

If user mentions TDD, tests-first, or explicitly requests Aegis, launch Aegis subagent with the approved plan from Architect.

### 5. Implement

Execute plan step by step. Use TodoWrite to track progress.

### 6. Run Linter

Find the closest `pnpm-workspace.yaml` file.
Move to the folder containing the file.
Execute inside this folder: `pnpm --filter "<project>" check:error`

Where `<project>` is defined in the Architect plan. Fix any errors found.

### 7. Run Tests

Find the closest `pnpm-workspace.yaml` file.
Move to the folder containing the file.
Execute inside this folder: `pnpm --filter "<project>" test`

Where `<project>` is defined in the Architect plan. Run only on modified files when possible using test runner's changed file detection.

### 8. Optional: Code Review with Warden

If user mentions code review or explicitly requests Warden, launch Warden subagent to review changes.

## Notes

- VCS detection happens once per invocation
- Branch/bookmark name should be concise, kebab-case, descriptive
- Always wait for Architect plan approval before implementation
- Linting must pass before tests
- Only invoke Aegis/Warden when explicitly requested or clearly implied by user intent
