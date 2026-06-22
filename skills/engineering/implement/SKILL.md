---
name: implement
description: Implement a plan end-to-end.
disable-model-invocation: true
---

## Implement Workflow

### 1. Get plan

User gave path or text? Read it.
Otherwise ask: "Paste plan or give file path".

### 2. Prepare environment

Run `git status` — worktree must be clean, if not, ask user for next step.

If not on feature branch, create one from latest default branch:
```sh
# detect default branch
DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')

git fetch origin
git checkout -b $USER/<task-name> origin/$DEFAULT --no-track
```
Branch format: `$USER/<task-name>`, e.g. `piotr.oles/my-feature`

### 3. Implement 

Implement the work described by the user in the PRD or issues.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /review to review the work.

Commit your work to the current branch, use atomic commits.
