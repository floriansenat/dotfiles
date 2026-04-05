---
name: develop:forge
description: Workflow for implementing a Linear ticket from scratch. Use when the user asks to work on a ticket, start implementing a feature, or pick up a Linear issue. Covers fetching the ticket from the current jj bookmark, validating the proposed approach against the codebase, planning tests, and proceeding to implementation.
---

1. Get the current jj bookmark, fetch the associated Linear ticket.
2. Read the description and understand the need.
3. Check the codebase to verify the proposed approach matches actual conventions (patterns, base classes, helper methods). If mismatches are found, update the ticket on Linear and ask the user before proceeding.
4. Plan the tests: identify unit vs functional tests, which builders need updating, and which branches to cover. Add the test plan to the ticket if missing.
5. Confirm with the user, then implement.
