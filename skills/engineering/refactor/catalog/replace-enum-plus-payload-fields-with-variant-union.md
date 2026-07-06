# Replace Enum Plus Payload Fields with Variant Union

An enum or type-code field plus a pile of optional payload fields is a union trying to get out. Move payload fields onto the enum variants that actually own them.

## Use When

- An enum says what kind of value this is, while separate optional fields carry kind-specific data.
- Each enum case has different required data.
- Adding an enum case forces changes to validation, construction, and consumers.
- Rust, TypeScript, or another typed language can encode payload-carrying variants directly.

## Trigger

- Fields named `kind`, `type`, `status`, or `mode` with many sibling optional fields.
- Switch branches each read a different subset of payload fields.
- Constructors accept broad optional data and validate based on enum value.
- Runtime errors say a field is missing for a specific enum case.

## Mechanics

1. Keep the enum only if cases have no payload; otherwise introduce payload-carrying variants.
2. Move each case-specific field into its variant.
3. Replace broad constructors with variant constructors or factory functions.
4. Update consumers to match on the variant and use payload values after narrowing.
5. Remove payload optionality that is no longer needed.

## Example

Before:

```ts
type Payment = {
  method: "card" | "bank";
  cardToken?: string;
  accountId?: string;
};
```

After:

```ts
type Payment =
  | { method: "card"; cardToken: string }
  | { method: "bank"; accountId: string };
```

## Related

- [Replace Optional Fields with Variant Union](replace-optional-fields-with-variant-union.md)
- [Add Exhaustive Match](add-exhaustive-match.md)
