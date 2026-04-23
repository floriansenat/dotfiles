---
name: act:review
description: Review local working changes for security risks, logic errors, edge cases, internal guidelines compliance, and test coverage gaps. Dispatches parallel subagents and produces structured markdown report. Invoke when user asks to review code, review changes, or audit current diff.
---

# Code Review

## Phase 1: Context Gathering

1. Run both:
   - `jj diff --git` → save as DIFF. If empty, stop: "No changes to review."
   - `jj log -r @ --no-graph -T 'change_id.short() ++ "\n" ++ description.first_line()'` → extract CHANGE_ID (line 1) and CHANGE_DESC (line 2)

2. From diff, extract changed files with path, language, lines added/removed. Count TOTAL_LINES. Note binary files as "not reviewed."

3. Read project CLAUDE.md. If `.packmind/` exists, read all files inside — these are team coding practices.

## Phase 2: Subagent Dispatch

Dispatch both agents in parallel with `run_in_background: true`. Create `/tmp/code-review-CHANGE_ID/` for intermediate files.

If TOTAL_LINES > 500 or context would exceed ~80k tokens, split warden into batches of ~200 lines each.

### Warden (`subagent_type: "warden"`)

Include in prompt: changed file list, diff (full or batch), CLAUDE.md content, packmind practices if any.

Instruct warden to:
- **Read full file content** for each changed file (not just diff hunks)
- Focus on: security vulnerabilities, logic errors, edge cases, convention violations from guidelines
- For each finding report: Category (SECURITY | LOGIC | EDGE_CASE | GUIDELINE), file:line, severity (HIGH | MEDIUM | LOW), problematic code snippet, suggested fix
- Write findings to `/tmp/code-review-CHANGE_ID/warden-findings.md` (or `warden-findings-N.md` per batch)

### Test Coverage (`subagent_type: "general-purpose"`)

Include in prompt: changed file list with paths.

Instruct agent to:
- Find test files for each changed file, flag missing ones
- Identify untested code paths, edge cases, critical paths (error handling, auth, data mutation)
- For each gap: file:line of untested code, what's missing, suggested test case, target test file
- Write findings to `/tmp/code-review-CHANGE_ID/test-findings.md`

## Phase 3: Report

Read all findings from `/tmp/code-review-CHANGE_ID/`. If same file+line flagged by both agents, keep warden's version and note "corroborated by test coverage analysis."

Generate report:

```markdown
# Code Review — CHANGE_DESC

**Change**: CHANGE_ID | **Scope**: N files, +N/-N lines [N binary skipped] | **Date**: YYYY-MM-DD

---

## Security / Logic & Correctness / Edge Cases / Internal Guidelines

Per section — **Status**: ✅ No issues | ⚠️ N issues | ❌ N critical

### PREFIX-N: [title]
**File**: path:line | **Severity**: High/Medium/Low
**Code**: [snippet]
**Suggestion**: [fix]

Prefixes: SEC-, LOGIC-, EDGE-, GUIDE-. For GUIDE findings, reference the specific rule violated.

---

## Test Coverage

**Status**: ✅ No gaps | ⚠️ N gaps

### TEST-N: [description]
**Untested code**: path:line | **What's missing**: [desc]
**Suggested test**: [case] | **Test file**: path

---

## Summary

| Category | Status | Issues |
|----------|--------|--------|
| Security / Logic / Edge Cases / Guidelines / Test Coverage | icon | N |

**Verdict**:
- ✅ **PASS**: zero High or Medium issues
- ⚠️ **PASS WITH NOTES**: zero High, one+ Medium or Low
- ❌ **NEEDS WORK**: one+ High severity issues
```

## Phase 4: Output

1. Save report to `/tmp/code-review-YYYY-MM-DD-CHANGE_ID.md`
2. Clean up `rm -rf /tmp/code-review-CHANGE_ID/`
3. Print summary to terminal:

```
Review complete. N issues found.
  Security: N | Logic: N | Edge Cases: N | Guidelines: N | Tests: N gaps
Full report: /tmp/code-review-YYYY-MM-DD-CHANGE_ID.md
```
