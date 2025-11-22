---
globs:
  - '**/*.ts'
  - '**/*.tsx'
---

Follow these TypeScript conventions:

- Never use the `any` type; Use `unknown` instead
- Never use `enum`; Use const object with `as const` 
- Use `interface` for objects; `type` alias for values
- Use type inference when possible
- Always use return types for functions

