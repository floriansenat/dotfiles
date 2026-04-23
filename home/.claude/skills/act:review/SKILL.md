---
name: act:review
description: >
  Review local working changes for security risks, logic errors, edge cases,
  internal guidelines compliance, and test coverage gaps. Dispatches parallel
  subagents and produces structured markdown report. Invoke when user asks
  to review code, review changes, or runs /code-review.
---

# Code Review

Placeholders like CHANGE_ID, CHANGE_DESC, DIFF are symbolic — substitute actual values captured during Phase 1.

## Phase 1: Context Gathering

### Step 1 — Get diff and change metadata

Run both commands:

    jj diff --git

    jj log -r @ --no-graph -T 'change_id.short() ++ "\n" ++ description.first_line()'

If diff is empty, stop: "No changes to review."

Save these values for use throughout the skill:
- CHANGE_ID: short change ID from jj log (first line, e.g., kptxoust)
- CHANGE_DESC: change description from jj log (second line)
- DIFF: full diff output

### Step 2 — Parse changed files

From the diff, extract list of changed files. For each: path, detected language, lines added/removed.

**Binary files**: If a file shows "Binary files differ", skip it. Note it as "not reviewed — binary" for the report.

Count total lines changed (additions + deletions). Save as TOTAL_LINES.

### Step 3 — Load guidelines

1. Read project CLAUDE.md in the current working directory.
2. Check if `.packmind/` folder exists.
   - If yes: list all files in `.packmind/`, read their contents. These are team coding practices. Include them as additional guidelines for the warden.
   - If no: skip. CLAUDE.md is the only guidelines source.

### Step 4 — Create working directory

    mkdir -p /tmp/code-review-CHANGE_ID/

### Step 5 — Prepare review packages

Bundle the diff, file list, and guidelines into the prompts for each subagent (see Phase 2 templates).

**Prompt size guard**: Estimate the total token count of diff + CLAUDE.md + Packmind content. If it exceeds ~80k tokens, force warden splitting (see Phase 2) regardless of TOTAL_LINES.

## Phase 2: Subagent Dispatch

Dispatch two agents in parallel: make both Agent tool calls in the same response, both with `run_in_background: true`.

### Warden splitting decision

- If TOTAL_LINES <= 500 AND prompt size is under ~80k tokens: dispatch ONE warden with full diff.
- If TOTAL_LINES > 500 OR prompt exceeds ~80k tokens: split files into batches of ~200 lines each. Dispatch one warden per batch.

### Agent 1: Warden

Dispatch using the Agent tool with `subagent_type: "warden"` and `run_in_background: true`.

For each file in the batch, use the Read tool to read its full content before reviewing — do not rely only on the diff hunks. The diff shows what changed; the full file provides context for understanding whether the change is correct.

Prompt for warden (substitute actual values for placeholders):

> Review the following code changes for bugs, logic errors, security vulnerabilities, code quality issues, and adherence to project conventions.
>
> **Changed files**: [LIST OF FILES WITH LANGUAGES]
>
> **Diff**:
>
>     [DIFF CONTENT — full or batch]
>
> **Project guidelines (CLAUDE.md)**:
>
>     [CLAUDE.md CONTENT]
>
> [IF PACKMIND EXISTS]
> **Team practices (.packmind/)**:
>
>     [PACKMIND PRACTICES CONTENT]
>
> [END IF]
>
> **Important**: For each changed file, use the Read tool to read the full file content so you have context beyond the diff.
>
> Focus areas:
> - Security vulnerabilities (injection, XSS, hardcoded secrets, auth bypass)
> - Logic errors (unbounded loops, off-by-one, null dereferences, silent error swallowing)
> - Edge cases (empty inputs, boundary values, concurrent access)
> - Convention violations from CLAUDE.md and team practices
>
> For each finding, report:
> - Category: SECURITY | LOGIC | EDGE_CASE | GUIDELINE
> - File and line number
> - Severity: HIGH | MEDIUM | LOW
> - Description of the issue
> - The problematic code snippet
> - Suggested fix
>
> Use the Write tool to save all findings to: /tmp/code-review-CHANGE_ID/warden-findings.md
>
> If no issues found, write "No issues found." to the output file.

If splitting into multiple wardens, each batch writes to /tmp/code-review-CHANGE_ID/warden-findings-N.md (where N is the batch number).

### Agent 2: Test Coverage

Dispatch using the Agent tool with `subagent_type: "general-purpose"` and `run_in_background: true`.

Prompt for test coverage agent (substitute actual values):

