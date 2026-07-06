# Introduce Special Case

When many callers check for the same special value and then supply the same substitute behavior, capture that case as an object so the checks disappear.

## Use When

- The same conditional check for a special value is repeated across callers.
- A missing, unknown, or null case has consistent default behavior.
- Callers duplicate the substitute values for the special case.
- Absence or a sentinel is handled the same way everywhere.

## Trigger

- Repeated checks like `x === "unknown"` or `x == null` before using defaults.
- The same default name, plan, or value supplied at each such check.
- Null checks scattered across the codebase with identical fallbacks.
- Adding a field means updating every special-case check.

## Mechanics

1. Create a special-case object that responds to the same interface as the normal case, returning the default values.
2. Return the special-case object from the source instead of the sentinel value.
3. Replace each caller's conditional check with normal use of the returned object.
4. Make special-case objects immutable value objects; setters usually no-op when the substitute must accept writes.
5. If the special case returns a related object, return another special case such as `NullPaymentHistory`; if absence should be part of a finite state model, prefer a domain-specific variant union over a broad optional record.

## Example

Replace repeated unknown-customer checks with special-case customer.

Before:

```ts
const name = aCustomer === "unknown" ? "occupant" : aCustomer.name;
const plan = aCustomer === "unknown" ? registry.billingPlans.basic : aCustomer.billingPlan;
```

After:

```ts
const name = aCustomer.name;
const plan = aCustomer.billingPlan;

class UnknownCustomer {
  get name() {return "occupant";}
  get billingPlan() {return registry.billingPlans.basic;}
}
```

## Related

- [Replace Optional Fields with Variant Union](replace-optional-fields-with-variant-union.md)
- [Replace Nested Conditional with Guard Clauses](replace-nested-conditional-with-guard-clauses.md)
