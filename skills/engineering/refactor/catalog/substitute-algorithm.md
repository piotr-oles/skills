# Substitute Algorithm

When a clearer or more direct algorithm exists, replace the whole body of a function with it rather than tweaking the tangled version in place.

## Use When

- A convoluted implementation can be expressed more simply and directly.
- A hand-rolled loop duplicates what a standard library call does.
- You have found a clearer way to achieve the same observable behavior.
- The existing algorithm is hard to extend and a replacement would be easier.

## Trigger

- You understand the intended result better than the current code expresses it.
- A loop reimplements `find`, `filter`, `map`, or a well-known algorithm.
- Bug fixes keep patching around an awkward core computation.
- Tests fully characterize the behavior, making wholesale replacement safe.

## Mechanics

1. Ensure tests fully characterize the current observable behavior before changing anything.
2. Decompose a large algorithm into smaller pieces first; whole-function replacement is hard while code remains tangled.
3. Write the replacement so it produces identical outputs for the same inputs.
4. Swap the body in one step and run tests.
5. Remove now-dead helpers left over from the old algorithm.

## Example

Replace search loop with direct algorithm.

Before:

```ts
function foundPerson(people) {
  for (const p of people) {
    if (p === "Don") return "Don";
    if (p === "John") return "John";
    if (p === "Kent") return "Kent";
  }
  return "";
}
```

After:

```ts
function foundPerson(people) {
  const candidates = ["Don", "John", "Kent"];
  return people.find(p => candidates.includes(p)) || "";
}
```

## Related

- [Extract Function](extract-function.md)
- [Replace Loop with Pipeline](replace-loop-with-pipeline.md)
