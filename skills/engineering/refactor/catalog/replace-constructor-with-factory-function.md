# Replace Constructor with Factory Function

A raw constructor call names a class and exposes type codes; replace it with a factory function that names the intent and hides construction details.

## Use When

- A constructor takes a type code that selects what is really being created.
- Construction should return different types or cached instances, which a constructor cannot.
- The class name is a poor description of what callers are creating.
- You want a named entry point instead of `new` scattered across callers.

## Trigger

- Calls like `new Employee(name, "E")` where a string code picks a role.
- Callers must know the class and its type-code convention to construct correctly.
- You want to vary the concrete return type without changing call sites.
- `new` appears throughout the codebase with construction logic duplicated.

## Mechanics

1. Create a factory function whose name states what it produces.
2. Move the constructor call and any type-code arguments inside the factory.
3. Replace caller `new` expressions with calls to the factory.
4. Let the factory choose the concrete type, cache instances, or validate as needed.
5. Restrict the constructor's visibility once all callers use factories.

## Example

Replace type-code constructor call with factory.

Before:

```ts
const leadEngineer = new Employee(document.leadEngineer, "E");
```

After:

```ts
const leadEngineer = createEngineer(document.leadEngineer);

function createEngineer(name) {
  return new Employee(name, "E");
}
```

## Related

- [Use Builder Pattern](use-builder-pattern.md)
- [Replace Enum Plus Payload Fields with Variant Union](replace-enum-plus-payload-fields-with-variant-union.md)
