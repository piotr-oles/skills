# Use Iterator

Producing all values upfront couples the producer to memory and forces consumers to wait. Use generator functions to produce values lazily; use async generators for I/O-bound sequences so consumers pull one value at a time.

## Use When

- A function builds an array only for the caller to iterate it once.
- A callback-based API pushes values one at a time with no way to pause or cancel.
- Processing a large or potentially infinite sequence where not all values are needed.
- Paginated or streamed data where fetching ahead is wasteful or impossible.
- Composing transformations over a sequence without allocating intermediate arrays.

## Trigger

- Functions that `push` into a result array and return the whole array at the end.
- `onData` / `onResult` callbacks as the only way to consume a sequence.
- Callers awaiting a full array before beginning any processing.
- Memory pressure from large intermediate arrays.
- Pagination logic that fetches all pages before returning results.

## Mechanics

1. Replace an array-building function with a generator that `yield`s each value; replace a callback-based producer with an async generator that `yield`s as data arrives.
2. Annotate return types explicitly: `Generator<Yield, Return, Next>` and `AsyncGenerator<Yield, Return, Next>` — explicit types catch misuse early.
3. Integrate `AbortSignal` in async generators: check `signal.aborted` at each `yield` point for cooperative cancellation.
4. Compose lazy `map`/`filter` generators instead of chaining array methods that allocate intermediates; call `Array.from(gen)` only when a materialized array is genuinely needed.
5. For push-based sources (DOM events, WebSocket messages), convert to an async iterable with a small queue + `AsyncIterableIterator` wrapper rather than collecting into an array; Node.js `Readable` and Fetch `Response.body` are already `AsyncIterable` and consume with `for await...of` directly.

## Example

**Replace array builder with a synchronous generator**:

```ts
// Before
function range(start: number, end: number): number[] {
  const result: number[] = [];
  for (let i = start; i < end; i++) result.push(i);
  return result;
}

// After — lazy, no intermediate array
function* range(start: number, end: number): Generator<number> {
  for (let i = start; i < end; i++) yield i;
}

for (const n of range(0, 1_000_000)) { /* memory: O(1) */ }
```

**Replace callback-based API with an async generator**:

```ts
// Before
async function fetchAllPages(url: string, onPage: (items: Item[]) => void): Promise<void> {
  let cursor: string | undefined;
  do {
    const { items, next } = await apiFetch(url, cursor);
    onPage(items);
    cursor = next;
  } while (cursor);
}

// After — caller controls paging, can break early
async function* pages(url: string): AsyncGenerator<Item[]> {
  let cursor: string | undefined;
  do {
    const { items, next } = await apiFetch(url, cursor);
    yield items;
    cursor = next;
  } while (cursor);
}

for await (const page of pages(url)) {
  process(page);
  if (done) break; // stops fetching immediately
}
```

**Compose lazy transformations without intermediate arrays**:

```ts
function* map<T, U>(iter: Iterable<T>, fn: (x: T) => U): Generator<U> {
  for (const x of iter) yield fn(x);
}

function* filter<T>(iter: Iterable<T>, pred: (x: T) => boolean): Generator<T> {
  for (const x of iter) if (pred(x)) yield x;
}

const results = filter(map(range(0, 10_000), transform), isRelevant);
```

## Related

- [Split Loop](split-loop.md)
- [Replace Loop With Pipeline](replace-loop-with-pipeline.md)
- [Extract Function](extract-function.md)
