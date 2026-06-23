---
name: address-pr
description: Fetch and address PR feedback. Use when user asks to address PR comments, review feedback, or respond to PR suggestions.
disable-model-invocation: true
---

# Address PR Feedback

Scripts live next to this `SKILL.md`. Derive `SKILL_DIR` from the path of this file, then run from repo root.

## Step 1: Find the PR

```bash
SKILL_DIR=$(dirname /path/to/this/SKILL.md)   # substitute actual path
PR=$(bash "$SKILL_DIR/find-pr.sh")
```

## Step 2: Fetch all feedback

```bash
bash "$SKILL_DIR/fetch-pr-feedback.sh" "$PR"
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

- Scripts sit next to this `SKILL.md`. Set `SKILL_DIR` to this file's parent directory before calling them.
- If `git` commands fail with "not a git repository / must be run in a work tree", the shell is inside a worktree whose `GIT_DIR` env is unset. Use explicit flags: `git --work-tree=. --git-dir=.git <cmd>`.
- If the PR description also contains stale information addressed by the feedback, update it: `gh pr edit <number> --body "..."`.
