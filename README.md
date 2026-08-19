# Skills

Agent skills for human in the loop engineering — not vibe coding.

## Installation

```bash
./install.sh           # link new entries, warn on existing non-symlinks
./install.sh --force   # replace existing real dirs/files with symlinks
```

Links `skills/engineering/*` and `skills/productivity/*` → `~/.agents/skills/` and `subagents/*.md` → `~/.pi/agent/subagents/`. Entries not in this repo are left untouched and reported as `external`.

## Engineering

Skills for daily code work.

### User-invoked

Reachable only when you type them (`disable-model-invocation: true`).

- **[implement](./skills/engineering/implement/SKILL.md)** — Execute a plan end-to-end: git setup, TDD, typecheck, review loop.
- **[review](./skills/engineering/review/SKILL.md)** — Spawn logic, system design, and refactor reviewers in parallel, address feedback, send follow-ups.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Scan a codebase for deepening opportunities, present a visual HTML report, then grill through the one you pick.
- **[address-pr](./skills/engineering/address-pr/SKILL.md)** — Fetch PR inline comments, reviews, and issue comments; address each one; commit and push.
- **[refactor](./skills/engineering/refactor/SKILL.md)** — Spot refactoring opportunities, map code smells to Fowler patterns, choose safe refactoring before feature work or cleanup.
- **[design-an-interface](./skills/engineering/design-an-interface/SKILL.md)** — Generate multiple radically different interface designs for a module using parallel sub-agents.

### Model-invoked

Model- or user-reachable.

- **[grilling](./skills/engineering/grilling/SKILL.md)** — Relentlessly interview the user about a plan or design until every branch of the design tree is resolved.
- **[agent-browser](./skills/engineering/agent-browser/SKILL.md)** — Browser automation via CDP: accessibility-tree snapshots, auth state, multi-tab, React introspection.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with red-green-refactor loop, one vertical slice at a time.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — Actively build and sharpen a project's domain model — challenge terms, stress-test with scenarios, update `CONTEXT.md` and ADRs inline.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Shared vocabulary for designing deep modules: small interfaces, clean seams, testable through the interface.

## Misc

Skills kept around but rarely used.

### User-invoked

Reachable only when you type them (`disable-model-invocation: true`).

- **[teach](./skills/misc/teach/SKILL.md)** — Teach the user a new skill or concept within the workspace.
- **[wait-what](./skills/misc/wait-what/SKILL.md)** — Explain in simple language.
- **[writing-for-agents](./skills/misc/writing-for-agents/SKILL.md)** — Reference for writing and editing skills well — the vocabulary and principles that make a skill predictable.

## Subagents

- **[developer](./subagents/developer.md)** — Staff engineer. Implements complex features. Quality over speed, maintainability over diff size.
- **[explorer](./subagents/explorer.md)** — Reconnaissance agent. Explores codebase and gathers context without making changes.
- **[logic-reviewer](./subagents/logic-reviewer.md)** — Catches bugs, incorrect behavior, and missing test coverage.
- **[system-design-reviewer](./subagents/system-design-reviewer.md)** — Catches structural problems, API design issues, and maintainability risks.
- **[refactor-reviewer](./subagents/refactor-reviewer.md)** — Finds code smells, maps them to Fowler patterns, prioritizes by friction.
- **[project-manager](./subagents/project-manager.md)** — Turns feature requests and bug reports into high-level tickets from a user/product perspective.

## Credits

Inspired by [mattpocock/skills](https://github.com/mattpocock/skills), some skills are literally copy-pasted.
