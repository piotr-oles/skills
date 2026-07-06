# Introduce Parameter Object

A group of arguments that always travel together is a hidden concept; bundle them into one object so the data clump gets a name and a home for related behavior.

## Use When

- The same cluster of parameters recurs across several functions.
- Two or more values only make sense together (a range, a point, a date span).
- A long parameter list is easy to get wrong at call sites.
- Behavior that operates on the clump has nowhere natural to live.

## Trigger

- The same two or three parameters appear side by side in many signatures.
- Callers pass `min, max` or `start, end` pairs repeatedly.
- Validation of the values is duplicated at each call site.
- A data clump keeps growing as new related values are threaded through.

## Mechanics

1. Create a class or type for the grouped values, with a clear domain name.
2. Change one function to accept the new object with Change Function Declaration, then update its callers.
3. Repeat for the other functions that share the clump.
4. Once the object exists, move common behavior into it, such as `contains` on a range object.
5. Add value-based equality when the object should behave as a true value object.

## Example

Replace repeated range parameters with object.

Before:

```ts
alerts = readingsOutsideRange(station, operatingPlan.temperatureFloor, operatingPlan.temperatureCeiling);
function readingsOutsideRange(station, min, max) { ... }
```

After:

```ts
const range = new NumberRange(operatingPlan.temperatureFloor, operatingPlan.temperatureCeiling);
alerts = readingsOutsideRange(station, range);
function readingsOutsideRange(station, range) { ... }
```

## Related

- [Preserve Whole Object](preserve-whole-object.md)
- [Use Builder Pattern](use-builder-pattern.md)
