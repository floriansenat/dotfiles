#!/usr/bin/env bash
# Show GitLab CI pipeline status for all active local jj bookmarks

set -euo pipefail

REPO="kalos/app"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

status_icon() {
  case "$1" in
    success)  echo -e "${GREEN}✓ success${NC}" ;;
    failed)   echo -e "${RED}✗ failed${NC}" ;;
    running)  echo -e "${BLUE}⟳ running${NC}" ;;
    pending|waiting_for_resource|created)
              echo -e "${YELLOW}◌ $1${NC}" ;;
    canceled|canceling)
              echo -e "${GRAY}⊘ $1${NC}" ;;
    *)        echo -e "${GRAY}? $1${NC}" ;;
  esac
}

# Get active bookmarks (skip deleted ones)
bookmarks=$(jj bookmark list 2>/dev/null | grep -v '(deleted)' | grep -v '@origin' | grep -v '^  ' | grep -v '^Hint:' | awk -F: '{print $1}' | xargs)

if [[ -z "$bookmarks" ]]; then
  echo "No active bookmarks found."
  exit 0
fi

echo -e "${BOLD}CI Status for local bookmarks${NC}"
echo ""

for branch in $bookmarks; do
  pipeline_json=$(glab api "projects/kalos%2Fapp/pipelines?ref=$branch&per_page=1" 2>/dev/null || echo "[]")

  status=$(echo "$pipeline_json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data:
    p = data[0]
    print(f\"{p['status']}|{p['created_at']}|{p['web_url']}\")
else:
    print('none')
" 2>/dev/null || echo "error")

  if [[ "$status" == "none" ]]; then
    echo -e "  ${BOLD}$branch${NC}  ${GRAY}— no pipeline${NC}"
  elif [[ "$status" == "error" ]]; then
    echo -e "  ${BOLD}$branch${NC}  ${RED}— error fetching status${NC}"
  else
    IFS='|' read -r state created_at url <<< "$status"
    date_fmt=$(date -jf "%Y-%m-%dT%H:%M:%S" "${created_at%%.*}" "+%d %b %H:%M" 2>/dev/null || echo "$created_at")
    echo -e "  ${BOLD}$branch${NC}  $(status_icon "$state")  ${GRAY}${date_fmt}${NC}  ${GRAY}${url}${NC}"
  fi
done
