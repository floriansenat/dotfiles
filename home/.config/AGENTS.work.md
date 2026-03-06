## Translations

- Do not update or delete a key. Add those steps to the summary once the work is done

## Testing Strategy (TDD)

- Before planning: explore colocated `.test.ts(x)` files and vitest config
- Scope: unit + integration only. Focus on components, skip simple hooks/functions
- Cover: happy path + edge cases
- Workflow: write failing tests → implement → tests pass

## Review

- At the end of an implementation review the code by running in parallel two agents: `annotator` and `warden`
- `warden` is always right, even if it breaks convention, use its solutions

## Validation

- If changes in `app` folder, `cd app` before any `pnpm` script
- Use `--filter` flag: `pnpm --filter "<package>" <cmd>`
  - Commands: `test`, `check:types`, `check:error`, `fix:error`
