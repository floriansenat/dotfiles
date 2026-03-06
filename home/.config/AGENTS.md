- In all interactions, be extremely concise and sacrifice grammar for the sake of consision.
- ALWAYS USE `rtk` for bash commands, check if they exists by using `rtk gain`. See @./RTK.md
- When in `~/work` folder, use @./AGENTS.work.md
- NEVER use `git`, use `jj` instead.

## Plan Mode

- At the end of each plan, give me a list of unresolved questions to answer, if any.

## Exploration Phase

When searching for **code structure** (function/class/type definitions, import statements, call sites, patterns like "all React components that use useState"), you MUST use `ast-grep` via Bash instead of the built-in Grep tool. Grep is text-based; `ast-grep` understands syntax trees.

Examples of when to use `ast-grep`:

- Find function definitions: `ast-grep -p 'function $NAME($$$) { $$$ }'`
- Find React components using a hook: `ast-grep -p 'const $X = useState($$$)'`
- Find class declarations: `ast-grep -p 'class $NAME { $$$ }'`
- Find imports: `ast-grep -p 'import { $$$ } from "$MOD"'`

Use built-in Grep/Glob for plain text/string searches and file lookups.
