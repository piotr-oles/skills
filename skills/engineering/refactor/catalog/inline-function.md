# Inline Function

When a function's body is as clear as its name and adds no explanatory value, fold it back into its callers to remove needless indirection.

## Use When

- The body says exactly what the name says and nothing more.
- A layer of poorly-factored functions obscures the flow; you want to inline then re-extract cleanly.
- A helper is called from only one place and adds no clarity.
- Excessive delegation makes the call chain hard to follow.

## Trigger

- Reading the function tells you nothing the name did not.
- A one-line wrapper forwards to another function with no added meaning.
- You are consolidating a tangle of tiny functions before re-extracting better ones.

## Mechanics

1. Confirm the function is not polymorphic (not overridden by subclasses).
2. Replace each call with the function body, adjusting variable names as needed.
3. For awkward bodies, use Move Statements to Callers first so each call site inlines cleanly.
4. Remove the function once every caller is updated.
5. Recursion, multiple returns, inaccessible object state, or heavy fitting usually mean choose a different refactoring.

## Example

Inline helper whose body says same thing as name.

Before:

```ts
function rating(aDriver) {
  return moreThanFiveLateDeliveries(aDriver) ? 2 : 1;
}
function moreThanFiveLateDeliveries(aDriver) {
  return aDriver.numberOfLateDeliveries > 5;
}
```

After:

```ts
function rating(aDriver) {
  return aDriver.numberOfLateDeliveries > 5 ? 2 : 1;
}
```

## Related

- [Extract Function](extract-function.md)
