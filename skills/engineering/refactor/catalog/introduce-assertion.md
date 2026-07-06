# Introduce Assertion

An assumption a section of code relies on should be stated in code, not left implicit; add an assertion so the invariant is documented and violations fail fast.

## Use When

- A block of code only works when some condition holds, but that condition is unstated.
- A value must satisfy an invariant that is currently assumed silently.
- Readers cannot tell what must be true for the code to be correct.
- A bug would otherwise surface far from its cause.

## Trigger

- A comment says "should always be positive" or "must be set by now".
- Code implicitly relies on a field being non-null or within a range.
- Debugging reveals an invariant that was never enforced.
- A value enters an object and later code depends on its validity.

## Mechanics

1. Identify the invariant the code assumes and the point where the value enters or is established.
2. Add an assertion that fails fast when the invariant is violated, placed where the value is set.
3. Keep assertions side-effect free; they must not change program behavior when they pass.
4. Assert conditions that should always be true, not expected runtime error cases — those need real handling.
5. Run tests to confirm the assertion holds for valid inputs.

## Example

Assert discount rate invariant where value enters object.

Before:

```ts
applyDiscount(aNumber) {
  return (this.discountRate) ? aNumber - (this.discountRate * aNumber) : aNumber;
}
```

After:

```ts
class Customer {
  #discountRate: number | null = null;

  set discountRate(aNumber: number | null) {
    assert(null === aNumber || aNumber >= 0);
    this.#discountRate = aNumber;
  }
}
```

## Related

- [Move Field](move-field.md)
