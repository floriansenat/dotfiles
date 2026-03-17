#!/usr/bin/env bash
# Dashboard: MR & CI status for v3 jj bookmarks + MRs awaiting my review

set -euo pipefail

PROJECT="kalos%2Fapp"
V3_DIR="$HOME/work/v3"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

ci_icon() {
  case "$1" in
    success)  echo -e "${GREEN}✓${NC}" ;;
    failed)   echo -e "${RED}✗${NC}" ;;
    running)  echo -e "${BLUE}⟳${NC}" ;;
    pending|waiting_for_resource|created) echo -e "${YELLOW}◌${NC}" ;;
    canceled|canceling) echo -e "${GRAY}⊘${NC}" ;;
    *)        echo -e "${GRAY}?${NC}" ;;
  esac
}

# Get active bookmarks from v3 repo
bookmarks=$(cd "$V3_DIR" && jj bookmark list 2>/dev/null | grep -v '(deleted)' | grep -v '@origin' | grep -v '^  ' | grep -v '^Hint:' | awk -F: '{print $1}' | xargs)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Fetch user ID + reviewer MRs in parallel with bookmark data
(
  glab api "user" 2>/dev/null > "$tmpdir/user.json" || echo "{}" > "$tmpdir/user.json"
) &

if [[ -n "$bookmarks" ]]; then
  for branch in $bookmarks; do
    (
      glab api "projects/$PROJECT/merge_requests?source_branch=$branch&state=opened&per_page=1" 2>/dev/null > "$tmpdir/${branch}_mr.json" || echo "[]" > "$tmpdir/${branch}_mr.json"
    ) &
    (
      glab api "projects/$PROJECT/pipelines?ref=$branch&per_page=1" 2>/dev/null > "$tmpdir/${branch}_ci.json" || echo "[]" > "$tmpdir/${branch}_ci.json"
    ) &
  done
fi
wait

# Get user ID, then fetch reviewer MRs + bookmark approvals in parallel
user_id=$(python3 -c "import json;print(json.load(open('$tmpdir/user.json')).get('id',''))" 2>/dev/null || true)

if [[ -n "$user_id" ]]; then
  (
    glab api "projects/$PROJECT/merge_requests?reviewer_id=$user_id&state=opened&per_page=20" 2>/dev/null > "$tmpdir/reviews.json" || echo "[]" > "$tmpdir/reviews.json"
  ) &
fi

