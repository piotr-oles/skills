# Replace Derived Variable with Query

A stored value that can be computed from other state is a second source of truth; replace it with a query so it can never fall out of sync.

## Use When

- A field caches a value that is fully derivable from other fields.
- Update logic must keep the derived field consistent with its inputs.
- Bugs arise when the derived field is not updated alongside its sources.
- The computation is cheap enough to run on demand.

## Trigger

- A field is recomputed and reassigned in several mutating methods.
- A cached total or count drifts from the collection it summarizes.
- You must remember to update a field whenever related data changes.
- Two fields must always agree but nothing enforces it.

## Mechanics

1. Confirm the variable is fully determined by other durable state and has no independent meaning.
2. Replace the field with a getter that computes the value from its sources.
3. Remove the assignments that maintained the old field.
4. Keep the storage only if the computation is genuinely expensive and measured to matter.
5. Run tests to confirm callers see the same values through the query.

## Example

Calculate production from adjustments instead of storing derived copy.

Before:

```ts
class ProductionPlan {
  #adjustments: Adjustment[] = [];
  #production = 0;

  applyAdjustment(anAdjustment: Adjustment) {
    this.#adjustments.push(anAdjustment);
    this.#production += anAdjustment.amount;
  }

  get production() {return this.#production;}
}
```

After:

```ts
class ProductionPlan {
  #adjustments: Adjustment[] = [];

  applyAdjustment(anAdjustment: Adjustment) {
    this.#adjustments.push(anAdjustment);
  }

  get production() {
    return this.#adjustments.reduce((sum, a) => sum + a.amount, 0);
  }
}
```

## Related

- [Combine Functions into Class](combine-functions-into-class.md)
- [Replace Parameter with Query](replace-parameter-with-query.md)
- [Split Variable](split-variable.md)
