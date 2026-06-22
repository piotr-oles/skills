# Skills

Agent skills for human in the loop engineering — not vibe coding.

## Engineering

Skills for daily code work.

### User-invoked

Reachable only when you type them (`disable-model-invocation: true`).

- **[grill](./skills/engineering/grill/SKILL.md)** — Relentlessly interviewed about a plan or design until every branch of the decision tree is resolved.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Grilling session that also builds the project's domain model, sharpening terminology and updating `CONTEXT.md` and ADRs inline.
- **[implement](./skills/engineering/implement/SKILL.md)** — Execute a plan end-to-end: git setup, TDD, typecheck, review loop.
- **[review](./skills/engineering/review/SKILL.md)** — Spawn logic, system design, and refactor reviewers in parallel, address feedback, send follow-ups.

### Model-invoked

Model- or user-reachable.

- **[agent-browser](./skills/engineering/agent-browser/SKILL.md)** — Browser automation via CDP: accessibility-tree snapshots, auth state, multi-tab, React introspection.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with red-green-refactor loop, one vertical slice at a time.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — Actively build and sharpen a project's domain model — challenge terms, stress-test with scenarios, update `CONTEXT.md` and ADRs inline.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Shared vocabulary for designing deep modules: small interfaces, clean seams, testable through the interface.

## Subagents

- **[developer](./subagents/developer.md)** — Staff engineer. Implements complex features. Quality over speed, maintainability over diff size.
- **[explorer](./subagents/explorer.md)** — Reconnaissance agent. Explores codebase and gathers context without making changes.
- **[logic-reviewer](./subagents/logic-reviewer.md)** — Catches bugs, incorrect behavior, and missing test coverage.
- **[system-design-reviewer](./subagents/system-design-reviewer.md)** — Catches structural problems, API design issues, and maintainability risks.
- **[refactor-reviewer](./subagents/refactor-reviewer.md)** — Finds code smells, maps them to Fowler patterns, prioritizes by friction.
- **[project-manager](./subagents/project-manager.md)** — Turns feature requests and bug reports into high-level tickets from a user/product perspective.

## Credits

Inspired by [mattpocock/skills](https://github.com/mattpocock/skills), some skills are literally copy-pasted.
