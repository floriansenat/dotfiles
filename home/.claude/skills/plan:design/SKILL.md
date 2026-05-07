---
name: plan:design
description: Work relentlessly with the user to turn a validated PRD or feature prompt into a concise ADR. Use when the goal is to explore the codebase, define technical direction, evaluate architecture and data model options, and clarify rollout or migration before implementation.
---

Interview the user relentlessly until you reach a shared technical understanding of the feature.

Use the PRD if one exists; otherwise work directly from the user prompt. Drive toward a concise ADR covering:
- context and technical problem
- relevant existing architecture and code paths
- technical constraints and assumptions
- entity and data model decisions
- system boundaries and integrations
- options considered
- chosen approach and rationale
- risks, trade-offs, rollout, and migration when relevant
- open questions

Resolve ambiguity one branch at a time. Push on vague statements, hidden assumptions, conflicting constraints, and weak rationale.

Do not jump into implementation details. This skill is for technical understanding and design before coding.

Explore the codebase aggressively to understand existing patterns, boundaries, dependencies, and constraints. Research external technical context when useful. Parallelize research as much as possible with sub-agents.

Write the final design document to `<feature>/design.md` only after explicit user validation. End the document with a `Sources` section listing any code, web, or document sources used.
