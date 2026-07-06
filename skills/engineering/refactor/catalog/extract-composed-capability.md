# Extract Composed Capability

Optional behavior should not force every object in a hierarchy or interface to carry methods it cannot honestly support. Extract the capability into a small component and compose it only into objects that have that capability.

## Use When

- Some objects support an operation and others only pretend to.
- A class has optional feature branches, nullable collaborators, or capability flags.
- The same optional behavior is spreading across unrelated types.
- You need to add a capability without widening a base class or central interface.

## Trigger

- Methods named `canX`, `supportsX`, `isXEnabled`, or `hasX` guard most calls.
- Base classes include hooks that only a few subclasses override.
- Interfaces grow optional methods because one implementer needs them.
- Feature flags decide whether an object has behavior that could be a component.

## Mechanics

1. Name the capability from the operation clients want, not from the current class.
2. Extract the capability interface and move related behavior into an implementation with [Extract Class](extract-class.md).
3. Add the capability as a collaborator where supported.
4. Update clients to ask for or receive the capability directly instead of probing the host object.
5. Remove capability flags and optional base methods when no longer needed.

## Example

Before:

```ts
class Account {
  canExportCsv() { return this.plan === "pro"; }
  exportCsv() { /* pro-only export */ }
}
```

After:

```ts
class CsvExportCapability {
  export(account: Account) { /* export */ }
}

class Account {
  constructor(readonly csvExport?: CsvExportCapability) {}
}
```

## Related

- [Extract Class](extract-class.md)
- [Remove Flag Argument](remove-flag-argument.md)
- Replace Conditional with Polymorphism
