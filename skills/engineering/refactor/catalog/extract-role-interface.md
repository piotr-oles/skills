# Extract Role Interface

Consumers should depend on the role they need, not on a concrete class or broad service. Extract a small consumer-owned interface so the dependency expresses one collaboration and can be composed, tested, or replaced independently.

## Use When

- A function accepts a concrete class but uses only a few methods.
- Tests need large real objects or mocks for a small interaction.
- Several consumers each use different slices of the same dependency.
- You want a stable boundary before moving implementation or introducing an adapter.

## Trigger

- Parameter types are concrete services, repositories, SDK clients, or framework classes.
- Call sites pass a large object when the callee needs one capability.
- Mock setup includes methods the test does not care about.
- A dependency change ripples into consumers that do not use the changed behavior.

## Mechanics

1. Look at one consumer and list only the methods it calls.
2. Create a role interface named from that consumer's need.
3. Change the consumer's parameter type to the role with Change Function Declaration.
4. Let the current concrete class implement the role without changing behavior.
5. Repeat for other consumers only when their role is actually different.

## Example

Before:

```ts
function renderInvoice(accountService: AccountService, accountId: string) {
  const account = accountService.find(accountId);
  return account.billingName;
}
```

After:

```ts
interface AccountReader {
  find(accountId: string): Account;
}

function renderInvoice(accounts: AccountReader, accountId: string) {
  const account = accounts.find(accountId);
  return account.billingName;
}
```

## Related

- [Split Interface with Composition](split-interface-with-composition.md)
- [Introduce Port Adapter](introduce-port-adapter.md)
- [Preserve Whole Object](preserve-whole-object.md)
