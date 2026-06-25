# Ubiquitous Language Section Format

## Structure

Add (or update) a `## Ubiquitous Language` section in `AGENTS.md`:

```md
## Ubiquitous Language

**Order**: A confirmed intent from a customer to receive goods or services.

**Invoice**: A request for payment sent to a customer after delivery.

**Customer**: A person or organization that places orders.
```

## Rules

- **Be opinionated.** Pick one canonical term per concept. If you choose `Customer` over `Client`, use `Customer` everywhere — in code, tests, docs.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong. Before adding a term, ask: is this concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.

One `## Ubiquitous Language` section in `AGENTS.md` at the appropriate directory level. Before creating it, ask the user which directory it should live in (e.g. repo root, a package dir, a bounded context dir). Add lazily — only when the first term is resolved.
