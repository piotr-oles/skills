# Retarget Test to Behavior

A test coupled to implementation breaks on behavior-preserving changes and blocks the very refactoring it should protect. Rewrite it to drive the public interface and assert observable behavior, so it survives internal restructuring.

## Use When

- A test mocks internal collaborators or asserts private methods, fields, or internal call order.
- A test verifies through internal state or the database instead of the public API.
- A test breaks when you rename or move internals though behavior is unchanged.
- A test is named for structure ("calls repository.save") rather than a capability ("saves the order").

## Trigger

- Renaming an internal function breaks tests while behavior holds.
- Mock setup mirrors the implementation step by step.
- Assertions check call counts or the order of internal method calls.
- The test reads like the code under test, not like a specification.

## Mechanics

1. Name the observable behavior the test should protect, in domain terms.
2. Rewrite the test to drive the public interface with real collaborators, or thin fakes only at a seam.
3. Drop internal mocks and assertions on private structure; assert the result through a public query or return value.
4. If a seam is needed to avoid real I/O, introduce one with [Introduce Port Adapter](introduce-port-adapter.md) or [Extract Role Interface](extract-role-interface.md).
5. Delete tests that only restate the implementation and add no behavioral guarantee.

See the /tdd skill for what behavior-focused tests look like.

## Example

Replace a mock-and-verify test with a behavior assertion.

Before:

```ts
const repo = mock<OrderRepo>();
service.place(order);
expect(repo.save).toHaveBeenCalledWith(order); // asserts how
```

After:

```ts
service.place(order);
expect(service.find(order.id)?.status).toBe("placed"); // asserts what
```

## Related

- [Extract Role Interface](extract-role-interface.md)
- [Introduce Port Adapter](introduce-port-adapter.md)
- [Replace Singleton with Injected Dependency](replace-singleton-with-injected-dependency.md)
- /tdd skill — what a behavior-focused test looks like.
