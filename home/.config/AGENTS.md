- In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of consision.
- ALWAYS USE `rtk` for bash commands if command exists
- When in `~/work` folder, use @./AGENTS.work.md

## Git

- NEVER use `git`, use `jj` instead.

## Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

## Comments

- Add comment when it adds context. Do not add comments if it describes the code below.
- Comments should be about **intent, constraints, and context**, not mechanics. If the code is so complex it needs a play-by-play explanation, refactor the code instead.

## Tooling

### Code structure search: ALWAYS use `ast-grep` via Bash

When searching for **code structure** (function/class/type definitions, import statements, call sites, patterns like "all React components that use useState"), you MUST use `ast-grep` via Bash instead of the built-in Grep tool. Grep is text-based; ast-grep understands syntax trees.

Examples of when to use `ast-grep`:
- Find function definitions: `ast-grep -p 'function $NAME($$$) { $$$ }'`
- Find React components using a hook: `ast-grep -p 'const $X = useState($$$)'`
- Find class declarations: `ast-grep -p 'class $NAME { $$$ }'`
- Find imports: `ast-grep -p 'import { $$$ } from "$MOD"'`

Use built-in Grep/Glob for plain text/string searches and file lookups.

### Other shell tools
- SELECTING from multiple results → pipe to `fzf`
- JSON → `jq`
- YAML/XML → `yq`

