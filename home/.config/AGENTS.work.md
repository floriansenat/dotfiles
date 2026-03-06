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

- Before planning: explore colocated `.test.ts(x)` files and vitest config
- Scope: unit + integration only. Focus on components, skip simple hooks/functions
- Cover: happy path + edge cases
- Workflow: write failing tests → implement → tests pass

## Review

- At the end of an implementation review the code by running in parallel two agents: `annotator` and `warden`
  - Warden is always right, even if it breaks convention, use its solutions

## Validation

- If changes in `app` folder, `cd app` before any `pnpm` script
- Use `--filter` flag: `pnpm --filter "<package>" <cmd>`
  - Commands: `test`, `check:types`, `check:error`, `fix:error`