if [[ -n "$bookmarks" ]]; then
  for branch in $bookmarks; do
    iid=$(python3 -c "
import json
data = json.load(open('$tmpdir/${branch}_mr.json'))
print(data[0]['iid'] if data else '')
" 2>/dev/null || true)
    if [[ -n "$iid" ]]; then
      (
        glab api "projects/$PROJECT/merge_requests/$iid/approvals" 2>/dev/null > "$tmpdir/${branch}_approvals.json" || echo "{}" > "$tmpdir/${branch}_approvals.json"
      ) &
    fi
  done
fi
wait

# Batch 3: fetch approvals for reviewer MRs (needs reviews.json from batch 2)
if [[ -f "$tmpdir/reviews.json" && -n "$user_id" ]]; then
  review_iids=$(python3 -c "
import json
data = json.load(open('$tmpdir/reviews.json'))
for mr in data:
    if not mr.get('draft'):
        print(mr['iid'])
" 2>/dev/null || true)

  for iid in $review_iids; do
    (
      glab api "projects/$PROJECT/merge_requests/$iid/approvals" 2>/dev/null > "$tmpdir/review_${iid}_approvals.json" || echo "{}" > "$tmpdir/review_${iid}_approvals.json"
    ) &
  done
  wait
fi

# === Render: My bookmarks ===
actions=()

if [[ -n "$bookmarks" ]]; then
  for branch in $bookmarks; do
    ci_status=$(python3 -c "
import json
data = json.load(open('$tmpdir/${branch}_ci.json'))
print(data[0]['status'] if data else 'none')
" 2>/dev/null || echo "error")

    mr_data=$(python3 -c "
import json
data = json.load(open('$tmpdir/${branch}_mr.json'))
if data:
    mr = data[0]
    print(f\"{mr['iid']}|{mr['title']}|{mr.get('draft', False)}|{mr.get('has_conflicts', False)}|{mr.get('user_notes_count', 0)}|{mr['web_url']}\")
else:
    print('none')
" 2>/dev/null || echo "error")

    if [[ "$mr_data" == "none" ]]; then
      if [[ "$ci_status" != "none" ]]; then
        actions+=("$(echo -e "  $(ci_icon "$ci_status") ${BOLD}$branch${NC} ${GRAY}(no MR)${NC}")")
      fi
      continue
    fi

    IFS='|' read -r iid title draft has_conflicts notes_count url <<< "$mr_data"

    approved="false"
    if [[ -f "$tmpdir/${branch}_approvals.json" ]]; then
      approved=$(python3 -c "
import json
data = json.load(open('$tmpdir/${branch}_approvals.json'))
print('true' if data.get('approved') else 'false')
" 2>/dev/null || echo "false")
    fi

    flags=""
    flags+="$(ci_icon "$ci_status") "

    if [[ "$draft" == "True" ]]; then
      flags+="${GRAY}[draft]${NC} "
    fi

    if [[ "$approved" == "true" ]]; then
      flags+="${GREEN}approved${NC} "
    else
      flags+="${YELLOW}pending review${NC} "
    fi

    if [[ "$notes_count" -gt 0 ]]; then
      flags+="${BLUE}💬 ${notes_count}${NC} "
    fi

    if [[ "$has_conflicts" == "True" ]]; then
      flags+="${RED}⚠ conflicts${NC} "
    fi

    if [[ "$approved" == "true" && "$ci_status" == "success" && "$has_conflicts" != "True" && "$draft" != "True" ]]; then
      flags+="${GREEN}→ ready to merge${NC} "
    fi

    actions+=("$(echo -e "  ${BOLD}$branch${NC} ${flags}${GRAY}${url}${NC}")")
  done
fi

# === Fetch approvals for reviewer MRs ===
if [[ -f "$tmpdir/reviews.json" ]]; then
  review_iids=$(python3 -c "
import json
data = json.load(open('$tmpdir/reviews.json'))
for mr in data:
    if not mr.get('draft'):
        print(mr['iid'])
" 2>/dev/null || true)

  for iid in $review_iids; do
    (
      glab api "projects/$PROJECT/merge_requests/$iid/approvals" 2>/dev/null > "$tmpdir/review_${iid}_approvals.json" || echo "{}" > "$tmpdir/review_${iid}_approvals.json"
    ) &
  done
  wait
fi

# === Render: Awaiting my review (hide already approved by me) ===
reviews=()

if [[ -f "$tmpdir/reviews.json" && -n "$user_id" ]]; then
  reviews_data=$(python3 -c "
import json, sys, os

user_id = $user_id
tmpdir = '$tmpdir'
data = json.load(open(os.path.join(tmpdir, 'reviews.json')))
for mr in data:
    if mr.get('draft'):
        continue
    iid = mr['iid']
    # Check if I already approved
    approvals_file = os.path.join(tmpdir, f'review_{iid}_approvals.json')
    i_approved = False
    if os.path.exists(approvals_file):
        with open(approvals_file) as f:
            approvals = json.load(f)
        i_approved = any(a['user']['id'] == user_id for a in approvals.get('approved_by', []))
    if i_approved:
        continue
    print(f\"{iid}|{mr['author']['name']}|{mr.get('user_notes_count',0)}|{mr.get('has_conflicts',False)}|{mr['title']}|{mr['web_url']}\")
" 2>/dev/null || true)

  while IFS='|' read -r iid author notes conflicts title url; do
    [[ -z "$iid" ]] && continue
    flags="${YELLOW}awaiting your review${NC} "
    if [[ "$notes" -gt 0 ]]; then
      flags+="${BLUE}💬 ${notes}${NC} "
    fi
    if [[ "$conflicts" == "True" ]]; then
      flags+="${RED}⚠ conflicts${NC} "
    fi
    reviews+=("$(echo -e "  ${BOLD}!${iid}${NC} ${flags}${GRAY}${author} · ${title}${NC}")")
  done <<< "$reviews_data"
fi

# === Output ===
has_output=false

if [[ ${#actions[@]} -gt 0 ]]; then
  has_output=true
  echo -e "${BOLD}📋 v3 — my branches${NC}"
  for line in "${actions[@]}"; do
    echo -e "$line"
  done
fi

if [[ ${#reviews[@]} -gt 0 ]]; then
  if [[ "$has_output" == true ]]; then echo ""; fi
  has_output=true
  echo -e "${BOLD}👀 v3 — awaiting my review (${#reviews[@]})${NC}"
  for line in "${reviews[@]}"; do
    echo -e "$line"
  done
fi

if [[ "$has_output" == true ]]; then
  echo ""
fi
