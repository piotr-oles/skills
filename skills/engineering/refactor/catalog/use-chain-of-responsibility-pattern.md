# Use Chain of Responsibility Pattern

When processing a request through multiple potential handlers, do not hard-code the sequence. Arrange handlers so each decides to handle or pass on the request, making the chain composable and variable.

## Use When

- A request may be handled by one of several handlers depending on its type or current state.
- Handlers should be composable and their order configurable without changing individual handlers.
- Adding a new handler should not require modifying existing ones.
- Processing is a pipeline where each stage can short-circuit, transform, or enrich the request.

## Trigger

- Nested if-else or switch blocks deciding which handler processes a request.
- Middleware-like logic embedded in a single large function.
- Adding a new processing step requires modifying the central dispatch function.
- Validation chains, permission checks, or request transforms applied sequentially.

## Mechanics

1. Decide whether this is a **pipeline** (every handler runs and transforms the request) or a **chain** (first matching handler stops the rest).
2. Define a handler shape — prefer the functional middleware style `(req, next)` over linked-list handler objects in TypeScript.
3. Move each decision branch into its own handler that either handles the request or delegates to the next.
4. Assemble handlers into an ordered list at the composition root so order is configurable without editing handlers.
5. For HTTP middleware, Express/Koa/Hono already implement this pattern — model application-level chains after the same `(req, next)` convention.

## Example

**Middleware array** (functional, preferred in TypeScript):

```ts
type Middleware<T> = (req: T, next: () => Promise<void>) => Promise<void>;

async function runChain<T>(req: T, handlers: readonly Middleware<T>[]): Promise<void> {
  let i = 0;
  const next = (): Promise<void> =>
    i < handlers.length ? handlers[i++](req, next) : Promise.resolve();
  return next();
}

const pipeline: Middleware<Request>[] = [authMiddleware, rateLimitMiddleware, loggingMiddleware];
await runChain(request, pipeline);
```

**Handler interface** when each handler owns state or has complex logic:

```ts
interface Handler<T, R> {
  handle(req: T): R | null; // null = pass to next
}

function runHandlers<T, R>(req: T, handlers: readonly Handler<T, R>[]): R | null {
  for (const h of handlers) {
    const result = h.handle(req);
    if (result !== null) return result;
  }
  return null;
}
```

[Decorator](use-decorator-pattern.md) and Chain of Responsibility both layer behavior; Decorator always delegates, CoR may stop the chain early.

## Related

- [Use Decorator Pattern](use-decorator-pattern.md)
- [Replace Conditional with Strategy](replace-conditional-with-strategy.md)
- [Remove Flag Argument](remove-flag-argument.md)
