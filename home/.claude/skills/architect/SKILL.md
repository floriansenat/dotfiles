---
name: architect
description: Prepare implementation prerequisites from Linear tickets. Use when user provides LTID (e.g., "ENG-123") or explicitly requests ticket preparation. Sets up branch, fetches requirements, explores codebase, creates implementation plan. DO NOT use for direct implementation requests without ticket reference - use EnterPlanMode instead.
context: fork
agent: plan
model: claude-haiku-4-5
---

# Architect

## Workflow

### 1. Detect VCS

Detect which VCS is used (`jj` or `git`) and save for later use:

```bash
if command -v jj &> /dev/null && [ -d ".jj" ]; then
  VCS="jj"
else
  VCS="git"
fi
```

Use `$VCS` throughout workflow instead of detecting each time.

### 2. Create Branch/Bookmark

Run `scripts/create_branch.sh` with LTID using detected VCS:

```bash
./scripts/create_branch.sh <LTID>
```

Script uses `$VCS` variable to select jj or git commands.

### 3. Fetch Linear Ticket

Use Linear MCP to fetch ticket content by LTID. Extract:

- Requirements/acceptance criteria
- Technical constraints
- Dependencies/blockers
- Context/background

### 4. Explore Codebase

See [exploration-guide.md](references/exploration-guide.md) for detailed approach.

**Quick checklist:**
- Related code and patterns
- Architecture/dependencies
- Identify impacted packages (e.g., @myapp/feature)
- Testing approach
- Config/migrations needed

Match exploration depth to ticket complexity.

### 5. Create Plan

Write concise plan with:

1. **Packages** - List impacted packages (e.g., @myapp/feature, @myapp/backend)
2. **Summary** - What's being built (1-2 sentences)
3. **Approach** - Implementation strategy
4. **Steps** - Numbered action items (each step can be a section in the plan or an item in the todo list)
5. **Testing** - Verification approach
6. **Unresolved Questions** - List anything unclear/undecided

Format plan per user's CLAUDE.md preferences if available.

Create a `plan.md` at the root of the repository.

## Error Handling

- **Linear MCP unavailable**: Inform user, request manual ticket info
- **LTID not found**: Verify ID format and permissions
- **No VCS detected**: Report error from create_branch.sh
