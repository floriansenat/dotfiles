# Code Review Skill — Design Spec

**Date**: 2026-04-22
**Status**: Reviewed

---

## Purpose

Skill that reviews local working changes for security risks, logic errors, edge cases, internal guidelines compliance, and test coverage gaps. Dispatches parallel subagents and produces a structured markdown report saved to file.

## Invocation

- **Trigger**: `/code-review` or user asks to review code/changes
- **Skill location**: `home/.claude/skills/code-review/SKILL.md`
- **Input**: `jj diff --git` (local working changes in unified diff format)

## Architecture

Orchestrator pattern: skill gathers context, dispatches two parallel subagents, aggregates results into structured report.

```
/code-review
    |
    v
[Context Gathering]
    |-- jj diff --git (abort if empty)
    |-- parse changed files (path, language, lines; skip binary files)
    |-- read CLAUDE.md
    |-- check .packmind/ (load all practices if exists)
    |-- create /tmp/code-review-<change-id>/ working directory
    |
    v
[Parallel Dispatch] (multiple Agent tool calls in same turn, run_in_background: true)
    |-- Warden subagent (security, logic, quality, guidelines)
    |-- Test Coverage agent (missing tests, untested paths)
    |   timeout: 5 minutes per agent
    |
    v
[Aggregation]
    |-- read agent outputs (handle missing outputs gracefully)
    |-- deduplicate findings by (file, line_range, category) tuple
    |-- categorize & assign severity
    |-- generate structured report
    |-- save to /tmp/code-review-<date>-<change-id>.md
    |-- cleanup working directory
    |-- print summary to terminal
```

## Phase 1: Context Gathering

### Step 1 — Get diff
```bash
jj diff --git
```
Uses `--git` flag to produce standard unified diff format, parseable by standard tools.
If diff is empty, abort: "No changes to review."

### Step 2 — Identify changed files
Parse diff output. For each file: path, detected language, lines added/removed.
**Binary files**: Detect "Binary files differ" entries. Skip them from review, note in report as "not reviewed — binary."

### Step 3 — Get change metadata
```bash
jj log -r @ --no-graph -T 'change_id.short() ++ "\n" ++ description.first_line()'
```
Captures short change ID (e.g., `kptxoust`) for filename and change description for report header.

### Step 4 — Load guidelines
1. Read project CLAUDE.md (current working directory)
2. Check for `.packmind/` folder
   - If exists: load all available Packmind practices/skills. Let warden filter by relevance during review.
   - If not: skip, rely on CLAUDE.md only

### Step 5 — Create working directory
```bash
mkdir -p /tmp/code-review-<change-id>/
```
Unique per change. All subagent outputs go here. Cleaned up after aggregation.

### Step 6 — Prepare review packages
Bundle diff + guidelines into prompts for each subagent.

**Prompt size guard**: If total prompt (diff + guidelines + instructions) exceeds ~80k tokens, force warden splitting regardless of line count threshold.

## Phase 2: Subagent Dispatch

Two agents dispatched in parallel via multiple Agent tool calls in the same response turn, each with `run_in_background: true`. The Agent tool natively supports this parameter.

### Agent 1: Warden (enhanced)

| Field | Value |
|---|---|
| **Type** | `warden` subagent (registered Claude Code subagent type) |
| **Focus** | Bugs, logic errors, security vulnerabilities, code quality, CLAUDE.md + Packmind guidelines |
| **Tools available** | Read, Glob, Grep, Bash |
| **Output** | `/tmp/code-review-<change-id>/warden-findings.md` |
| **Timeout** | 5 minutes |

`warden` is a built-in Claude Code subagent type specified via `subagent_type: "warden"` in the Agent tool. It uses confidence-based filtering to report only high-priority issues.

Warden prompt includes:
- Full diff (or batched — see threshold below)
- List of changed files with languages
- Instruction to also check CLAUDE.md conventions and `.packmind/` practices if present
- Instruction to write findings to output file path

### Agent 2: Test Coverage

| Field | Value |
|---|---|
| **Type** | `general-purpose` agent |
| **Focus** | Missing tests, untested code paths, edge case coverage |
| **Tools available** | All |
| **Output** | `/tmp/code-review-<change-id>/test-findings.md` |
| **Timeout** | 5 minutes |

Test coverage agent:
- Reads changed files in the actual codebase (not just diff)
- Identifies corresponding test files (or their absence)
- Analyzes new code paths and branches
- Suggests specific test cases to add
- Reports existing test coverage gaps for changed code
- Writes findings to output file path

### Threshold-Based Warden Splitting

Single axis: **line count**.

