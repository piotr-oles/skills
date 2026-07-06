# Extract Function

A fragment of code with a clear single purpose should become a named function, so the intent is stated once and the call site reads as what it does, not how.

## Use When

- A block of code needs a comment to explain what it does.
- The same fragment appears in more than one place.
- A long function mixes several levels of detail.
- A sub-computation deserves a name that reveals intent.

## Trigger

- You catch yourself mentally labeling a block ("this part validates", "this part formats").
- Duplicated statements differ only in the data they touch.
- A function is long enough that you scroll to understand it.
- Nested logic obscures the high-level flow.

## Mechanics

1. Name the new function for what it does, not how it does it; if no better name than the code exists, do not extract.
2. Copy the fragment into the new function and pass any local variables it reads as parameters.
3. Return any variable the original code assigns and still uses afterward.
4. Replace the original fragment with a call to the new function.
5. Run tests, then look for other call sites that can reuse the new function.

## Example

Extract banner printing into named function.

Before:

```ts
console.log("***********************");
console.log("**** Customer Owes ****");
console.log("***********************");
```

After:

```ts
printBanner();

function printBanner() {
  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");
}
```

## Related

- [Inline Function](inline-function.md)
- [Move Function](move-function.md)
