---
name: create-pr
description: Create or update a pull request for current branch with a verified title, description, QA steps, and blast radius.
disable-model-invocation: true
---

# Create or Update Pull Request

Find PR for the current branch with `gh pr view`. If no PR exists, create draft PR.

## 1. Get evidence

Find default branch and comparison base:

```bash
MAIN=$(git remote show origin | sed -n 's/.*HEAD branch: //p')
BASE=$(git merge-base "origin/$MAIN" HEAD)
git log --oneline "$BASE"..HEAD
git diff "$BASE"..HEAD
```

Inspect every commit and full diff. Search codebase before each claim about callers, readers, writers, compatibility, migrations, or affected paths. Omit claim when evidence does not confirm it.

## 2. Get motivation

Ask user what is wrong or missing without PR and why it matters. Offer 1-3 likely answers based on verified facts, and let user write different answer. Do not draft Motivation until user answers.

## 3. Draft title and body

Title: one short command or noun phrase. Add ticket prefix only when repo convention needs one.

**Skimmable:** Keep body near 250 words and explain why, not only what.

**STE:** Write title and body in ASD-STE100 Simplified Technical English.

Use these sections in this order:

```markdown
## Motivation

Write one short paragraph in present tense about what is wrong or missing without PR, its effect, and why it matters. Describe only state without PR. Link earlier PR only when needed to explain that state.

## Changes

Describe new behavior in 1-5 high-level bullets.

- What changed and why.
- What changed and why.

## QA

Give instructions reader can follow to test PR. Include needed setup, actions, and expected result. Use numbered steps for end-to-end flows. Describe how to test change, not how author tested it. Don't include instructions how to run automated tests - they are already included in CI results.

## Blast Radius

Name affected high-level areas (products, services), breaking  changes and data migration status (if applicable).
```

Group small edits under purpose. Skip generated files, minor edits, and renames unless reviewers need them.

Keep each paragraph and list item on one physical line. Use newlines only between headings, paragraphs, and list items.

## 3. Apply PR

Write body to temp file. Check size:

```bash
wc -w "$BODY_FILE"
```

Trim body when over 250 words.

If PR exists, update existing PR:

```bash
gh pr edit "$PR" --repo "$REPO" --title "$TITLE" --body-file "$BODY_FILE"
```

If PR does not exist, create it as draft:

```bash
gh pr create --draft --repo "$REPO" --title "$TITLE" --body-file "$BODY_FILE"
```

Show final PR URL.
