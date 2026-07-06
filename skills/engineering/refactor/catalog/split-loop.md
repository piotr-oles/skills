# Split Loop

A loop doing several unrelated things at once resists change; split it so each loop does one thing and can be named, moved, or extracted independently.

## Use When

- One loop computes two or more unrelated results.
- You want to extract one concern from the loop but the shared body blocks it.
- Different computations in the loop change for different reasons.
- Clarity matters more than a single traversal.

## Trigger

- A loop body accumulates into several unrelated variables.
- Comments inside the loop separate distinct concerns.
- You cannot extract a calculation because it is entangled with another in the same loop.
- Two halves of a loop body share nothing but the iteration.

## Mechanics

1. Copy the loop so there are two identical loops over the same collection.
2. Remove from each copy the work that belongs to the other, leaving one concern per loop.
3. Run tests; the extra traversal is usually not a real bottleneck — refactor for clarity first, optimize after measuring.
4. Consider extracting each loop into its own named function with [Extract Function](extract-function.md).
5. Split loops can expose better optimizations than one dense loop.

## Example

Split loop that calculates youngest age and total salary.

Before:

```ts
let youngest = people[0] ? people[0].age : Infinity;
let totalSalary = 0;
for (const p of people) {
  if (p.age < youngest) youngest = p.age;
  totalSalary += p.salary;
}
```

After:

```ts
let totalSalary = 0;
for (const p of people) totalSalary += p.salary;

let youngest = people[0] ? people[0].age : Infinity;
for (const p of people) if (p.age < youngest) youngest = p.age;
```

## Related

- [Extract Function](extract-function.md)
- [Replace Loop with Pipeline](replace-loop-with-pipeline.md)
