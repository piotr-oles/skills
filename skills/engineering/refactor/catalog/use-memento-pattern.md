# Use Memento Pattern

State that must be restored should be captured outside the object. Take immutable snapshots at meaningful points so the originator can roll back without exposing its internal structure.

## Use When

- Users need undo/redo in an editor, canvas, or form.
- A multi-step wizard must support navigating back to a previous state.
- An optimistic UI update must revert cleanly on failure.
- A transaction-like operation must restore prior state on error.

## Trigger

- State manually deep-copied before risky operations.
- Undo implemented by storing ad-hoc full copies in arrays scattered through the codebase.
- Rollback logic owned by callers rather than by the state holder.
- Tests reconstructing prior state manually after assertions.

## Mechanics

1. Define the snapshot as a plain, serializable typed value — no special class needed; keep it `JSON.stringify`-safe when persistence, DevTools replay, or cross-tab sync is needed.
2. Give the originator `getSnapshot()` and `restore(snapshot)` methods so it never exposes internal structure.
3. Store snapshots externally (a `History` class, Zustand slice, Redux state) — the originator focuses only on current state.
4. For deep graphs, use structural sharing (`{ ...prev, field: newValue }`) rather than deep cloning every snapshot.
5. Snapshot on meaningful transitions (save point, step boundary, commit), not on every keystroke — debounce or batch if needed. [Change Reference To Value](change-reference-to-value.md) is often a prerequisite: value semantics make snapshots trivial to take and compare.

## Example

In TypeScript the memento is a plain, serializable typed value — no special class needed:

```ts
type EditorSnapshot = Readonly<{ content: string; cursor: number; selection: [number, number] | null }>;

class Editor {
  #state: EditorSnapshot = { content: "", cursor: 0, selection: null };

  getSnapshot(): EditorSnapshot { return this.#state; }
  restore(snapshot: EditorSnapshot): void { this.#state = snapshot; }

  insert(text: string): void {
    this.#state = {
      ...this.#state,
      content: this.#state.content + text,
      cursor: this.#state.cursor + text.length,
    };
  }
}

class History {
  readonly #stack: EditorSnapshot[] = [];

  push(snapshot: EditorSnapshot): void { this.#stack.push(snapshot); }
  undo(): EditorSnapshot | undefined { return this.#stack.pop(); }
  get canUndo(): boolean { return this.#stack.length > 0; }
}
```

## Related

- [Change Reference To Value](change-reference-to-value.md)
- [Replace Boolean Flags with State Union](replace-boolean-flags-with-state-union.md)
- [Split Variable](split-variable.md)
