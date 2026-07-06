# Replace Singleton with Injected Dependency

Singletons and global service locators hide dependencies and make tests share state. Pass the dependency explicitly so each caller can compose the implementation it needs.

## Use When

- Code reaches into a singleton, global registry, static service, or process-wide context.
- Tests must reset global state or run in a special order.
- Behavior depends on time, configuration, I/O, randomness, environment variables, or current user state.
- You need different implementations for tests, tenants, regions, or runtime modes.

## Trigger

- Calls like `Logger.instance()`, `Config.current`, `ServiceLocator.get`, or module-level clients inside business logic.
- Hidden dependencies make a function hard to call in isolation.
- A change to global configuration affects unrelated tests.
- Constructors do little work because objects fetch collaborators later from globals.

## Mechanics

1. Identify the smallest interface the caller actually needs.
2. Add the dependency as a parameter or constructor field with Change Function Declaration.
3. Keep the singleton lookup only at composition roots, factories, or application startup.
4. Update tests to pass fakes or in-memory implementations.
5. Delete global access from core code once call sites inject dependencies.

## Example

Before:

```ts
function auditLogin(userId: string) {
  Logger.instance().info(`login ${userId}`);
}
```

After:

```ts
interface Logger {
  info(message: string): void;
}

function auditLogin(logger: Logger, userId: string) {
  logger.info(`login ${userId}`);
}
```

## Related

- [Replace Query with Parameter](replace-query-with-parameter.md)
- [Introduce Port Adapter](introduce-port-adapter.md)
- [Extract Role Interface](extract-role-interface.md)
