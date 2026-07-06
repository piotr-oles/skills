# Replace Boolean Flags with State Union

Several boolean fields often encode a state machine badly. Replace the flag matrix with a union of named states so invalid flag combinations cannot be represented.

## Use When

- Multiple booleans describe mutually exclusive states.
- The number of possible flag combinations is larger than the number of valid states.
- Conditionals repeatedly combine flags to discover the real state.
- New behavior requires reasoning about every flag combination.

## Trigger

- Fields like `isLoading`, `isLoaded`, `hasError`, `isSaving`, `isDirty` on the same object.
- Guards such as `if (!isLoading && hasData && !hasError)`.
- Bug fixes that add another defensive flag combination check.
- Tests named after impossible or contradictory states.

## Mechanics

1. List the valid states in domain language.
2. Create a union variant for each state, including only data valid in that state.
3. Replace flag-setting code with functions that construct state variants.
4. Update consumers to switch or match on the state tag.
5. Delete flag combinations and defensive impossible-state checks.

## Example

Before:

```ts
type SaveState = {
  isSaving: boolean;
  isSaved: boolean;
  hasError: boolean;
  error?: string;
};
```

After:

```ts
type SaveState =
  | { state: "idle" }
  | { state: "saving" }
  | { state: "saved" }
  | { state: "failed"; error: string };
```

## Related

- [Replace Optional Fields with Variant Union](replace-optional-fields-with-variant-union.md)
- [Split Phase](split-phase.md)
- [Decompose Conditional](decompose-conditional.md)
