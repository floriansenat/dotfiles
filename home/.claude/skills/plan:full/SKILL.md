---
name: plan:full
description: Run the full planning pipeline — requirements, design, tasks — in sequence with user gates between phases. Use when starting a feature from scratch and want the complete spec-driven workflow.
---

Run the full planning pipeline for a feature.

Pipeline:
1. Invoke `plan:requirements` → produces `<feature>/requirements.md`
2. Gate: ask user to confirm before proceeding to design
3. Invoke `plan:design` → produces `<feature>/design.md`
4. Gate: ask user to confirm before proceeding to tasks
5. Invoke `plan:tasks` → produces `<feature>/tasks.md`

At each gate, ask: "Requirements done. Ready to move to design?" / "Design done. Ready to move to tasks?"

User can stop at any gate. Each phase runs fully — the orchestrator does not interfere with sub-skill behavior.
