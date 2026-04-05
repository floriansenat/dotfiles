---
name: spec:analyse
description: Work relentlessly with the user to turn a feature idea, product request, or rough prompt into a concise PRD. Use when the goal is to clarify business needs, users, scope, constraints, success criteria, and open questions before technical design.
---

Interview the user relentlessly until you reach a shared business understanding of the feature.

Drive toward a concise PRD covering:
- problem and business goal
- target users and use cases
- scope and non-goals
- business constraints, dependencies, and risks
- success criteria
- open questions

Resolve ambiguity one branch at a time. Push on vague statements, hidden assumptions, conflicting goals, and missing constraints.

Do not jump into implementation or architecture. This skill is for business understanding; technical design and ADR work come later with `spec:design`.

Research external context when useful to understand the domain or sharpen the PRD. Parallelize research as much as possible with sub-agents.

Write the final PRD to `<feature>/PRD.md` only after explicit user validation. End the document with a `Sources` section listing any web or document sources used.
