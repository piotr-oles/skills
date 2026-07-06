# Inline Class

When a class no longer carries its weight — it holds a field or two and a little behavior that belongs with its only user — fold it back into that user to remove a speculative boundary.

## Use When

- A class was extracted for a responsibility that never grew.
- Only one other class uses it, and the split adds indirection without clarity.
- Two classes changed together so often that the seam between them is noise.
- You are consolidating before re-splitting along a better boundary.

## Trigger

- A class has few methods and fields and exactly one client.
- Reading the pair means constantly jumping between two files to follow one idea.
- The class exposes accessors that exist only so its single client can reach its data.

## Mechanics

1. Declare the source class's public methods on the absorbing class, delegating to the source for now.
2. Redirect every reference from the source class to the absorbing class.
3. Move each field and method from the source into the absorbing class.
4. Delete the source class once nothing references it.

## Example

Fold a single-use `TelephoneNumber` back into `Person`.

Before:

```ts
class Person {
  #phone = new TelephoneNumber();
  get telephoneNumber() { return this.#phone.toString(); }
}
class TelephoneNumber {
  areaCode = "";
  number = "";
  toString() { return `(${this.areaCode}) ${this.number}`; }
}
```

After:

```ts
class Person {
  areaCode = "";
  number = "";
  get telephoneNumber() { return `(${this.areaCode}) ${this.number}`; }
}
```

## Related

- [Extract Class](extract-class.md)
- [Inline Function](inline-function.md)
