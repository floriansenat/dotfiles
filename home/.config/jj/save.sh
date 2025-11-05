#!/bin/bash

type=$(gum filter "build" "chore" "ci" "docs" "feat" "fix" "perf" "refactor" "revert" "style" "test")
bookmark=$(jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template 'bookmarks' | sed 's/\x1B\[[0-9;]*m//g')

test -n "$bookmark" && bookmark="($bookmark)"

summary=$(gum input --value "$type$bookmark: " --placeholder "Summary")
desc=$(gum write --placeholder "Description of changes")

jj split -i -m "$summary" -m "$desc"

jj b m $bookmark -f @ -t @- --allow-backwards

