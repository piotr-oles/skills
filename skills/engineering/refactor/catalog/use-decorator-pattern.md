# Use Decorator Pattern

Cross-cutting behavior should wrap an existing object or function rather than be mixed into it. A decorator implements the same interface as the wrapped subject and delegates to it, adding behavior before or after without changing the subject.

## Use When

- The same cross-cutting concern (logging, caching, retry, authorization, timing, rate limiting) applies to many different implementations.
- Behavior must be composable: one subject should be wrappable by multiple orthogonal decorators.
- A concern varies at runtime or per deployment without modifying the subject.
- Tests need to verify cross-cutting behavior independently of business logic.

## Trigger

- The same logging, error-handling, or retry logic copy-pasted into multiple service methods.
- Middleware logic hard-coded inside business functions.
- A class growing with concerns that are not its core responsibility.
- Adding a new cross-cutting concern requires touching every implementation.

## Mechanics

1. Identify the interface or function signature shared by the subject and its wrapper.
2. Create a decorator that accepts the subject, delegates to it, and adds one concern before or after the delegated call.
3. Keep each decorator focused on one concern — do not combine logging and caching into one wrapper.
4. Prefer function decorators over class decorators when subjects are functions or simple callables.
5. Stack decorators explicitly at the composition root so their order is visible; TypeScript `@Decorator` syntax is a separate, framework-specific mechanism and is not required here.

## Example

**Function decorator** — wrap any function with the same signature:

```ts
function withRetry<A extends unknown[]>(
  fn: (...args: A) => Promise<void>,
  attempts = 3
): (...args: A) => Promise<void> {
  return async (...args) => {
    for (let i = 0; i < attempts; i++) {
      try { return await fn(...args); }
      catch (e) { if (i === attempts - 1) throw e; }
    }
  };
}

const reliableSend = withRetry(sendEmail);
```

**Class decorator** — implement the same interface as the subject:

```ts
class LoggingUserService implements UserService {
  constructor(private readonly inner: UserService, private readonly log: Logger) {}

  async findUser(id: string): Promise<User> {
    this.log.info(`findUser ${id}`);
    return this.inner.findUser(id);
  }
}

const service = new LoggingUserService(new DbUserService(db), logger);
```

Stack decorators explicitly:

```ts
const fetch = withLogging(withRetry(withCache(fetchUser)));
```

Decorators and [Chain of Responsibility](use-chain-of-responsibility-pattern.md) both compose behavior, but a decorator always delegates while a chain handler may stop early.

## Related

- [Extract Role Interface](extract-role-interface.md)
- [Introduce Port Adapter](introduce-port-adapter.md)
- [Use Chain of Responsibility Pattern](use-chain-of-responsibility-pattern.md)
- [Replace Singleton with Injected Dependency](replace-singleton-with-injected-dependency.md)
