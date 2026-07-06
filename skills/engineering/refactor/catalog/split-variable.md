# Split Variable

A variable reassigned to mean different things at different points confuses readers; give each responsibility its own single-assignment variable with a clear name.

## Use When

- One variable is assigned more than once to hold unrelated values.
- A parameter is overwritten inside the function body.
- A reused temporary makes it hard to follow what a value represents.
- Distinct concepts share one name only for convenience.

## Trigger

- A variable is reassigned with a different meaning partway through a function.
- You must track "what does this variable mean here?" while reading.
- A parameter is both input and scratch space.
- The same name holds a primary and then a secondary computation.

## Mechanics

1. For each distinct meaning, introduce a new variable named for that specific purpose.
2. Prefer `const` (single assignment) for each new variable to make intent clear.
3. Update references so each use points at the correctly-named variable.
4. For an overwritten parameter, keep the original parameter as input, create a separate result variable, then use Rename Variable for clearer names.
5. Do not split collecting variables such as sums, string concatenation, stream writes, or collection additions.

## Example

Split reassigned variable into purpose-specific variables.

Before:

```ts
let acc = scenario.primaryForce / scenario.mass;
let primaryTime = Math.min(time, scenario.delay);
result = 0.5 * acc * primaryTime * primaryTime;
acc = (scenario.primaryForce + scenario.secondaryForce) / scenario.mass;
```

After:

```ts
const primaryAcceleration = scenario.primaryForce / scenario.mass;
let primaryTime = Math.min(time, scenario.delay);
result = 0.5 * primaryAcceleration * primaryTime * primaryTime;
const secondaryAcceleration = (scenario.primaryForce + scenario.secondaryForce) / scenario.mass;
```

## Related

- [Extract Function](extract-function.md)
- [Replace Derived Variable with Query](replace-derived-variable-with-query.md)
