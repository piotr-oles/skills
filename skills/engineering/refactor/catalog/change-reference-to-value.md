# Change Reference to Value

When an inner object's identity does not matter but its data does, treat it as an immutable value so it can be shared and compared freely without aliasing bugs.

## Use When

- A small object represents data, not a shared entity with identity.
- Aliasing and shared mutation of the object cause hard-to-trace bugs.
- You want value-based equality instead of identity comparison.
- Snapshots, copies, or serialization would be simpler with immutable values.

## Trigger

- Two holders share one mutable object and one mutates it unexpectedly.
- Equality checks want to compare contents, not references.
- The object is passed around as data but callers must guard against mutation.
- You are introducing snapshots or undo and need cheap, safe copies.

## Mechanics

1. Confirm the object's identity is irrelevant to the domain — only its data matters.
2. Make the object immutable: remove setters and construct a new instance for every change.
3. Replace in-place mutation of the field with assignment of a fresh value object.
4. Add value-based equality so contents compare correctly.
5. Update holders to replace rather than mutate the shared instance.

## Example

Replace mutable reference object with immutable value object.

Before:

```ts
aPerson.officeAreaCode = "312";
aPerson.officeNumber = "5550142";
```

After:

```ts
aPerson.telephoneNumber = new TelephoneNumber("312", "5550142");
```

## Related

- [Change Value to Reference](change-value-to-reference.md)
- [Use Memento Pattern](use-memento-pattern.md)
