# Replace Nested Conditional with Guard Clauses

Deeply nested conditionals hide the main path; handle special cases up front with guard clauses that return early, leaving the normal flow at the top level.

## Use When

- Special cases are nested inside `if`/`else` around the main logic.
- A single result variable is assigned in many branches then returned at the end.
- The core computation is buried several levels deep.
- The code gives equal weight to exceptional and normal paths.

## Trigger

- Arrow-shaped code that indents further with each precondition.
- One `result` variable threaded through nested branches.
- Preconditions checked in `else` branches rather than returned early.
- You must scroll past edge cases to find the primary behavior.

## Mechanics

1. Identify the special or exceptional cases the conditional handles.
2. Turn each into a guard clause that returns (or throws) immediately when the case applies.
3. Remove the surrounding `else` so the main logic sits unindented at the end.
4. Repeat until every exceptional case is a leading guard.
5. Run tests to confirm each early exit returns the same value as before.

## Example

Replace nested special cases with guard clauses.

Before:

```ts
function payAmount(employee) {
  let result;
  if (employee.isSeparated) result = {amount: 0, reasonCode: "SEP"};
  else if (employee.isRetired) result = {amount: 0, reasonCode: "RET"};
  else result = someFinalComputation();
  return result;
}
```

After:

```ts
function payAmount(employee) {
  if (employee.isSeparated) return {amount: 0, reasonCode: "SEP"};
  if (employee.isRetired) return {amount: 0, reasonCode: "RET"};
  return someFinalComputation();
}
```

## Related

- [Decompose Conditional](decompose-conditional.md)
- [Introduce Special Case](introduce-special-case.md)
