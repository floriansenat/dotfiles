## Validation
- When a file is in app folder, always `cd` into app first before launching pnpm scripts
- To target a specific package, use the `--filter` flag. Exemple: `pnpm --filter "@yousign/main" <command>`

- To test use `pnpm --filter "<package>"` test
- To check types errors use `pnpm --filter "<package>"` check:types
- To lint with biome use `pnpm --filter "<package>"` check:error
- To fix with biome use `pnpm --filter "<package>"` fix:error

## Filesystem
- Prefer kebab-case for file names

## Typescript
- Use interface for objects

## React
- Never add `<Component>.displayName`
- Never create a component inside a component
- Component name should always be in pascal-case

## Translations
- Only modify `**/**/common.json` files when in need to add translation keys
- Do not update or delete a key. Add those steps to the summary once the work is done
- Do not prefix with `I` or `T` interfaces or types. Find a descriptive name if there is name-clash

## Browser Test
- When you do frontend work, always test the changes at the end with agent-browser. Use the skill to understand how to use the tool.

