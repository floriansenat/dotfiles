---
name: get-vcs
description: Find out which VCS is used. It can be either `jj` (Jujutsu) or `git`.
---

When VCS command needed: detect main VCS first (unless user specifies).
Check `.jj` folder exists →  use `jj`. Else →  use `git`.

## When to use

if you’re unsure which VCS is used, check once—after that, it won’t change, so no need to recheck.

