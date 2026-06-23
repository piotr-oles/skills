---
name: address-pr
description: Fetch and address PR feedback. Use when user asks to address PR comments, review feedback, or respond to PR suggestions.
---

# Address PR Feedback

## Step 1: Find the PR

```bash
gh pr list --head $(git rev-parse --abbrev-ref HEAD)
```

If no result, find by commit SHA:

```bash
commit_sha=$(git rev-parse HEAD)
repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
gh api "repos/${repo}/commits/${commit_sha}/pulls" --jq '.[0].number'
```

## Step 2: Fetch all feedback

Fetch inline comments, reviews, and issue-level comments in one pass:

```bash
PR=<number>
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

gh api repos/${REPO}/pulls/${PR}/comments \
  | python3 -c "
import sys, json
cs = json.load(sys.stdin)
print(f'{len(cs)} inline comment(s)')
for c in cs:
    print(f'--- {c[\"user\"][\"login\"]} on {c[\"path\"]}:{c.get(\"line\",\"?\")}')
    print(c['body'])
    print()
"

gh api repos/${REPO}/pulls/${PR}/reviews \
  | python3 -c "
import sys, json
rs = json.load(sys.stdin)
print(f'{len(rs)} review(s)')
for r in rs:
    print(f'--- {r[\"user\"][\"login\"]} [{r[\"state\"]}]')
    if r.get('body'): print(r['body'])
    print()
"

gh api repos/${REPO}/issues/${PR}/comments \
  | python3 -c "
import sys, json
cs = json.load(sys.stdin)
print(f'{len(cs)} issue comment(s)')
for c in cs:
    print(f'--- {c[\"user\"][\"login\"]}')
    print(c['body'])
    print()
"
```

## Step 3: Address each piece of feedback

Work through comments one by one. For each:

- Read the comment and the referenced file/line.
- Make the change.
- If the comment is unclear, ask the user before proceeding.

## Step 4: Commit

If only the last commit needs updating:

```bash
git add -A && git commit --amend --no-edit
```

If changes span multiple logical areas, make separate commits with conventional commit messages.

## Step 5: Push

Branch history may have been rebased — force push with lease:

```bash
git push --force-with-lease
```

## Notes

- If `git` commands fail with "not a git repository / must be run in a work tree", the shell is inside a worktree whose `GIT_DIR` env is unset. Use explicit flags: `git --work-tree=. --git-dir=.git <cmd>`.
- If the PR description also contains stale information addressed by the feedback, update it: `gh pr edit <number> --body "..."`.
