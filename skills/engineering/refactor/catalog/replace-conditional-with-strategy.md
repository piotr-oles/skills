# Replace Conditional with Strategy

Conditionals that choose among interchangeable behaviors often want composition before inheritance. Move each behavior behind a strategy interface so callers can select, inject, or test the variation without growing a class hierarchy.

## Use When

- A conditional chooses an algorithm, policy, formatter, validator, or pricing rule.
- The cases are independent behaviors with the same input/output shape.
- Behavior should be selected at runtime or configured externally.
- Subclasses would exist only to represent one decision.

## Trigger

- Repeated `switch` or `if` branches on mode, type, region, plan, channel, or provider.
- New cases require editing a central function.
- Tests need to exercise each branch as a separate behavior.
- A planned inheritance hierarchy would vary by one replaceable policy.
- If cases are a closed set of data shapes, prefer [Replace Enum Plus Payload Fields with Variant Union](replace-enum-plus-payload-fields-with-variant-union.md).

## Mechanics

1. Name the strategy role from the behavior clients need.
2. Extract the conditional body for each case into a function with [Extract Function](extract-function.md).
3. Create a strategy interface and one implementation per case.
4. Change the host to receive or look up the strategy, then delegate through it.
5. Remove the old conditional when all callers select strategies directly.

## Example

Before:

```ts
function shippingCost(order: Order, method: string) {
  if (method === "express") return order.weight * 12;
  if (method === "pickup") return 0;
  return order.weight * 5;
}
```

After:

```ts
interface ShippingStrategy {
  cost(order: Order): number;
}

class ExpressShipping implements ShippingStrategy {
  cost(order: Order) { return order.weight * 12; }
}
```

## Related

- Replace Conditional with Polymorphism
- [Replace Enum Plus Payload Fields with Variant Union](replace-enum-plus-payload-fields-with-variant-union.md)
- [Remove Flag Argument](remove-flag-argument.md)
