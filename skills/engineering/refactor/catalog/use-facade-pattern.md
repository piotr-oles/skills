# Use Facade Pattern

A complex subsystem should expose a simple surface for common use cases. Introduce a facade that orchestrates the subsystem and hides its internal structure from callers.

## Use When

- Callers must coordinate multiple subsystem components to perform one coherent task.
- The same sequence of subsystem calls repeats across unrelated callers.
- You want a stable public API over a subsystem that changes frequently.
- Tests need to mock a complex dependency and a narrow facade is easier to stub than the full subsystem.

## Trigger

- Callers import many unrelated modules just to complete one operation.
- Initialization or teardown sequences scattered across callers.
- A subsystem has many low-level classes with no obvious entry point.
- Changing an internal library forces changes in many caller files.

## Mechanics

1. Identify one coherent task that callers repeatedly assemble from subsystem calls.
2. Create a plain exported function that orchestrates the subsystem for that task; use a class only when the facade must hold shared state.
3. Keep the facade thin — it orchestrates, it does not own business logic.
4. Leave the subsystem accessible directly for callers that need full control; the facade does not forbid it.
5. If the facade starts growing, extract further with [Extract Class](extract-class.md) or [Split Phase](split-phase.md).

## Example

A facade is usually a plain exported function or a thin module:

```ts
// Subsystem internals
import { parseConfig } from "./config-parser.js";
import { validateSchema } from "./schema.js";
import { buildClient } from "./http.js";

// Facade — one import, one call
export async function createApiClient(configPath: string): Promise<ApiClient> {
  const config = parseConfig(configPath);
  validateSchema(config);
  return buildClient(config);
}
```

Use a class only when the facade must hold shared state:

```ts
export class ReportFacade {
  constructor(private readonly db: Db, private readonly mailer: Mailer) {}

  async sendMonthlyReport(userId: string): Promise<void> {
    const data = await this.db.fetchUsage(userId);
    const pdf = renderPdf(data);
    await this.mailer.send(userId, pdf);
  }
}
```

Facade and [Introduce Port Adapter](introduce-port-adapter.md) pair naturally: the adapter translates one external API, the facade orchestrates several.

## Related

- [Introduce Port Adapter](introduce-port-adapter.md)
- [Extract Role Interface](extract-role-interface.md)
- [Split Interface with Composition](split-interface-with-composition.md)
