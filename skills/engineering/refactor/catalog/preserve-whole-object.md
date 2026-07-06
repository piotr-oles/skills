# Preserve Whole Object

When a caller pulls several values out of an object only to pass them on, pass the whole object instead, so the signature stays stable and the callee can ask for what it needs.

## Use When

- A caller extracts multiple fields from one object just to pass them as separate arguments.
- The callee could derive everything it needs from the object itself.
- The same cluster of fields is repeatedly unpacked before a call.
- Passing the object would let the callee use more of it later without signature churn.

## Trigger

- Call sites read `x.a`, `x.b`, `x.c` and pass them individually.
- Parameter lists grow whenever the callee needs one more field of the same object.
- Two or more parameters always originate from the same source object.
- A function's parameters mirror the shape of an object the caller already holds.

## Mechanics

1. Confirm the values passed all come from a single object the caller already has.
2. Change the callee to accept the whole object with Change Function Declaration.
3. Update the body to read the fields it needs from the object.
4. Update callers to pass the object directly.
5. Avoid this when the callee should not depend on the whole object, especially across a module boundary; repeated use of object parts may instead signal Feature Envy, where moving behavior to the object is stronger.

## Example

Pass room range object instead of low/high values.

Before:

```ts
const low = aRoom.daysTempRange.low;
const high = aRoom.daysTempRange.high;
if (!aPlan.withinRange(low, high)) alerts.push("room temperature went outside range");
```

After:

```ts
if (!aPlan.withinRange(aRoom.daysTempRange)) alerts.push("room temperature went outside range");
```

## Related

- [Introduce Parameter Object](introduce-parameter-object.md)
- [Replace Parameter with Query](replace-parameter-with-query.md)
- [Move Function](move-function.md)
