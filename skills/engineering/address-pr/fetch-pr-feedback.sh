#!/usr/bin/env bash
# Usage: fetch-pr-feedback.sh <PR_NUMBER>
# Prints inline comments, reviews, and issue-level comments for a PR.
set -euo pipefail

PR=$1
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

gh api "repos/${REPO}/pulls/${PR}/comments" \
  | python3 -c "
import sys, json
cs = json.load(sys.stdin)
print(f'{len(cs)} inline comment(s)')
for c in cs:
    print(f'--- {c[\"user\"][\"login\"]} on {c[\"path\"]}:{c.get(\"line\",\"?\")}')
    print(c['body'])
    print()
"

gh api "repos/${REPO}/pulls/${PR}/reviews" \
  | python3 -c "
import sys, json
rs = json.load(sys.stdin)
print(f'{len(rs)} review(s)')
for r in rs:
    print(f'--- {r[\"user\"][\"login\"]} [{r[\"state\"]}]')
    if r.get('body'): print(r['body'])
    print()
"

gh api "repos/${REPO}/issues/${PR}/comments" \
  | python3 -c "
import sys, json
cs = json.load(sys.stdin)
print(f'{len(cs)} issue comment(s)')
for c in cs:
    print(f'--- {c[\"user\"][\"login\"]}')
    print(c['body'])
    print()
"
