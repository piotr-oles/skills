# Extract Class

When one class holds data and behavior that change for different reasons, split off a new class so each has a single, coherent responsibility.

## Use When

- A class has grown to serve two distinct concepts.
- A subset of fields and the methods using them form a natural cluster.
- Part of a class changes for reasons unrelated to the rest.
- A data clump inside the class deserves its own type and behavior.

## Trigger

- A class name no longer describes everything it does.
- Fields group into subsets touched by disjoint sets of methods.
- Divergent change: two kinds of edits keep landing in the same class.
- A comment separates "the X part" from "the Y part" of a class.

## Mechanics

1. Decide how to split responsibilities and create the new class for the extracted concept.
2. Move the related fields to the new class with [Move Field](move-field.md), then the related methods with [Move Function](move-function.md).
3. Link the old class to the new one and delegate through focused methods during migration.
4. Decide the new class's exposure: keep it private, or expose it as its own type.
5. Once callers use the new class directly, remove now-dead delegation. Inverse: Inline Class, when a class no longer earns its keep.

## Example

Move telephone data out of Person.

Before:

```ts
class Person {
  #officeAreaCode!: string;
  #officeNumber!: string;
  get officeAreaCode() {return this.#officeAreaCode;}
  get officeNumber() {return this.#officeNumber;}
  get telephoneNumber() {return `(${this.officeAreaCode}) ${this.officeNumber}`;}
}
```

After:

```ts
class Person {
  #telephoneNumber!: TelephoneNumber;
  get officeAreaCode() {return this.#telephoneNumber.areaCode;}
  get officeNumber() {return this.#telephoneNumber.number;}
  get telephoneNumber() {return this.#telephoneNumber.toString();}
}
```

## Related

- [Move Field](move-field.md)
- [Move Function](move-function.md)
- [Extract Composed Capability](extract-composed-capability.md)
