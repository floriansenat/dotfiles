# Conventional Commit Examples

## Correct Formats

### Build
- `build: update docker image to node 20`
- `build(dx-1234): add multi-stage build`

### Chore
- `chore: bump dependencies`
- `chore(dx-5678): update eslint config`

### CI
- `ci: add github actions workflow`
- `ci(dx-9012): fix deploy pipeline`

### Docs
- `docs: add contributing guide`
- `docs(dx-3456): update API documentation`

### Feat
- `feat: add dark mode toggle`
- `feat(dx-7890): implement user authentication`

### Fix
- `fix: resolve memory leak in cache`
- `fix(dx-2345): handle null pointer exception`

### Perf
- `perf: optimize database queries`
- `perf(dx-6789): reduce bundle size by 40%`

### Refactor
- `refactor: extract shared utility functions`
- `refactor(dx-0123): reorganize folder structure`

### Revert
- `revert: undo feature launch`
- `revert(dx-4567): rollback auth changes`

### Style
- `style: update button colors`
- `style(dx-8901): refine typography scale`

### Test
- `test: add unit tests for auth`
- `test(dx-2345): improve coverage for payment flow`

## Incorrect Formats

### ❌ Emoji instead of type
- `✨ add feature` ← emoji not valid type
- `🐛 fix bug` ← emoji not valid type

### ❌ Scope after colon
- `feat: (dx-1234) add feature` ← scope must be in parens before colon
- `test: (dx-5678) test update` ← scope placement wrong

### ❌ Missing colon
- `feat(dx-1234) add feature` ← missing `: ` separator
- `test(dx-5678) test update` ← missing `: ` separator

### ❌ Missing title
- `feat:` ← no description
- `fix(dx-1234):` ← no description

### ❌ Invalid type
- `feature: add auth` ← use `feat` not `feature`
- `bug: fix crash` ← use `fix` not `bug`
- `hotfix: urgent fix` ← use `fix` not `hotfix`

### ❌ Invalid scope format
- `feat(DX-1234): add feature` ← uppercase not allowed
- `feat(my feature): add feature` ← spaces not allowed
- `feat(feature_name): add feature` ← underscores not allowed

## With Body and Footer

```
feat(dx-1234): add user authentication

Implement JWT-based authentication with refresh tokens.
Added middleware for protecting routes.

Closes DX-1234
Relates-to: DX-5678
```

```
fix(dx-5678): resolve race condition in cache

The cache update was not atomic, causing inconsistent state
under concurrent access. Added locking mechanism to ensure
atomic updates.

Tested with concurrent load tests.
```
