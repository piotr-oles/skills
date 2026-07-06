# Use Builder Pattern

Complex construction should not be the caller's responsibility. Extract the construction sequence into a builder that accumulates configuration and returns a finished, validated object.

## Use When

- A constructor has more than four or five parameters and callers must pass `undefined` or `null` for unused slots.
- Object construction spans multiple optional configuration steps.
- The same object is constructed with slight variations across many call sites.
- An object should only exist in a valid, complete state — partial construction must not be observable.

## Trigger

- Constructors or factory functions with growing parameter lists.
- Callers repeating a sequence of setters or mutations before the object is usable.
- Test setup building the same object with minor variations.
- Boolean or enum parameters selecting a construction mode.

## Mechanics

1. Prefer [Introduce Parameter Object](introduce-parameter-object.md) first; graduate to a builder only when the options object acquires validation or conditional steps.
2. Create a builder that holds accumulating private state; each configuration method mutates state and returns `this`.
3. Give `build()` a return type that differs from the builder, letting the type system enforce that construction is complete before use.
4. Validate invariants inside `build()`, then return a frozen or `Readonly<T>` value so the built object is immutable.
5. Use a builder when construction logic is complex, shared, or multi-step; use a plain options object when callers just need named parameters.

## Example

Fluent builder — each configuration method returns `this`; `build()` validates and returns a `Readonly<T>`:

```ts
class QueryBuilder {
  #table = "";
  #conditions: string[] = [];
  #limit?: number;

  from(table: string): this { this.#table = table; return this; }
  where(condition: string): this { this.#conditions.push(condition); return this; }
  limitTo(n: number): this { this.#limit = n; return this; }

  build(): Readonly<Query> {
    if (!this.#table) throw new Error("table is required");
    return Object.freeze(new Query(this.#table, this.#conditions, this.#limit));
  }
}

const q = new QueryBuilder().from("users").where("active = true").limitTo(10).build();
```

For **simple option bags**, prefer a typed options object with a factory function over a full builder class:

```ts
function createQuery(opts: { table: string; where?: string[]; limit?: number }): Query { ... }
```

## Related

- [Introduce Parameter Object](introduce-parameter-object.md)
- [Replace Constructor With Factory Function](replace-constructor-with-factory-function.md)
