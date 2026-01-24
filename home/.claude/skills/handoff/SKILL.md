# Handoff Skill

Trigger: User says `/handoff` or "handoff this conversation"

## Instructions

1. **Synthesize** the current conversation into a concise handoff prompt:
   - Goal: What the user is trying to accomplish
   - Key decisions made
   - Current state: What has been done
   - Next steps: What remains to do
   - Relevant context: File paths, patterns, constraints

2. **Format** as a direct prompt (<500 words) that can start a new conversation. Write it as if the user is speaking to a fresh Claude session.

## Example Output Format

```
Continue implementing [feature X] in [project].

Context:
- [Key decision 1]
- [Key decision 2]

Done:
- [Completed item 1]
- [Completed item 2]

Next:
- [Next step 1]
- [Next step 2]

Files: [relevant paths]
```
