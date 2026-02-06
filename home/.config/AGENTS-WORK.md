## Filesystem

- Prefer kebab-case for file names

## Typescript

- Use interface for objects
- Do not prefix with `I` or `T` interfaces or types. Find a descriptive name if there is name-clash

## React

- Never add `<Component>.displayName`
- Never create a component inside a component
- Component name should always be in pascal-case

## Translations

- Only modify `**/**/common.en.json` files when in need to add translation keys
- Do not update or delete a key. Add those steps to the summary once the work is done

## Review

- At the end of an implementation review the code by running in parallel two agents: `annotator` and `warden`

## Validation

- If file changes are in `app` folder, you MUST `cd` into `app` first before launching `pnpm` scripts
- To target a specific package, use the `--filter` flag. Exemple: `pnpm --filter "@yousign/main" <command>`
- To test use `pnpm --filter "<package>"` test
- To check types errors use `pnpm --filter "<package>"` check:types
- To lint with biome use `pnpm --filter "<package>"` check:error
- To fix with biome use `pnpm --filter "<package>"` fix:error
