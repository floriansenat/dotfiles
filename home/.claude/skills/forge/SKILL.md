---
name: forge
description: Execute implementation plans with integrated linting and testing validation at each step. Use when user explicitly requests plan implementation (e.g., "/implement-plan", "implement this plan", "follow plan.md") and provides a plan.md file path. Handles step-by-step execution with automatic pnpm package detection, runs linters (check:error) and tests after each step, and supports TDD mode via Aegis for test-first development.
context: fork
model: claude-opus-4-5
---

# Forge

Execute implementation plans with automated validation workflow: implement step → lint → test → commit → next step.

## Core Workflow

1. **Load plan** from user-provided file path
2. **Detect VCS** - Identify if project uses `jj` or `git`
3. **Parse steps** - If plan has numbered/bulleted steps, execute sequentially. If no explicit steps, treat entire plan as single step
4. **For each step:**
   - Implement changes
   - Run linter: `pnpm --filter "<package>" check:error`
   - Run tests: `pnpm --filter "<package>" test` (only for changed files)
   - Fix issues if validation fails (max 3 attempts, then ask user)
   - Ask user to review changes and confirm to continue to next step
   - Create commit with step description using detected VCS
   - Move to next step when user approves

## Package Detection

Target pnpm package is explicitly provided in plan metadata or content.
If not provided, use `scripts/detect_package.py <file_path>` to find package name from any file in the package.

## VCS Detection

Detect version control system at project root:
- If `.jj` directory exists: use `jj` (Jujutsu)
- Else if `.git` directory exists: use `git`
- Else: error, no VCS found

### Commit Creation

After user approves step changes, create commit with appropriate VCS:
- **Jujutsu**: `jj commit -m "<step description>"`
- **Git**: `git add . && git commit -m "<step description>"`

Commit message is the step title/description from the plan.

## Aegis Mode (TDD)

When user requests "Use Aegis" or mentions TDD:

1. **Before each step implementation:**
   - Create tests based on step requirements
   - Run tests (expect failures)
   - Implement step to make tests pass
   - Run linter and full test suite
   - Proceed when all validations pass

Tests are created per-step, not all upfront.

## Validation Rules

### Linting
- Run: `pnpm --filter "<package>" check:error`
- On errors: iterate and fix, max 3 attempts
- After 3 failures: ask user to continue or skip

### Testing
- Run: `pnpm --filter "<package>" test` with file filter for changed files
- If no tests exist for changed files: skip test validation (acceptable)
- On failures: iterate and fix, max 3 attempts
- After 3 failures: ask user to continue or skip

### Changed File Detection
Track files modified during step implementation to determine:
- Which package to target (if not already determined)
- Which test files to run (tests for changed source files)

## Example Usage

```
User: /implement-plan path/to/plan.md
```

Plan with steps:
```markdown
# Feature: Add User Dashboard

Package: @myapp/frontend

## Steps
1. Create Dashboard component
2. Add routing
3. Integrate with API
```

Execution:
1. Detect VCS (e.g., `.git` found → use git)
2. Implement Dashboard component
3. Run `pnpm --filter "@myapp/frontend" check:error`
4. Run `pnpm --filter "@myapp/frontend" test` (filter to Dashboard tests)
5. Fix any issues (max 3 attempts)
6. Ask user to review changes and approve
7. Create commit: `git add . && git commit -m "Create Dashboard component"`
8. Move to step 2 (routing)...

## Edge Cases

- **No explicit steps**: Treat plan as single step, validate once at end
- **No tests for changed files**: Skip test validation, continue with linter only
- **Multiple packages affected**: Ask user which package to target, or run validations for each
- **Validation failures after 3 attempts**: Prompt user: "Linter/tests failing after 3 attempts. Continue fixing (c), skip step (s), or abort (a)?"
- **No VCS found**: Error and abort plan execution

## Scripts

- `scripts/detect_package.py <file_path>` - Find pnpm package name from file path
- VCS detection is inline: check for `.jj` directory, then `.git` directory
