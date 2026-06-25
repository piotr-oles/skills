---
name: review
description: Deep code review workflow. Spawn logic, system design, and refactor subagents in parallel, address feedback, send follow-ups with changes made.
---

## Review Workflow

### 1. Spawn all three subagents in parallel

Spawn following subagents in parallel:
- **logic-reviewer**: check correctness, bugs, test gaps, performance
- **system-design-reviewer**: check architecture, API design, maintainability
- **refactor-reviewer**: check code smells, refactoring opportunities, design pattern gaps

Ask each to review the target (file path, feature, design, PR diff, etc). Include context about what you want focused on.

### 2. Wait for all three to complete

All subagents will return findings. Collect all feedback.

### 3. Review with user

Go through each finding with user - use ask user tool, include related code snipptes if needed. User should approve or reject the suggestion. You migh also provide alternative solutions for user to pick.

### 4. Address findings

Make fixes based on feedback. Group logically related changes in one session. Be aggressive with refactoring if reviewers flag design issues.

### 5. Follow-up with all three subagents

Followup review subagents with applied changes in parallel.

### 6. Loop if needed

If follow-up feedback reveals more issues, repeat steps 3-4 until reviewers are satisfied.

## Tips

- Be specific in initial prompt. Tell reviewers what to focus on.
- Group changes before follow-up. Don't send multiple follow-ups for small fixes.
- Quote exact line numbers when referencing code in prompts.
