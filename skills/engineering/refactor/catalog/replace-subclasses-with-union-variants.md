# Replace Subclasses with Union Variants

Some class hierarchies are only data variants with little or no behavior. Replace them with union variants when exhaustive handling and plain data are clearer than inheritance.

## Use When

- Subclasses mostly store different fields and contain little behavior.
- Callers immediately inspect subclass type to decide what to do.
- The hierarchy exists to model a closed set of cases.
- You want serialization, pattern matching, or exhaustive handling instead of virtual dispatch.

## Trigger

- Empty subclasses or subclasses that only set constructor fields.
- `instanceof` checks after objects are created.
- Visitor-like code whose only job is to recover the concrete subtype.
- A new subclass requires updating every consumer anyway.

## Mechanics

1. Confirm the set of cases is closed or controlled by this module.
2. Create one union variant per subclass, carrying the subclass fields.
3. Replace subclass construction with variant construction.
4. Move behavior either into functions that match the union or into composed strategies when behavior is open-ended.
5. Delete subclasses after all callers use the union.

## Example

Before:

```ts
class Circle { constructor(readonly radius: number) {} }
class Rectangle { constructor(readonly width: number, readonly height: number) {} }
type Shape = Circle | Rectangle;
```

After:

```ts
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number };
```

## Related

- [Replace Inheritance with Composition](replace-inheritance-with-composition.md)
- [Add Exhaustive Match](add-exhaustive-match.md)
