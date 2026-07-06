# Combine Functions into Class

When a group of functions all operate on the same data and pass it around, bind them into a class so the data and the operations that belong to it live together.

## Use When

- Several functions share a common data argument and are always called together.
- Callers must remember the correct order to invoke a set of related functions.
- Derived values are recomputed at each call site instead of once from shared state.
- The data has invariants that should be enforced in one place.

## Trigger

- The same object is threaded as the first argument through many functions.
- Call sites repeat a sequence: acquire data, then compute several values from it.
- Related helpers sit in a module with no clear owner for the data they process.
- Callers must know whether a value is stored or derived.

## Mechanics

1. Make the common data argument a field by moving one function into a class that holds it.
2. Move the remaining related functions in as methods with [Move Function](move-function.md), replacing the passed argument with `this`.
3. Expose derived values as getters so callers need not know whether a value is stored or computed (Uniform Access Principle).
4. Prefer a class over a transform when the core data can mutate and methods must recalculate from current state.
5. A plain module exporting functions over a `readonly` data type is idiomatic and testable in TypeScript; reserve a class for private mutable state or encapsulated invariants.

## Example

Move reading calculations into class.

Before:

```ts
const reading = acquireReading();
const baseCharge = baseRate(reading.month, reading.year) * reading.quantity;
const taxableCharge = Math.max(0, baseCharge - taxThreshold(reading.year));
```

After:

```ts
const rawReading = acquireReading();
const aReading = new Reading(rawReading);
const baseCharge = aReading.baseCharge;
const taxableCharge = aReading.taxableCharge;
```

## Related

- [Extract Class](extract-class.md)
- [Move Function](move-function.md)
- [Replace Derived Variable with Query](replace-derived-variable-with-query.md)
