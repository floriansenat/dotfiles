#!/bin/bash

type=$(gum filter "build" "chore" "ci" "docs" "feat" "fix" "perf" "refactor" "revert" "style" "test")
bookmark=$(jj bookmark list 2>/dev/null | grep -v "^$" | head -1 | awk '{print $1}' | tr -d ':')

test -n "$bookmark" && bookmark="($bookmark)"

summary=$(gum input --value "$type$bookmark: " --placeholder "Summary")
desc=$(gum write --placeholder "Description of changes")

jj split -i -m "$summary" -m "$desc"

