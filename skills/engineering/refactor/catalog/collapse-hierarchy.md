# Collapse Hierarchy

When a subclass no longer differs enough from its parent to justify the split, merge them so the hierarchy stops advertising a variation that does not exist.

## Use When

- A subclass adds no fields or behavior the parent lacks.
- Earlier refactorings pulled behavior up or down until the two are nearly identical.
- The hierarchy was created for future variants that never arrived.
- A `sealed`/closed set of subtypes has collapsed to a single meaningful case.

## Trigger

- A subclass overrides nothing, or only re-declares what it inherits.
- Callers cannot say why they would pick the subclass over the parent.
- The only remaining difference is a name.

## Mechanics

1. Choose which class survives — usually the parent.
2. Move the other class's fields and methods into the survivor with [Move Function](move-function.md) and [Move Field](move-field.md).
3. Redirect all references and constructions to the survivor.
4. Delete the now-empty class and remove the inheritance link.

## Example

Merge an empty subclass into its parent.

Before:

```ts
class Employee {
  constructor(readonly name: string) {}
}
class Salesperson extends Employee {}
```

After:

```ts
class Employee {
  constructor(readonly name: string) {}
}
```

## Related

- [Replace Inheritance with Composition](replace-inheritance-with-composition.md)
- [Replace Subclasses with Union Variants](replace-subclasses-with-union-variants.md)
- [Inline Class](inline-class.md)
