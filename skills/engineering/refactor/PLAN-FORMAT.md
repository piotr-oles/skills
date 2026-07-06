# Refactoring Plan Format

## Candidate

- The smell and its location (file/module, symbol).
- Why it blocks change or hides intent — the concrete cost today.

## Chosen approach

- One line on why this branch over the alternatives.
- The refactoring(s) or pattern from the catalog, inlined from `catalog/<name>.md`.

## Branches considered

- Each alternative explored, with pros/cons and why it was rejected.

## Before → After

- High-level structure now vs. after: types, modules, responsibilities, boundaries.
- No line-level code; show the shape, not the diff.

## Steps

- Use /tdd skill for refactoring
- Ordered, behavior-preserving moves, each referencing the catalog entry's Mechanics.
- Every step independently safe; tests stay green between steps.

## Safety

- Characterization tests to add or confirm before changing structure.
- How behavior preservation is verified after each step.

## Out of scope

- What this plan deliberately does not touch (the YAGNI guard) — structure not added, abstractions not introduced.
