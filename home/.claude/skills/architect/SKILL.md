---
name: architect
description: Prepare implementation prerequisites from Linear tickets. Use when user provides LTID (e.g., "ENG-123") or explicitly requests ticket preparation. Sets up branch, fetches requirements, explores codebase, creates implementation plan. DO NOT use for direct implementation requests without ticket reference - use EnterPlanMode instead.
context: fork
agent: plan
model: claude-haiku-4-5
---

# Architect

## Workflow

### 1. Create Branch/Bookmark

Run `scripts/create_branch.sh` with LTID:

```bash
./scripts/create_branch.sh <LTID>
```

Handles both jj and git automatically.

### 2. Fetch Linear Ticket

Use Linear MCP to fetch ticket content by LTID. Extract:

- Requirements/acceptance criteria
- Technical constraints
- Dependencies/blockers
- Context/background

### 3. Explore Codebase

See [exploration-guide.md](references/exploration-guide.md) for detailed approach.

**Quick checklist:**
- Related code and patterns
- Architecture/dependencies
- Identify impacted packages (e.g., @myapp/feature)
- Testing approach
- Config/migrations needed

Match exploration depth to ticket complexity.

### 4. Create Plan

Write concise plan with:

1. **Packages** - List impacted packages (e.g., @myapp/feature, @myapp/backend)
2. **Summary** - What's being built (1-2 sentences)
3. **Approach** - Implementation strategy
4. **Steps** - Numbered action items
5. **Testing** - Verification approach
6. **Unresolved Questions** - List anything unclear/undecided

Format plan per user's CLAUDE.md preferences if available.

Create a `plan.md` at the root of the repository.

## Error Handling

- **Linear MCP unavailable**: Inform user, request manual ticket info
- **LTID not found**: Verify ID format and permissions
- **No VCS detected**: Report error from create_branch.sh