> Analyze the following code changes for test coverage gaps.
>
> **Changed files**: [LIST OF FILES WITH PATHS]
>
> For each changed file:
> 1. Find corresponding test file(s) in the codebase (use Glob to search for test files matching the source file name).
> 2. If no test file exists, flag it.
> 3. Read the changed code and identify:
>    - New code paths (branches, functions) that lack tests
>    - Edge cases that should be tested but aren't
>    - Critical paths (error handling, auth, data mutation) without coverage
> 4. For each gap, suggest a specific test case: what to test, expected behavior, and which test file it belongs in.
>
> For each finding, report:
> - File and line number (of the untested code)
> - What is missing (new function untested, branch not covered, edge case, etc.)
> - Suggested test case description
> - Which test file should contain it
>
> Use the Write tool to save all findings to: /tmp/code-review-CHANGE_ID/test-findings.md
>
> If no gaps found, write "No test coverage gaps found." to the output file.

### Timeout handling

Wait for both agents to complete. If an agent has not completed after 5 minutes, stop waiting for it. Mark its section as "timed out" in the report.

## Phase 3: Report Aggregation

After all agents complete (or timeout):

### Step 1 — Read findings

Read all files in /tmp/code-review-CHANGE_ID/:
- warden-findings.md (or warden-findings-N.md if split)
- test-findings.md

If a file is missing, note: "[section] agent failed — no output."

### Step 2 — Deduplicate

If warden and test-coverage agent flag the same file + line range (within 5 lines) for the same category, keep warden's version. Add note: "corroborated by test coverage analysis."

### Step 3 — Build report

Generate the following markdown report. Use ONLY findings from agent outputs — do not fabricate issues.

Report structure:

    # Code Review — CHANGE_DESC

    **Change**: CHANGE_ID
    **Scope**: N files changed, N additions, N deletions [N binary files skipped if any]
    **Reviewer**: Claude (automated)
    **Date**: [today's date]

    ---

    ## Security

    **Status**: one of: ✅ No issues found | ⚠️ N issues found | ❌ N critical issues

    For each SECURITY finding from warden:

    ### SEC-N: [title]
    **File**: path/to/file:line
    **Severity**: High | Medium | Low
    **Code**:
    [code snippet in a fenced code block]
    **Suggestion**: [concrete fix]

    ---

    ## Logic & Correctness

    **Status**: ✅ | ⚠️ | ❌

    For each LOGIC finding, same structure with LOGIC-N prefix.

    ---

    ## Edge Cases

    **Status**: ✅ | ⚠️ | ❌

    For each EDGE_CASE finding, same structure with EDGE-N prefix.

    ---

    ## Internal Guidelines

    **Status**: ✅ | ⚠️ | ❌

    For each GUIDELINE finding, same structure with GUIDE-N prefix.
    Reference the specific CLAUDE.md rule or Packmind practice violated.

    ---

    ## Test Coverage

    **Status**: ✅ No gaps found | ⚠️ N gaps found

    For each finding from test-coverage agent:

    ### TEST-N: [description]
    **Untested code**: path/to/file:line
    **What's missing**: [description]
    **Suggested test**: [test case description]
    **Test file**: path/to/test_file

    ---

    ## Summary

    | Category       | Status | Issues |
    |---------------|--------|--------|
    | Security       | [icon] | N      |
    | Logic          | [icon] | N      |
    | Edge Cases     | [icon] | N      |
    | Guidelines     | [icon] | N      |
    | Test Coverage  | [icon] | N gaps |

    **Verdict**: [apply verdict rules below]

### Verdict rules

- **✅ PASS**: Zero High or Medium issues. Zero or more Low issues only.
- **⚠️ PASS WITH NOTES**: Zero High issues, one or more Medium or Low issues.
- **❌ NEEDS WORK**: One or more High severity issues.

## Phase 4: Output

### Step 1 — Save report

Use the Write tool to save the complete report to:

    /tmp/code-review-YYYY-MM-DD-CHANGE_ID.md

Where YYYY-MM-DD is today's date and CHANGE_ID is the short change ID from Phase 1.

### Step 2 — Cleanup

Remove the intermediate working directory:

    rm -rf /tmp/code-review-CHANGE_ID/

### Step 3 — Print summary

Print to terminal:

    Review complete. N issues found.
      Security: N (highest severity)
      Logic: N (highest severity)
      Edge Cases: N (highest severity)
      Guidelines: N (highest severity)
      Tests: N gaps

    Full report: /tmp/code-review-YYYY-MM-DD-CHANGE_ID.md
