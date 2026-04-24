---
name: plan:tasks
description: Read validated requirements.md and design.md, decompose into an ordered list of atomic, self-contained tasks with dependency tracking and inline acceptance criteria. Use after design is validated, before implementation.
---

Read `<feature>/requirements.md` and `<feature>/design.md`. Both must exist.

Decompose into atomic, self-contained tasks. Each task is one logical unit of work that can be implemented and verified independently — suitable for becoming a standalone ticket (Linear, Jira).

For each task produce:
- Imperative title (Create X, Add Y)
- 1-2 sentence description (what and why, never where)
- Ordered implementation steps (abstract, no file paths)
- Dependencies on other tasks (must form a DAG)
- Inline acceptance criteria pulled from requirements (observable, verifiable)

Task quality rules:
- Atomic: if splittable into independent parts, split it
- Self-contained: description + acceptance criteria enough to implement alone
- Ordered: foundation before consumers (data model → logic → surface)
- Full coverage: every requirement covered by at least one task (validate internally)
- Testable: each criterion is verifiable (state change, API response, behavior)
- A task is NOT a file change, tool invocation, or standalone test

Write to `<feature>/tasks.md` using this format:

    # Implementation Plan

    ## Task 1: <imperative title>

    <description>

    **Steps:**
    - step 1
    - step 2

    **Depends on:** none | Task N, Task M

    **Acceptance criteria:**
    - criterion 1
    - criterion 2

Present full task list for review. Iterate on user feedback (reorder, merge, split, add, remove). Write only after explicit user validation.
