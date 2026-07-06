# Change Value to Reference

When many copies of the same logical entity should share updates and identity, replace the duplicated value copies with a single shared reference.

## Use When

- The same real-world entity is represented by many separate value copies.
- Updating the entity must be reflected everywhere it appears.
- Copies drift out of sync because each is updated independently.
- Identity of the entity matters across the system.

## Trigger

- Constructing a new object from data every time the same entity is referenced.
- Bugs where an update to one copy does not reach others.
- The same customer, product, or account exists as several unlinked instances.
- Reconciling duplicate copies becomes routine maintenance.

## Mechanics

1. Confirm the entity has a genuine identity that should be shared, not copied.
2. Introduce a way to obtain the single instance for a given identity — a repository or lookup keyed by id.
3. Replace construction of new copies with a lookup that returns the shared instance.
4. Ensure the instance is created once and reused for all references to the same id.
5. In TypeScript, prefer a reactive store, DI container, or event-based update over a global mutable registry; the registry approach hides coupling and complicates testing.

## Example

Use registry reference instead of new value copy.

Before:

```ts
class Order {
  #customer: Customer;
  constructor(data: OrderData) {
    this.#customer = new Customer(data.customer);
  }
}
```

After:

```ts
class Order {
  #customer: Customer;
  constructor(data: OrderData) {
    this.#customer = registerCustomer(data.customer);
  }
}
```

## Related

- [Change Reference to Value](change-reference-to-value.md)
- [Replace Singleton with Injected Dependency](replace-singleton-with-injected-dependency.md)
