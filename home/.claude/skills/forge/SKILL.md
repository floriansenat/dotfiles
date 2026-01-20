---
name: forge
description: Implementation orchestration skill for executing code changes. Use when user has a plan and wants to implement features, bug fixes, or code changes. Requires plan/context from user. Handles VCS, TDD with Aegis (auto-decides if tests needed), implementation, and code review with Warden. Triggers on "implement this", "forge", "execute this plan".
model: opus
---

# Forge

Implementation orchestrator that executes code changes based on user-provided plan.

## Core Principles

- Assume plan provided: User gives plan/context, you implement it
- Simple and elegant: Prioritize readable, maintainable code
- Use TodoWrite: Track progress throughout

## Phase 1: Prepare local environment

**Goal:** VCS ready before implementation

**Actions:**
1. Generate branch from Linear Id. Use `scripts/create_branch.sh <branch_name>`.

---

## Phase 2: Test-Driven Development

**Goal**: Write tests before implementation

**Actions**:
1. Launch Aegis subagent with plan and context
2. Aegis analyzes plan and decides if tests needed (new features, bug fixes, etc.)
3. If tests created, ensure they fail appropriately (red phase)

---

## Phase 3: Implementation

**Goal**: Build the feature

**Actions**:
1. Read relevant files from plan
2. Implement following plan
3. Follow codebase conventions
4. Update todos as you progress

---

## Phase 4: Quality Review

**Goal**: Ensure code is simple, DRY, elegant, functionally correct

**Actions**:
1. Launch 3 Warden subagents in parallel: simplicity/DRY/elegance, bugs/functional correctness, conventions/abstractions
2. Consolidate findings, identify highest severity issues
3. **Present to user, ask what to do** (fix now, later, or proceed)
4. Address based on decision

---

## Phase 5: Summary

**Goal**: Document what was accomplished

**Actions**:
1. Mark todos complete
2. Summarize: what built, key decisions, files modified, next steps

