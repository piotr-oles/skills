# Remove Flag Argument

A boolean argument that switches a function between two behaviors hides intent at the call site; replace it with explicit functions that name each behavior.

## Use When

- A literal `true`/`false` argument selects which behavior a function performs.
- Call sites are hard to read without checking what the flag means.
- A function's body is really two functions joined by an `if` on the flag.
- Callers pass a literal, not data, to choose behavior.

## Trigger

- Calls like `deliveryDate(order, true)` where the boolean's meaning is opaque.
- A function that branches at the top on a boolean parameter.
- Multiple boolean parameters producing a combinatorial set of behaviors.
- You must read the signature to learn what `true` does.

## Mechanics

1. Identify each behavior the flag selects and name an explicit function for it.
2. Give each explicit function a body that calls the original with the fixed flag value, or inline the relevant branch.
3. Update literal callers to the explicit functions; it is not a flag when the value flows as data, such as `isRush = determineIfRush(order)` then `deliveryDate(order, isRush)`.
4. For mixed callers, change literal callers and keep the original function for data callers.
5. Multiple boolean state fields often want [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md), not many explicit functions; multiple flags creating many combinations often signal a function doing too much.

## Example

Replace boolean delivery flag with explicit functions.

Before:

```ts
aShipment.deliveryDate = deliveryDate(anOrder, true);
```

After:

```ts
aShipment.deliveryDate = rushDeliveryDate(anOrder);

function rushDeliveryDate(anOrder) {return deliveryDate(anOrder, true);}
function regularDeliveryDate(anOrder) {return deliveryDate(anOrder, false);}
```

## Related

- [Replace Conditional with Strategy](replace-conditional-with-strategy.md)
- [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md)
