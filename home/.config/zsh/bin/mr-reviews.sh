#!/usr/bin/env bash
# Show GitLab MRs awaiting my review

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

user_id=$(glab api "user" 2>/dev/null | python3 -c "import json,sys;print(json.load(sys.stdin)['id'])" 2>/dev/null)

if [[ -z "$user_id" ]]; then
  echo "Failed to get GitLab user ID"
  exit 1
fi

mrs=$(glab api "projects/$PROJECT/merge_requests?reviewer_id=$user_id&state=opened&per_page=20" 2>/dev/null || echo "[]")

# Get MR iids for approval fetching
iids=$(echo "$mrs" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for mr in data:
    if 'RFR' in mr.get('labels', []):
        print(mr['iid'])
" 2>/dev/null)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Fetch all approvals in parallel
for iid in $iids; do
  (
    glab api "projects/$PROJECT/merge_requests/$iid/approvals" 2>/dev/null > "$tmpdir/${iid}_approvals.json" || echo "{}" > "$tmpdir/${iid}_approvals.json"
  ) &
done
wait

echo "$mrs" | python3 -c "
import json, sys, os

GREEN = '\033[0;32m'
RED = '\033[0;31m'
YELLOW = '\033[0;33m'
BLUE = '\033[0;34m'
GRAY = '\033[0;90m'
BOLD = '\033[1m'
NC = '\033[0m'

user_id = $user_id
tmpdir = '$tmpdir'
data = json.load(sys.stdin)
if not data:
    print('No MRs awaiting your review.')
    sys.exit(0)

print(f'{BOLD}MRs awaiting your review{NC}')
print()
for mr in data:
    if 'RFR' not in mr.get('labels', []):
        continue
    iid = mr['iid']
    author = mr['author']['name']
    notes = mr.get('user_notes_count', 0)
    conflicts = mr.get('has_conflicts', False)
    url = mr['web_url']
    title = mr['title']

    # Check if I already approved
    i_approved = False
    approvals_file = os.path.join(tmpdir, f'{iid}_approvals.json')
    if os.path.exists(approvals_file):
        with open(approvals_file) as f:
            approvals = json.load(f)
        i_approved = any(a['user']['id'] == user_id for a in approvals.get('approved_by', []))

    if i_approved:
        flags = f'{GREEN}✓ you approved{NC}'
    else:
        flags = f'{YELLOW}awaiting your review{NC}'

    if notes > 0:
        flags += f' {BLUE}💬 {notes}{NC}'
    if conflicts:
        flags += f' {RED}⚠ conflicts{NC}'

    print(f'  {BOLD}!{iid}{NC} {flags} {GRAY}{author}{NC}')
    print(f'    {title}')
    print(f'    {GRAY}{url}{NC}')
    print()
"
