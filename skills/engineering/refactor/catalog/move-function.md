# Move Function

A function should live near the data and other functions it collaborates with; move it to the context where it belongs.

## Use When

- A function references another module or class more than its current home.
- A nested helper would be reusable if lifted out.
- Related functions are scattered across modules that change together.
- A function's dependencies all live in a different context.

## Trigger

- A function calls methods or reads fields of another object throughout its body.
- Feature envy: the function is more interested in another class than its own.
- Shotgun surgery: a change forces edits to functions spread across files.
- A nested function obscures the enclosing function it is buried in.

## Mechanics

1. Examine everything the function references in its current scope and decide what must move with it.
2. Copy the function to the target context and adjust references to fit.
3. For nested functions, pass captured data as parameters or move dependent helpers too.
4. Turn the original into a forwarding call, or update callers to the new location directly.
5. Remove the original once no caller needs it.

## Example

Move nested distance helpers out of `trackSummary`.

Before:

```ts
function trackSummary(points) {
  const totalDistance = calculateDistance();
  function calculateDistance() { ... }
  function distance(p1, p2) { ... }
}
```

After:

```ts
function trackSummary(points) {
  const totalDistance = totalDistance(points);
}
function totalDistance(points) { ... }
function distance(p1, p2) { ... }
```

## Related

- [Move Field](move-field.md)
- [Extract Function](extract-function.md)
- [Extract Class](extract-class.md)
