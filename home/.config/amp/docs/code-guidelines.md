---
globs:
  - '**/*.js'
  - '**/*.ts'
  - '**/*.tsx'
  - '**/*.go'
  - '**/*.zig'
---

Follow those code guidelines for every programming languages that support them:

- Handle errors explicitly (fail fast)
- Prefer assertions over try/catch
- Prefer immutability
- Mutation are fine if contained
- Minimize variables scope
- Use short names for near-scope variable; use longer, clearer names as usage distance grows.
- Keep function body ≤60 lines
- Ensure loops are finite
- Push conditions up and for loops down
