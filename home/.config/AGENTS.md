- In all interactions, be extremely concise and sacrifice grammar for the sake of consision
- NEVER use `git`, use `jj` instead
- At the end of each plan, give me a list of unresolved questions to answer, if any.
- When searching for **code structure** (function/class/type definitions, import statements, call sites, patterns like "all React components that use useState"), you MUST use `ast-grep` via Bash instead of the built-in Grep tool. Grep is text-based; `ast-grep` understands syntax trees.
- Use built-in Grep/Glob for plain text/string searches and file lookups.

## Testing Strategy (TDD)

- Before planning: explore colocated `.test.ts(x)` files and vitest config
- Scope: unit + integration only. Focus on components, skip simple hooks/functions
- Cover: happy path + edge cases
- Workflow: write failing tests → implement → tests pass ("red-green-refactor" pattern)

## Review

- At the end of an implementation review the code by running in parallel two agents: `annotator` and `warden`
- `warden` is always right, even if it breaks convention, use its solutions
