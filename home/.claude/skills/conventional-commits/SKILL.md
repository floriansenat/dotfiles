---
name: conventional-commits
description: "Validate & guide commit messages following conventional commits specification with custom type definitions and Linear ID support. Use when crafting commit messages to ensure they follow the correct format with type, optional scope, and title. Includes validation of commit types, scope format, and message structure."
user-invocable: false
---

# Conventional Commits

## Overview

Enforce commits following the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) spec. This skill validates message format, enforces allowed types, supports optional Linear ID scopes, and provides clear feedback on violations.

## Format Specification

```
<type>(<scope>): <title>
[optional body]
[optional footer(s)]
```

**Examples:**
- Valid: `feat: add user authentication`
- Valid: `chore(dx-1234): update dependencies`
- Invalid: `test: (dx-1234) test update` ← scope after ":" not in parens
- Invalid: `✨ (dx-4321) feature` ← type must be string, ":" missing after scope

## Commit Types

| Type | Usage |
|------|-------|
| `build` | Building (Docker image, etc.) |
| `chore` | Technical task (excluding code refactoring) |
| `ci` | CI/CD updates |
| `docs` | Documentation (OAS, HLD, README, etc.) |
| `feat` | Introducing or updating a feature |
| `fix` | Applying a fix |
| `perf` | Improving performance |
| `refactor` | Refactoring code |
| `revert` | Reverting previous changes |
| `style` | Updating UI |
| `test` | Adding tests |

## Scope (Optional)

Linear ID format: `dx-1234` or similar. If your commit isn't related to a Linear task, omit scope.

Examples:
- `feat(dx-1234): implement auth`
- `fix(dx-5678): resolve memory leak`
- `docs: add API guide` ← no scope needed

## Title (Required)

Summary of changes. Keep concise. No trailing period.

## Body (Optional)

Long description of why the change was made, problems encountered, or relevant context.

## Footer (Optional)

Links to Sentry, Notion, or other references.

## Validation Script

Use `scripts/validate_commit.py` to validate commit messages:

```bash
python3 validate_commit.py "feat(dx-1234): add dashboard"
```

Returns validation result with clear error messages if format is incorrect.

## Common Mistakes

See `references/examples.md` for detailed examples of right/wrong formats for each commit type.