- **<= 500 lines changed**: single warden instance, full diff
- **> 500 lines changed**: split diff into batches of ~200 lines each, dispatch multiple warden agents in parallel
- Each warden batch writes to `/tmp/code-review-<change-id>/warden-findings-{N}.md`
- Each batch includes full file context for files it reviews (not just the changed lines)

### Agent Failure Handling

- **Timeout**: If an agent exceeds 5 minutes, terminate it. Mark that review section as "timed out" in report.
- **Missing output**: If expected output file is missing after agent completes, mark section as "agent failed — no output" in report.
- **Partial results**: Always produce a report with whatever results are available. Never block on a failed agent.

## Phase 3: Report Aggregation

After all agents complete (or timeout):

1. **Read** all output files from `/tmp/code-review-<change-id>/`
2. **Deduplicate** — key: `(file_path, line_range ±5 lines, category)` tuple. If warden and test agent flag overlapping issue, keep warden's version and note "corroborated by test coverage analysis"
3. **Categorize** into sections: Security, Logic & Correctness, Edge Cases, Internal Guidelines, Test Coverage
4. **Assign severity**: High / Medium / Low (see rules below)
5. **Generate** structured markdown report

### Report Format

```markdown
# Code Review — [change description from jj]

**Change**: [short change ID]
**Scope**: N files changed, N additions, N deletions (N binary files skipped)
**Reviewer**: Claude (automated)
**Date**: YYYY-MM-DD

---

## Security

**Status**: [icon] N issues found | No issues found

### SEC-N: [title]
**File**: `path/to/file:line`
**Severity**: High | Medium | Low
**Code**:
[relevant code snippet]
**Suggestion**: [concrete fix]

---

## Logic & Correctness

[same structure]

---

## Edge Cases

[same structure]

---

## Internal Guidelines

[same structure, references specific CLAUDE.md or Packmind rule violated]

---

## Test Coverage

[same structure, suggests specific tests to add]

---

## Summary

| Category | Status | Issues |
|---|---|---|
| Security | [icon] | N |
| Logic | [icon] | N |
| Edge Cases | [icon] | N |
| Guidelines | [icon] | N |
| Tests | [icon] | N |

**Verdict**: PASS | PASS WITH NOTES | NEEDS WORK — N issues (breakdown by severity)
```

### Status Icons
- No issues: check mark
- Issues found: warning
- Critical issues: cross mark

### Severity Rules
- **High**: Security vulnerabilities, data loss risks, unbounded operations
- **Medium**: Logic errors, null dereferences, missing error handling
- **Low**: Convention violations, naming issues, minor quality concerns
- **Test gaps**: Reported separately, no severity — listed as missing tests

### Verdict Rules
- **PASS**: Zero High or Medium issues, zero or more Low issues only
- **PASS WITH NOTES**: Zero High issues, one or more Medium or Low issues
- **NEEDS WORK**: One or more High severity issues

## Phase 4: Output

1. **Write report** to `/tmp/code-review-<YYYY-MM-DD>-<change-id>.md`
2. **Cleanup** intermediate files: `rm -rf /tmp/code-review-<change-id>/`
3. **Print summary** to terminal:

```
Review complete. N issues found.
  Security: N (severity)
  Logic: N (severity)
  Edge Cases: N (severity)
  Guidelines: N (severity)
  Tests: N gaps

Full report: /tmp/code-review-2026-04-22-kptxoust.md
```

## Non-Goals (v1)

- No code execution / running tests (static analysis only)
- No MR/PR comment posting
- No Packmind API integration (uses local `.packmind/` skills only)
- No incremental review (always reviews full `jj diff --git`)
- No auto-fix suggestions (report only)

## Future Considerations

- v2: Run test suite after review
- v2: Post findings as MR comments via GitLab API
- v2: Track review history over time
- v2: Auto-fix for simple issues (formatting, naming)

## Resolved Questions

1. **jj diff format**: Use `jj diff --git` for standard unified diff output.
2. **Report naming**: Use jj change ID short form via `jj log -r @ --no-graph -T change_id.short()`.
3. **Packmind loading**: Load all practices if `.packmind/` exists; let warden filter by relevance. No need to pre-filter by file type.
4. **Warden dispatch**: `warden` is a built-in Claude Code subagent type, invoked via `subagent_type: "warden"` in the Agent tool.

## Unresolved Questions

1. **Packmind skill format**: Need to verify actual structure of `.packmind/` folder in a project that uses it. What do the files look like? This doesn't block implementation — skill can list and read whatever is there — but knowing the format upfront helps write a better warden prompt.
2. **Report retention**: Left to OS temp cleanup (`/tmp/` is ephemeral). Acceptable for v1.
