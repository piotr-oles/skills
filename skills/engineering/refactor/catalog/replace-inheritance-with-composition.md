# Replace Inheritance with Composition

Inheritance is the wrong tool when a subclass mainly borrows implementation, overrides behavior to block inherited features, or needs to combine multiple variation axes. Replace inheritance with an owned collaborator so the object keeps the behavior it needs without exposing or depending on the whole superclass API.

## Use When

- The subclass is not truly substitutable for the superclass.
- The subclass overrides methods only to disable, narrow, or redirect inherited behavior.
- New behavior needs runtime selection, multiple independent variants, or testing with small fakes.
- Superclass changes frequently break subclasses that only wanted part of its implementation.

## Trigger

- "Is-a" relationship feels forced, but "has-a" reads naturally.
- Subclass has many unused inherited methods or protected-field access.
- Adding one new variant requires a new subclass even though only one behavior changes.
- Tests must instantiate a subclass mostly to reuse helper behavior from the parent.

## Mechanics

1. Create a collaborator that exposes only the behavior the subclass actually needs.
2. Move superclass-used behavior into the collaborator with [Move Function](move-function.md) and [Move Field](move-field.md).
3. Add the collaborator as a field and delegate through focused methods.
4. Update callers to depend on the concrete object's public API, not the old inherited API.
5. Remove inheritance once no caller needs the superclass relationship.

## Example

Before:

```ts
class CsvReport extends FileReport {
  render() {
    return this.rows.map(row => row.join(",")).join("\n");
  }
}
```

After:

```ts
class CsvReport {
  constructor(private readonly file: ReportFile) {}

  render() {
    return this.file.rows.map(row => row.join(",")).join("\n");
  }
}
```

## Related

- [Move Function](move-function.md)
