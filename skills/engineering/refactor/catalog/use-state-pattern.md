# Use State Pattern

When an object behaves differently in each state and only certain transitions are legal, scattered `if (status === …)` guards let illegal moves slip through. Model the states, dispatch behavior per state, and make transitions go through one place that rejects illegal moves.

## Use When

- Behavior of several operations changes depending on a mode/status field.
- Only certain state-to-state transitions are legal, and the rules live nowhere explicit.
- Adding a new state means editing many scattered call sites.
- Bugs come from acting in the wrong state ("can't ship an unpaid order").

## Trigger

- Repeated guards checking a status before nearly every operation.
- Bug fixes that add another "cannot do X while in state Y" check.
- Transition rules are implied by conditionals, never stated in one place.
- An operation silently no-ops or throws when called in the wrong state.

## Mechanics

1. Model the states as a tagged union first with [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md), so each state carries only its valid data.
2. Define a single transition function `(state, event) => state` that returns the next state or rejects an illegal event.
3. Dispatch state-specific behavior by matching on the state (or via a small per-state interface when behavior is large), with [Add Exhaustive Match](add-exhaustive-match.md) so a new state forces every consumer to handle it.
4. Route every state change through the transition function; delete the scattered status guards.

## Example

Order lifecycle with one transition function.

Before:

```ts
if (order.status === "paid" && !order.shipped) { /* ship */ }
else throw new Error("cannot ship");
```

After:

```ts
type Order =
  | { state: "pending" }
  | { state: "paid" }
  | { state: "shipped" };

function transition(order: Order, event: "pay" | "ship"): Order {
  if (order.state === "pending" && event === "pay") return { state: "paid" };
  if (order.state === "paid" && event === "ship") return { state: "shipped" };
  throw new Error(`illegal ${event} from ${order.state}`);
}
```

## Related

- [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md)
- [Replace Conditional with Strategy](replace-conditional-with-strategy.md)
- [Add Exhaustive Match](add-exhaustive-match.md)
