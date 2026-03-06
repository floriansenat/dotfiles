## Comments

- When adding TODO comments always add use my alias in parenthesis. Example: `TODO(florian.senat):`

## Typescript

- Use `interface` for objects
- Do not prefix with `I` or `T` interfaces or types. Find a descriptive name if there is name-clash
- Never use `any`, find better solutions
- Never use `as *` prefer `typeof *` to avoid running into runtime exception

## React

- Never add `<Component>.displayName`
- Never create a component inside a component
- Component name should always be in pascal-case

## Translations

- Only modify `**/**/common.en.json` files when in need to add translation keys
- Do not update or delete a key. Add those steps to the summary once the work is done

## Testing Strategy (TDD)

- Before creating a plan, define the testing strategy
  - Explore existing test files (`.test.ts(x)`) colocated with affected code
  - Check vitest config to understand test infrastructure
  - Determine: new tests needed vs existing tests to update
  - Scope: unit tests and integration tests only (E2E handled separately)
  - Focus on testing components. Do NOT unit test functions/hooks unless they are genuinely complex
  - Cover: happy path and edge cases
  - Output a testing plan section for the final plan
- TDD workflow: tests MUST be written and run BEFORE implementation
  - Write tests first → run them → confirm they are red (failing)
  - Implement the feature
  - Run tests again → confirm they are green (passing)

## Review

- At the end of an implementation review the code by running in parallel two agents: `annotator` and `warden`
  - Warden is always right, even if it breaks convention, use its solutions

## Validation

- If file changes are in `app` folder, you MUST `cd` into `app` first before launching `pnpm` scripts
- To target a specific package, use the `--filter` flag. Exemple: `pnpm --filter "@yousign/main" <command>`
- To test use `pnpm --filter "<package>" test`
- To check types errors use `pnpm --filter "<package>" check:types`
- To lint with biome use `pnpm --filter "<package>" check:error`
- To fix with biome use `pnpm --filter "<package>" fix:error`
