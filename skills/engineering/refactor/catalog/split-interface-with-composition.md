# Split Interface with Composition

A large interface forces implementers and consumers to depend on methods they do not use. Split it into small role interfaces, then compose objects from the roles each workflow actually needs.

## Use When

- Implementers have empty, throwing, or fake implementations for interface methods.
- Consumers use only one coherent slice of a broad API.
- One interface changes for several unrelated reasons.
- Tests require bulky stubs even when the code under test needs only one operation.

## Trigger

- Interface names end with generic words like `Manager`, `Service`, `Handler`, or `Client`.
- Implementations contain `UnsupportedOperation`, `NotImplemented`, or no-op methods.
- Call sites accept a large interface but touch only one or two methods.
- A new feature adds methods for one consumer and forces many unrelated implementers to change.

## Mechanics

1. Group interface methods by consumer role and change reason.
2. Extract one small interface per role, using names from the consumer's language.
3. Update consumers to depend on the smallest role interface they need with Change Function Declaration.
4. Let existing concrete objects implement multiple small interfaces during migration.
5. Compose broader services from smaller roles instead of growing one central interface.

## Example

Before:

```ts
interface UserService {
  findUser(id: string): User;
  saveUser(user: User): void;
  sendPasswordReset(id: string): void;
}
```

After:

```ts
interface UserReader {
  findUser(id: string): User;
}

interface PasswordResetSender {
  sendPasswordReset(id: string): void;
}
```

## Related

- [Extract Class](extract-class.md)
- [Preserve Whole Object](preserve-whole-object.md)
