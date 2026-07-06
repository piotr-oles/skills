# Add Exhaustive Match

Union types only pay off when consumers handle every variant deliberately. Replace loose conditionals or default fallthrough with exhaustive matching so new variants produce compile-time or test-time failures.

## Use When

- A union or enum exists but consumers rely on `default`, `else`, casts, or partial checks.
- New variants can be added without compiler or test failures.
- Logic for a variant is scattered across several fragile branches.
- You want TypeScript `never` checks or Rust `match` exhaustiveness to protect future changes.

## Trigger

- `switch` statements with `default` that hides missing cases.
- `if (x.kind === "a") ... else ...` where more than two variants exist.
- Type assertions after narrowing.
- Tests missing one or more union cases.

## Mechanics

1. Replace partial conditionals with a `switch` or `match` over the discriminant.
2. Handle each known variant explicitly.
3. In TypeScript, add a `never` assertion in the impossible branch.
4. In Rust, avoid wildcard `_` when each variant should be handled intentionally.
5. Add tests for the behavior of each variant when the logic is important.

## Example

Before:

```ts
function label(state: RequestState) {
  if (state.status === "success") return state.data.name;
  return "Not ready";
}
```

After:

```ts
function label(state: RequestState) {
  switch (state.status) {
    case "idle": return "Idle";
    case "loading": return "Loading";
    case "success": return state.data.name;
    case "error": return state.error.message;
  }
}
```

## Related

- [Replace Optional Fields with Variant Union](replace-optional-fields-with-variant-union.md)
- [Replace Enum Plus Payload Fields with Variant Union](replace-enum-plus-payload-fields-with-variant-union.md)
- [Decompose Conditional](decompose-conditional.md)
