# Split Phase

When one block of code does two different things in sequence, split it into separate phases so each can be understood, tested, and changed on its own.

## Use When

- A function first computes intermediate data, then uses it for a distinct second purpose.
- Two concerns are interleaved but depend only through a small handoff of data.
- One phase would be reusable or testable if it were not fused to the next.
- Different inputs govern different stages of the same computation.

## Trigger

- A function reads one set of parameters early and a different set late.
- You can describe the code as "first do X, then do Y" where X's output feeds Y.
- Mixed levels of abstraction: parsing tangled with calculation, or calculation with formatting.
- Tests must set up the second concern just to exercise the first.

## Mechanics

1. Identify the boundary where the first phase's output becomes the second phase's input.
2. Extract the second phase into its own function with [Extract Function](extract-function.md).
3. Introduce an intermediate data structure to carry the first phase's results; keep this handoff small and meaningfully named.
4. Extract the first phase, returning the intermediate structure.
5. Leave parameters that truly belong only to the second phase, such as external strategy or config input.

## Example

Split order pricing into pricing data phase and shipping phase.

Before:

```ts
function priceOrder(product, quantity, shippingMethod) {
  const basePrice = product.basePrice * quantity;
  const discount = Math.max(quantity - product.discountThreshold, 0) * product.basePrice * product.discountRate;
  const shippingPerCase = basePrice > shippingMethod.discountThreshold ? shippingMethod.discountedFee : shippingMethod.feePerCase;
  return basePrice - discount + quantity * shippingPerCase;
}
```

After:

```ts
function priceOrder(product, quantity, shippingMethod) {
  const priceData = calculatePricingData(product, quantity);
  return applyShipping(priceData, shippingMethod);
}
```

## Related

- [Extract Function](extract-function.md)
- [Combine Functions into Class](combine-functions-into-class.md)
- [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md)
