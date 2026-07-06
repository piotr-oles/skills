# Replace Optional Fields with Variant Union

A record with many optional fields often represents several different shapes hidden inside one type. Replace it with a tagged union so each variant carries only the fields that are valid for that case.

## Use When

- Many fields are optional but only certain combinations are valid.
- Code repeatedly checks a `status`, `kind`, or `type` field before reading optional fields.
- AI-generated DTOs use `foo?: T` for every possible state instead of modeling variants.
- Bugs come from impossible states such as `loaded` without `data` or `failed` without `error`.

## Trigger

- Interfaces where most properties are marked `?`.
- Comments saying "present only when status is X".
- Validation code rejects combinations the type system could have made impossible.
- Callers use non-null assertions or casts after checking a discriminant.

## Mechanics

1. Identify the real variants and choose a discriminant such as `kind`, `type`, or `state`.
2. Create one variant type per valid shape, moving required fields into the owning variant.
3. Replace the broad optional record with the union of variants.
4. Update constructors and parsers to produce exactly one variant.
5. Update consumers to narrow on the discriminant, then remove obsolete optional checks.

## Example

Before:

```ts
type RequestState = {
  status: "idle" | "loading" | "success" | "error";
  data?: User;
  error?: Error;
};
```

After:

```ts
type RequestState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: Error };
```

## Related

- [Replace Enum Plus Payload Fields with Variant Union](replace-enum-plus-payload-fields-with-variant-union.md)
- [Add Exhaustive Match](add-exhaustive-match.md)
- [Encapsulate Record](encapsulate-record.md)
