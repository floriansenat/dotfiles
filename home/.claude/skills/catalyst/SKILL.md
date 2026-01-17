---
name: catalyst
description: Business-to-ticket workflow that transforms user input (text, links, documents, images) into validated specifications and Linear tickets. Use when converting feature requests, business needs, or project initiatives into tracked work items. Supports parallel business/technical analysis, AI-optimized specifications, human validation, and Linear integration.
model: haiku
---

# Catalyst

Transform ideas into tracked work. Catalyst takes raw input—text, links, documents, images—and converts it into a validated specification and Linear ticket.

## Phase 1: Parallel Analysis

**Goal:** Extract business and technical requirements from user input

**Actions:**
1. Spawn 2 agents in parallel:
   - `catalyst-business`: Analyzes business problem, success metrics, stakeholders, user outcomes, constraints, priorities
   - `catalyst-technical`: Analyzes technical capabilities, data requirements, integration points, constraints, feasibility
2. Wait for both agents to complete
3. Consolidate findings into a structured summary

---

## Phase 2: AI-Optimized Specification

**Goal:** Create specification readable for humans, optimized for AI implementation

**Actions:**
1. Structure specification with clear sections:
   - Business Context (from business agent)
   - Technical Requirements (from technical agent)
   - Success Criteria & Metrics
   - Scope & Boundaries
   - Dependencies & Assumptions
   - Questions for Stakeholder Validation

2. **Iterative Validation Loop:**
   - Present specification to user
   - As user reviews, ask clarifying questions inline as needed
   - Update specification based on feedback
   - Continue until user confirms: "This is complete and accurate"

3. Final specification must include:
   - Clear problem statement
   - Explicit success criteria
   - Technical and business requirements
   - Constraints and assumptions
   - Any open questions resolved

---

## Phase 3: Linear Ticket Creation

**Goal:** Create Linear ticket in correct squad with specification as content

**Prerequisites:** User has validated specification from Phase 2

**Actions:**
1. If user hasn't specified squad:
   - Ask: "Which squad should own this ticket?"
   - Wait for user response

2. Use Linear MCP to create ticket:
   - Title: Concise summary from specification
   - Description: Full validated specification
   - Assign to appropriate squad
   - Set status to "Backlog"

3. Capture ticket response: ticket ID and URL

---

## Phase 4: Confirmation or Error Handling

**Goal:** Confirm success or explain failure

**Actions:**
1. **If ticket created successfully:**
   - Display ticket ID and URL to user
   - Summary: "Ticket created. Team can now begin work."

2. **If ticket creation failed:**
   - Explain the error clearly
   - Suggest next steps (retry, check credentials, etc.)
   - Stop workflow

---

## Key Principles

- **Parallel where possible**: Business and technical analysis run simultaneously
- **Iterative validation**: Ask questions during spec review, don't wait until the end
- **AI-optimized specs**: Clear structure, explicit assumptions, actionable requirements
- **Clear error handling**: Fail fast with helpful messages
- **Linear MCP authentication**: Uses pre-authenticated Linear MCP connection
