# Decompose Conditional

A complex conditional buries the reasoning behind its branches; extract the condition and each branch into named functions so the code states the question and the answers.

## Use When

- A conditional test is hard to read at a glance.
- The then/else branches contain non-trivial logic worth naming.
- The same complex condition appears in more than one place.
- The intent of a branch is clearer as a named calculation than as inline code.

## Trigger

- A boolean expression combines several operators and needs mental parsing.
- Branch bodies span multiple lines of calculation.
- You add a comment to explain what a condition checks.
- Readers must decode operators to understand the policy being applied.

## Mechanics

1. Extract the condition into a function named for the question it asks, not the operators it uses.
2. Extract each branch body into a function named for the outcome or policy it represents.
3. Replace the conditional with calls to the named functions.
4. Leave tiny, obvious conditionals alone if extraction only adds noise.
5. Run tests to confirm behavior is unchanged.

## Example

Extract conditional parts into named queries/calculations.

Before:

```ts
if (!aDate.isBefore(plan.summerStart) && !aDate.isAfter(plan.summerEnd))
  charge = quantity * plan.summerRate;
else
  charge = quantity * plan.regularRate + plan.regularServiceCharge;
```

After:

```ts
charge = summer() ? summerCharge() : regularCharge();
function summer() {return !aDate.isBefore(plan.summerStart) && !aDate.isAfter(plan.summerEnd);}
function summerCharge() {return quantity * plan.summerRate;}
function regularCharge() {return quantity * plan.regularRate + plan.regularServiceCharge;}
```

## Related

- [Extract Function](extract-function.md)
- [Replace Nested Conditional with Guard Clauses](replace-nested-conditional-with-guard-clauses.md)
- [Replace Conditional with Strategy](replace-conditional-with-strategy.md)
