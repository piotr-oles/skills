# Rename

A name that does not reveal intent, or that spells one concept differently across the code, forces every reader to re-derive meaning. Rename it to the domain term and align siblings to the same word.

## Use When

- A variable, field, function, type, or module name does not say what it is or does.
- The same concept is named differently in different places (`user` / `account` / `customer`).
- An abbreviation or legacy name misleads about current behavior.
- You just understood what something really means and the name lags behind.

## Trigger

- You need a comment to explain what a name stands for.
- Two names refer to one concept, or one name refers to two.
- A name lies about what the code does after behavior moved.
- Reading a call site tells you less than the domain term would.

## Mechanics

1. Pick the name from the domain vocabulary, not from how the code happens to work; when that vocabulary is unclear or inconsistent, pin down the ubiquitous language first with the /domain-modeling skill.
2. Rename the symbol and every reference together, using editor/tooling rename where possible.
3. Align sibling names to the same term so the concept reads consistently across the code.
4. For a published API, keep the old name as a deprecated alias until callers migrate, then remove it.

## Example

Rename an unclear function.

Before:

```ts
function circum(radius: number) {
  return 2 * Math.PI * radius;
}
```

After:

```ts
function circumference(radius: number) {
  return 2 * Math.PI * radius;
}
```

## Related

- [Extract Function](extract-function.md)
- [Decompose Conditional](decompose-conditional.md)
- /domain-modeling skill — establish the ubiquitous language that names should draw from.
