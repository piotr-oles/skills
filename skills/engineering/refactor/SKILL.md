---
name: refactor
description: Find refactoring opportunities, use when asked for refactoring, cleanup, simplification of the codebase.
---

Find refactoring opportunities, but do not to implement them, it's not your objective.

## Process

1. Locate refactoring Candidates using Smell Index. Create a list of up to 5 Candidates.
2. Select top 1 Candidate for refactoring from that list based on severity.
3. For that Candidate, explore a few branches of potential refactoring.
4. Weight pros and cons of each branch, select the most promising one.
5. Ask user for approval for the refactoring Candidate with a high-level plan, potential branches and recommendation.
6. If user approves, build a detailed Refactoring plan following [PLAN-FORMAT.md](PLAN-FORMAT.md). Do not write implementation details.
7. If user rejects, go to step 2, but select next top 1 Candidate.

## Preferences

- YAGNI: refactoring removes structure as readily as it adds it. Do not introduce an abstraction (strategy, builder, port, interface, hierarchy) for variation that is not present yet — a pattern needs a real trigger with existing cases, never a hypothetical future one. When torn, pick the smaller change or none.
- Prefer composition over inheritance for behavior reuse, runtime variation, optional capabilities, and independent change axes; reserve inheritance for stable, honest subtype relationships.
- Prefer unions for closed sets of data shapes
- Prefer strategies, ports, or composition when behavior must stay open-ended or runtime-pluggable.
- Apply Interface Segragation Principle, prefer Deep Modules.

## Smell Index

Each smell links to a catalog entry under `catalog/`. Open the entry for candidates you consider; it defines when to use it, the trigger, mechanics, an example, and related refactorings.

