---
name: address-pr
description: Fetch PR inline comments, reviews, and issue comments; address each; commit and push.
disable-model-invocation: true
---

# Address PR Feedback

Scripts live next to this `SKILL.md`. Set `SKILL_DIR` to this file's parent directory before calling them; run scripts from repo root.

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

Every comment must be accounted for — none skipped. For each:

- Read the comment and the referenced file/line.
- Make the change, or explicitly decline with a reason.
- If the comment is unclear or requested change is big/unsafe, ask the user before proceeding.

Done when every fetched comment is either changed or declined with reason.

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

- If the PR description also contains stale information addressed by the feedback, update it: `gh pr edit <number> --body "..."`.
