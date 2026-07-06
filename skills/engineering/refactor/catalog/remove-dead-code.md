# Remove Dead Code

Code that is never reached or never used is not free — it costs reading time and hides intent behind branches the program can never take. Delete it; version control remembers it.

## Use When

- A function, field, parameter, or branch has no live callers or readers.
- A feature flag is permanently off, or a config path is no longer configured.
- Commented-out blocks linger "just in case".
- A parameter is passed everywhere but read nowhere.

## Trigger

- Coverage, dead-code lint, or an unused-symbol check flags the code.
- A grep for the symbol finds only its definition.
- A conditional guards a state the type system or upstream code makes impossible.

## Mechanics

1. Confirm the code is truly unreachable — check dynamic callers, reflection, serialization, and public API surface.
2. Delete the code and any imports, parameters, or fields it was the only user of.
3. For a dead parameter, remove it with Change Function Declaration and update callers.
4. Run tests and the build to confirm nothing depended on it.

## Example

Drop an unread parameter and its dead branch.

Before:

```ts
function priceFor(order: Order, legacyMode = false) {
  if (legacyMode) return order.legacyTotal; // never passed true anymore
  return order.total;
}
```

After:

```ts
function priceFor(order: Order) {
  return order.total;
}
```

## Related

- [Inline Function](inline-function.md)
- [Remove Flag Argument](remove-flag-argument.md)
