# Replace Loop with Pipeline

A loop that filters, transforms, and collects hides its intent in imperative steps; express it as a collection pipeline so each operation reads as a named stage.

## Use When

- A loop combines filtering, mapping, and accumulation into one body.
- The loop's purpose is obscured by index bookkeeping or temporary collections.
- Each iteration step maps cleanly onto `filter`, `map`, `slice`, or `reduce`.
- You want the data flow to read top to bottom as a sequence of transforms.

## Trigger

- A `for` loop pushes into a result array after several `if` checks.
- Manual accumulation that a standard collection operation expresses directly.
- Nested conditionals inside a loop that each correspond to one pipeline stage.
- Index variables used only to walk the collection.

## Mechanics

1. Identify the source collection the loop iterates.
2. Convert each distinct concern in the loop body into a pipeline stage: skip rows with `filter`, reshape with `map`, drop headers with `slice`.
3. Replace the accumulation with the terminal pipeline result.
4. Keep an intermediate collection variable when it explains the source data.
5. Delete the loop and its temporaries once the pipeline produces the same result.

## Example

Replace loop-based CSV parsing with pipeline.

Before:

```ts
const result = [];
for (const line of input.split("\n")) {
  if (line.trim() === "") continue;
  const record = line.split(",");
  if (record[1].trim() === "India") result.push({city: record[0].trim(), phone: record[2].trim()});
}
```

After:

```ts
return input
  .split("\n")
  .slice(1)
  .filter(line => line.trim() !== "")
  .map(line => line.split(","))
  .filter(record => record[1].trim() === "India")
  .map(record => ({city: record[0].trim(), phone: record[2].trim()}));
```

## Related

- [Split Loop](split-loop.md)
- [Substitute Algorithm](substitute-algorithm.md)
- [Use Iterator](use-iterator.md)
