# CONTEXT.md Format

## Structure

A `CONTEXT.md` is a glossary for the context that owns its directory:

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Ubiquitous Language

**Order**: A confirmed intent from a customer to receive goods or services.

**Invoice**: A request for payment sent to a customer after delivery.

**Customer**: A person or organization that places orders.
```

## Placement

`CONTEXT.md` lives at the directory level that owns the context — usually next to the `AGENTS.md` for that directory. In a monorepo, a package or bounded-context dir gets its own `CONTEXT.md`; there is no central map file. Before creating one, if it's unclear which directory it belongs in, ask the user (e.g. repo root, a package dir, a bounded-context dir). Add lazily — only when the first term is resolved.

When you create a `CONTEXT.md`, make sure the sibling `AGENTS.md` links to it so anyone reading `AGENTS.md` is pointed at the glossary. Add a line like:

```md
See [CONTEXT.md](./CONTEXT.md) for the ubiquitous language of this area.
```

## Rules

- **Be opinionated.** Pick one canonical term per concept. If you choose `Customer` over `Client`, use `Customer` everywhere — in code, tests, docs.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong. Before adding a term, ask: is this concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.
