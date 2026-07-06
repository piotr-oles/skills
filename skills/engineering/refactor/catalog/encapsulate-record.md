# Encapsulate Record

Give a bare record a defined shape and controlled access, so callers depend on a stable interface rather than an ad-hoc bag of fields.

## Use When

- A record is passed around widely and its shape is implicit or drifting.
- You want to change the internal representation without breaking every reader.
- Some fields are derived and should not be stored, or need validation on write.
- Mutable data is aliased and accidental shared writes cause bugs.

## Trigger

- The same object literal shape is assumed in many places with no type.
- Callers reach into deeply nested fields directly.
- You cannot tell which fields are stored versus computed.
- Mutations to a shared record surface as spooky action at a distance.

## Mechanics

1. For immutable data, define a typed interface or type alias; callers read fields directly, and `as const satisfies T` locks the shape at the call site.
2. For mutable data needing controlled access, use a class with private fields and accessors.
3. For nested structures, define nested interfaces and migrate update paths first before adding validation.
4. Copy on construction or use `Readonly<T>` / `structuredClone` to avoid aliasing bugs with mutable data.
5. Avoid wrapping every plain DTO in a class; reserve classes for records that need invariants, validation, or lifecycle behavior.

## Example

For **immutable data** — define a typed interface or type alias; callers read fields directly:

```ts
interface Organization {
  readonly name: string;
  readonly country: string;
}

const org: Organization = { name: "Acme Gooseberries", country: "GB" };
```

For **mutable data with controlled access** — use a class with private fields and accessors:

```ts
class Organization {
  #name: string;
  #country: string;

  constructor(data: { name: string; country: string }) {
    this.#name = data.name;
    this.#country = data.country;
  }

  get name() { return this.#name; }
  set name(value: string) { this.#name = value; }
  get country() { return this.#country; }
}
```

For **nested structures**, define nested interfaces and migrate update paths first before adding validation.

## Related

- [Extract Class](extract-class.md)
- [Replace Optional Fields with Variant Union](replace-optional-fields-with-variant-union.md)
