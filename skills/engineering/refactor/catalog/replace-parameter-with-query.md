# Replace Parameter with Query

When a parameter's value can be derived from the receiver or from other parameters, drop it and let the function compute it, so callers cannot pass an inconsistent value.

## Use When

- A parameter is always computed from another parameter or from the receiver's state.
- Callers duplicate the same derivation before every call.
- The parameter offers no genuine choice — only one correct value exists.
- Removing it would simplify the signature without hiding a real dependency.

## Trigger

- Every caller computes the argument the same way from data the function can already reach.
- A parameter and another parameter always move together by a fixed rule.
- Bugs arise when a caller passes a value inconsistent with the receiver's state.
- The parameter exists only because an earlier refactoring left it behind.

## Mechanics

1. Confirm the function can obtain the value itself, without a new dependency and without losing needed flexibility.
2. Compute the value inside the function, often via a getter, using [Extract Function](extract-function.md) if the derivation is non-trivial.
3. Remove the parameter with Change Function Declaration.
4. Update callers to drop the now-redundant argument.
5. Keep the parameter if it reaches into singleton or process-wide state the function should not own — then prefer injecting it instead.

## Example

Let receiver query discount level itself.

Before:

```ts
const discountLevel = this.quantity > 100 ? 2 : 1;
return this.discountedPrice(basePrice, discountLevel);
```

After:

```ts
return this.discountedPrice(basePrice);

get discountLevel() {return this.quantity > 100 ? 2 : 1;}
```

## Related

- [Replace Query with Parameter](replace-query-with-parameter.md)
- [Replace Derived Variable with Query](replace-derived-variable-with-query.md)
