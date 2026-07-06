# Replace Query with Parameter

When a function reaches out to global or hidden state to get a value, pass that value in as a parameter so the function becomes pure and its dependencies explicit.

## Use When

- A function reads a global, singleton, or ambient value inside its body.
- You want the function to be pure, deterministic, and easy to test.
- The hidden reference couples the function to state it should not own.
- Callers should control the input the function currently fetches for itself.

## Trigger

- A function references a module-level variable, singleton, or `this` state that could be an argument.
- Tests must set up global state just to exercise the function.
- The same function behaves differently based on hidden context.
- You are isolating a computation to move or reuse it elsewhere.

## Mechanics

1. Identify the internal reference the function depends on.
2. Add a parameter for that value with Change Function Declaration.
3. Replace the internal reference with the new parameter.
4. Update callers to supply the value; if the query reaches into singleton or process-wide state, consider [Replace Singleton with Injected Dependency](replace-singleton-with-injected-dependency.md).
5. This is good for immutable or pure modules, but the caller must now supply the value, so call sites can become noisier — repeated identical arguments may signal excessive interface burden.

## Example

Pass target temperature source as parameter.

Before:

```ts
class HeatingPlan {
  #max!: number;
  targetTemperature() {
    if (thermostat.selectedTemperature > this.#max) return this.#max;
  }
}
```

After:

```ts
class HeatingPlan {
  #max!: number;
  targetTemperature(selectedTemperature: number) {
    if (selectedTemperature > this.#max) return this.#max;
  }
}
```

## Related

- [Replace Parameter with Query](replace-parameter-with-query.md)
- [Replace Singleton with Injected Dependency](replace-singleton-with-injected-dependency.md)
