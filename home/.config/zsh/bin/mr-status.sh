#!/usr/bin/env bash
# Show GitLab MR status (approvals, comments, conflicts) for active local jj bookmarks

set -euo pipefail

PROJECT="kalos%2Fapp"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

# Get active bookmarks (skip deleted ones)
bookmarks=$(jj bookmark list 2>/dev/null | grep -v '(deleted)' | grep -v '@origin' | grep -v '^  ' | grep -v '^Hint:' | awk -F: '{print $1}' | xargs)

if [[ -z "$bookmarks" ]]; then
  echo "No active bookmarks found."
  exit 0
fi

echo -e "${BOLD}MR Status for local bookmarks${NC}"
echo ""

for branch in $bookmarks; do
  mr_json=$(glab api "projects/$PROJECT/merge_requests?source_branch=$branch&state=opened&per_page=1" 2>/dev/null || echo "[]")

  mr_data=$(echo "$mr_json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data:
    mr = data[0]
    print(f\"{mr['iid']}|{mr['title']}|{mr.get('draft', False)}|{mr.get('has_conflicts', False)}|{mr.get('user_notes_count', 0)}|{mr['web_url']}\")
else:
    print('none')
" 2>/dev/null || echo "error")

  if [[ "$mr_data" == "none" ]]; then
    echo -e "  ${BOLD}$branch${NC}  ${GRAY}— no open MR${NC}"
    continue
  elif [[ "$mr_data" == "error" ]]; then
    echo -e "  ${BOLD}$branch${NC}  ${RED}— error fetching MR${NC}"
    continue
  fi

  IFS='|' read -r iid title draft has_conflicts notes_count url <<< "$mr_data"

  # Fetch approvals
  approval_json=$(glab api "projects/$PROJECT/merge_requests/$iid/approvals" 2>/dev/null || echo "{}")
  approval_data=$(echo "$approval_json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
approved = data.get('approved', False)
approvers = [a['user']['name'] for a in data.get('approved_by', [])]
print(f\"{approved}|{','.join(approvers)}\")
" 2>/dev/null || echo "False|")

  IFS='|' read -r approved approvers <<< "$approval_data"

  # Build status line
  flags=""

  if [[ "$draft" == "True" ]]; then
    flags+=" ${GRAY}[draft]${NC}"
  fi

  if [[ "$approved" == "True" ]]; then
    flags+=" ${GREEN}✓ approved${NC}"
    if [[ -n "$approvers" ]]; then
      flags+=" ${GRAY}(${approvers})${NC}"
    fi
  else
    flags+=" ${YELLOW}◌ pending review${NC}"
  fi

  if [[ "$notes_count" -gt 0 ]]; then
    flags+=" ${BLUE}💬 ${notes_count}${NC}"
  fi

  if [[ "$has_conflicts" == "True" ]]; then
    flags+=" ${RED}⚠ conflicts${NC}"
  fi

  echo -e "  ${BOLD}$branch${NC} ${flags}"
  echo -e "    ${GRAY}!${iid} ${title}${NC}"
  echo -e "    ${GRAY}${url}${NC}"
  echo ""
done
