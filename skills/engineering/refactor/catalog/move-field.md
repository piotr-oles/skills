# Move Field

Data belongs with the code that uses it; when a field is referenced more by another class than its own, move it to where it is needed.

## Use When

- A field is used mostly by a class other than the one that declares it.
- Two records must be updated together to stay consistent.
- A field logically belongs to a concept that now has its own type.
- Passing a value around would stop if the field lived elsewhere.

## Trigger

- Methods on another class repeatedly reach back for this field.
- Updating one field always requires updating a related object too.
- A field's name references a concept owned by a different class.
- Feature envy: behavior about the field lives away from the field.

## Mechanics

1. Prefer [Encapsulate Record](encapsulate-record.md) first when possible; bare records need accessor functions and careful migration.
2. Add the field to the target and route the source's accessors through it.
3. For an immutable moved field, support duplicate writes while reads migrate.
4. Verify a shared target does not change semantics unless all source objects already agree on the value — check with data checks, logging, or [Introduce Assertion](introduce-assertion.md).
5. If constructor or statement order blocks target access, use Slide Statements first. Remove the source field once all readers use the target.

## Example

Move discount rate from Customer to contract.

Before:

```ts
class Customer {
  #discountRate: number;
  #contract: CustomerContract;
  constructor(name: string, discountRate: number) {
    this.#discountRate = discountRate;
    this.#contract = new CustomerContract(dateToday());
  }
}
```

After:

```ts
class Customer {
  #contract: CustomerContract;
  constructor(name: string, discountRate: number) {
    this.#contract = new CustomerContract(dateToday(), discountRate);
  }
  get discountRate() {return this.#contract.discountRate;}
}
```

## Related

- [Move Function](move-function.md)
- [Extract Class](extract-class.md)
- [Encapsulate Record](encapsulate-record.md)
- [Introduce Assertion](introduce-assertion.md)