- Long function: [Extract Function](catalog/extract-function.md), [Split Phase](catalog/split-phase.md).
- Duplicate code: [Extract Function](catalog/extract-function.md), [Substitute Algorithm](catalog/substitute-algorithm.md), [Combine Functions into Class](catalog/combine-functions-into-class.md).
- Comments explaining code: [Extract Function](catalog/extract-function.md).
- Mysterious or inconsistent name — identifier does not reveal intent, or the same concept is named differently across the code: [Rename](catalog/rename.md).
- Long parameter list or data clump: [Introduce Parameter Object](catalog/introduce-parameter-object.md), [Extract Class](catalog/extract-class.md), [Use Builder Pattern](catalog/use-builder-pattern.md).
- Primitive obsession — string/number used for a domain concept (money, id, range): [Replace Conditional with Strategy](catalog/replace-conditional-with-strategy.md).
- Too many optional fields: [Replace Optional Fields with Variant Union](catalog/replace-optional-fields-with-variant-union.md), [Replace Enum Plus Payload Fields with Variant Union](catalog/replace-enum-plus-payload-fields-with-variant-union.md).
- Boolean state matrix: [Replace Boolean Flags with State Union](catalog/replace-boolean-flags-with-state-union.md), [Replace Optional Fields with Variant Union](catalog/replace-optional-fields-with-variant-union.md).
- Behavior and legal transitions vary by a mode/status field, illegal transitions guarded ad hoc across the code: [Use State Pattern](catalog/use-state-pattern.md).
- Enum/type code with payload fields: [Replace Enum Plus Payload Fields with Variant Union](catalog/replace-enum-plus-payload-fields-with-variant-union.md), [Add Exhaustive Match](catalog/add-exhaustive-match.md).
- Nullable or sentinel return: [Introduce Special Case](catalog/introduce-special-case.md), or define a domain-specific variant union when absence/failure is part of the state model.
- Feature envy — a function uses another object's fields/methods more than its own: [Move Function](catalog/move-function.md), [Move Field](catalog/move-field.md), [Extract Role Interface](catalog/extract-role-interface.md).
- Divergent change or large class — one class edited for many unrelated reasons: [Extract Class](catalog/extract-class.md), [Combine Functions into Class](catalog/combine-functions-into-class.md), [Extract Composed Capability](catalog/extract-composed-capability.md).
- Shotgun surgery — one change forces scattered edits across many files: [Move Function](catalog/move-function.md), [Move Field](catalog/move-field.md), [Introduce Port Adapter](catalog/introduce-port-adapter.md).
- Switch statements or type codes: [Replace Conditional with Strategy](catalog/replace-conditional-with-strategy.md), [Decompose Conditional](catalog/decompose-conditional.md).
- Non-exhaustive union handling: [Add Exhaustive Match](catalog/add-exhaustive-match.md), [Decompose Conditional](catalog/decompose-conditional.md).
- Flag arguments: [Remove Flag Argument](catalog/remove-flag-argument.md), [Replace Conditional with Strategy](catalog/replace-conditional-with-strategy.md).
- Middle man or message chains — object mostly delegates, or callers hop `a().b().c()`: [Move Function](catalog/move-function.md).
- Global state or singleton access: [Replace Singleton with Injected Dependency](catalog/replace-singleton-with-injected-dependency.md), [Introduce Port Adapter](catalog/introduce-port-adapter.md).
- Broad interface or bulky mock: [Extract Role Interface](catalog/extract-role-interface.md), [Split Interface with Composition](catalog/split-interface-with-composition.md).
- Test coupled to implementation — mocks internal collaborators, asserts private structure or call order, breaks on behavior-preserving changes: [Retarget Test to Behavior](catalog/retarget-test-to-behavior.md).
- Inheritance used for reuse: [Replace Inheritance with Composition](catalog/replace-inheritance-with-composition.md).
- Data-only subclasses: [Replace Subclasses with Union Variants](catalog/replace-subclasses-with-union-variants.md), [Replace Inheritance with Composition](catalog/replace-inheritance-with-composition.md).
- Subclass explosion or optional behavior: [Extract Composed Capability](catalog/extract-composed-capability.md), [Replace Conditional with Strategy](catalog/replace-conditional-with-strategy.md).
- Complex subsystem leaking to callers, repeated orchestration sequence: [Use Facade Pattern](catalog/use-facade-pattern.md).
- Cross-cutting concerns mixed into core logic (logging, caching, retry, auth): [Use Decorator Pattern](catalog/use-decorator-pattern.md).
- Sequential request handling or nested dispatch logic: [Use Chain of Responsibility Pattern](catalog/use-chain-of-responsibility-pattern.md).
- Need to save and restore state for undo, rollback, or back navigation: [Use Memento Pattern](catalog/use-memento-pattern.md).
- Building arrays just to iterate, callback-based sequences, paginated data: [Use Iterator](catalog/use-iterator.md).
- Reassigned variable with multiple meanings: [Split Variable](catalog/split-variable.md).
- Stored value derivable from other state: [Replace Derived Variable with Query](catalog/replace-derived-variable-with-query.md).
- Loop doing several things or hiding intent: [Split Loop](catalog/split-loop.md), [Replace Loop with Pipeline](catalog/replace-loop-with-pipeline.md).
- Values unpacked from an object just to pass along: [Preserve Whole Object](catalog/preserve-whole-object.md), [Replace Parameter with Query](catalog/replace-parameter-with-query.md).
- Query reaching into hidden or global state: [Replace Query with Parameter](catalog/replace-query-with-parameter.md).
- Type-code constructor or scattered `new`: [Replace Constructor with Factory Function](catalog/replace-constructor-with-factory-function.md).
- Nested conditionals around the main path: [Replace Nested Conditional with Guard Clauses](catalog/replace-nested-conditional-with-guard-clauses.md).
- Unstated invariant a block relies on: [Introduce Assertion](catalog/introduce-assertion.md).
- Bare record passed around with drifting shape: [Encapsulate Record](catalog/encapsulate-record.md).
- Speculative generality — unused abstraction, one-implementation interface, params/hooks nobody calls, wrapper adds no meaning: [Inline Function](catalog/inline-function.md), [Inline Class](catalog/inline-class.md), [Collapse Hierarchy](catalog/collapse-hierarchy.md), [Remove Dead Code](catalog/remove-dead-code.md), [Remove Flag Argument](catalog/remove-flag-argument.md), [Replace Inheritance with Composition](catalog/replace-inheritance-with-composition.md).
- Mutable shared object edited in place, aliasing bugs: [Change Reference to Value](catalog/change-reference-to-value.md).
- Duplicate copies of the same logical entity, updates not shared: [Change Value to Reference](catalog/change-value-to-reference.md).

## Opposite Pairs

- [Change Reference to Value](catalog/change-reference-to-value.md) vs [Change Value to Reference](catalog/change-value-to-reference.md): depends on whether identity and shared updates matter more than immutable value simplicity.
- [Replace Conditional with Strategy](catalog/replace-conditional-with-strategy.md) vs [Replace Enum Plus Payload Fields with Variant Union](catalog/replace-enum-plus-payload-fields-with-variant-union.md): depends on whether the variation is open behavior or a closed set of data shapes.
- [Replace Parameter with Query](catalog/replace-parameter-with-query.md) vs [Replace Query with Parameter](catalog/replace-query-with-parameter.md): depends on whether removing a derivable argument or removing a hidden dependency matters more.
