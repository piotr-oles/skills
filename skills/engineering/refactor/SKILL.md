---
name: refactor
description: Use when reviewing or changing code to spot refactoring opportunities, map code smells to Fowler refactoring patterns, and choose a small safe refactoring before feature work or cleanup.
---

# Refactoring

## How to Choose

- Start from the concrete trigger in the code, not from a preferred pattern name.
- Prefer local, behavior-preserving changes before wider design moves.
- Prefer composition over inheritance for behavior reuse, runtime variation, optional capabilities, and independent change axes; reserve inheritance for stable, honest subtype relationships.
- Prefer discriminated unions, Rust enums, or enum-like ADTs for finite variants, lifecycle phases, expected absence/failure, and records with many optional fields.
- Use unions for closed sets of data shapes; use strategies, ports, or composition when behavior must stay open-ended or runtime-pluggable.
- If several patterns fit, use the one that enables the next safe step: name things, isolate data, move behavior, simplify branching, then reshape APIs or inheritance.

## Safety Workflow

- Characterize current behavior first: read tests, add missing characterization tests, or capture observable inputs/outputs before changing structure.
- Make one behavior-preserving refactoring at a time, run focused tests after each meaningful step, and stop if behavior changes unexpectedly.
- Keep compatibility wrappers, adapters, or old names temporarily when changing public APIs; remove them after callers move.
- Do not mix refactoring with feature changes unless the refactoring is the smallest step needed to make the feature safe.

## Smell Index

- Long function: [Extract Function](#extract-function), [Split Phase](#split-phase).
- Duplicate code: [Extract Function](#extract-function), [Substitute Algorithm](#substitute-algorithm), [Combine Functions into Class](#combine-functions-into-class).
- Comments explaining code: [Extract Function](#extract-function), [Change Function Declaration](#change-function-declaration).
- Long parameter list or data clump: [Introduce Parameter Object](#introduce-parameter-object), [Extract Class](#extract-class), [Builder](#builder).
- Primitive obsession: [Replace Primitive with Object](#replace-primitive-with-object), [Replace Conditional with Strategy](#replace-conditional-with-strategy).
- Too many optional fields: [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union), [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union).
- Boolean state matrix: [Replace Boolean Flags with State Union](#replace-boolean-flags-with-state-union), [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union).
- Enum/type code with payload fields: [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union), [Add Exhaustive Match](#add-exhaustive-match).
- Nullable or sentinel return: [Introduce Special Case](#introduce-special-case), or define a domain-specific variant union when absence/failure is part of the state model.
- Feature envy: [Move Function](#move-function), [Move Field](#move-field), [Extract Role Interface](#extract-role-interface).
- Divergent change or large class: [Extract Class](#extract-class), [Combine Functions into Class](#combine-functions-into-class), [Extract Composed Capability](#extract-composed-capability).
- Shotgun surgery: [Move Function](#move-function), [Move Field](#move-field), [Introduce Port Adapter](#introduce-port-adapter).
- Switch statements or type codes: [Replace Conditional with Strategy](#replace-conditional-with-strategy), [Decompose Conditional](#decompose-conditional).
- Non-exhaustive union handling: [Add Exhaustive Match](#add-exhaustive-match), [Decompose Conditional](#decompose-conditional).
- Flag arguments: [Remove Flag Argument](#remove-flag-argument), [Replace Conditional with Strategy](#replace-conditional-with-strategy).
- Middle man or message chains: [Move Function](#move-function).
- Global state or singleton access: [Replace Singleton with Injected Dependency](#replace-singleton-with-injected-dependency), [Introduce Port Adapter](#introduce-port-adapter).
- Broad interface or bulky mock: [Extract Role Interface](#extract-role-interface), [Split Interface with Composition](#split-interface-with-composition).
- Inheritance used for reuse: [Replace Inheritance with Composition](#replace-inheritance-with-composition).
- Data-only subclasses: [Replace Subclasses with Union Variants](#replace-subclasses-with-union-variants), [Replace Inheritance with Composition](#replace-inheritance-with-composition).
- Subclass explosion or optional behavior: [Extract Composed Capability](#extract-composed-capability), [Replace Conditional with Strategy](#replace-conditional-with-strategy).
- Complex subsystem leaking to callers, repeated orchestration sequence: [Facade](#facade).
- Cross-cutting concerns mixed into core logic (logging, caching, retry, auth): [Decorator](#decorator).
- Direct coupling on state change, many callers to notify: [Observer](#observer).
- Sequential request handling or nested dispatch logic: [Chain of Responsibility](#chain-of-responsibility).
- Need to save and restore state for undo, rollback, or back navigation: [Memento](#memento).
- Building arrays just to iterate, callback-based sequences, paginated data: [Iterator and Async Iterator](#iterator-and-async-iterator).

## Opposite Pairs

- [Change Reference To Value](#change-reference-to-value) vs [Change Value To Reference](#change-value-to-reference): depends on whether identity and shared updates matter more than immutable value simplicity.
- [Replace Conditional with Strategy](#replace-conditional-with-strategy) vs [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union): depends on whether the variation is open behavior or a closed set of data shapes.

## Core Building Blocks

- [Extract Function](#extract-function)
- [Inline Function](#inline-function)
- [Change Function Declaration](#change-function-declaration)
- [Introduce Parameter Object](#introduce-parameter-object)
- [Combine Functions Into Class](#combine-functions-into-class)
- [Split Phase](#split-phase)
## Encapsulation

- [Encapsulate Record](#encapsulate-record)
- [Replace Primitive With Object](#replace-primitive-with-object)
- [Extract Class](#extract-class)
- [Substitute Algorithm](#substitute-algorithm)
## Moving Features

- [Move Function](#move-function)
- [Move Field](#move-field)
- [Split Loop](#split-loop)
## Organizing Data

- [Split Variable](#split-variable)
- [Replace Derived Variable With Query](#replace-derived-variable-with-query)
- [Change Reference To Value](#change-reference-to-value)
- [Change Value To Reference](#change-value-to-reference)
## Unions and Enums

Prefer these when a finite set of valid shapes is currently represented by optional fields, booleans, type codes, nullable values, or data-only subclasses.

- [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union)
- [Replace Boolean Flags with State Union](#replace-boolean-flags-with-state-union)
- [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union)
- [Replace Subclasses with Union Variants](#replace-subclasses-with-union-variants)
- [Add Exhaustive Match](#add-exhaustive-match)
## Simplifying Conditional Logic

- [Decompose Conditional](#decompose-conditional)
- [Replace Nested Conditional With Guard Clauses](#replace-nested-conditional-with-guard-clauses)
- [Introduce Special Case](#introduce-special-case)
## Refactoring APIs

- [Remove Flag Argument](#remove-flag-argument)
- [Replace Parameter With Query](#replace-parameter-with-query)
- [Replace Constructor With Factory Function](#replace-constructor-with-factory-function)
## Composition-Oriented Refactorings

- [Replace Inheritance with Composition](#replace-inheritance-with-composition)
- [Split Interface with Composition](#split-interface-with-composition)
- [Extract Role Interface](#extract-role-interface)
- [Introduce Port Adapter](#introduce-port-adapter)
- [Replace Singleton with Injected Dependency](#replace-singleton-with-injected-dependency)
- [Replace Conditional with Strategy](#replace-conditional-with-strategy)
- [Extract Composed Capability](#extract-composed-capability)

## Design Patterns

Introduce these patterns when structural problems recur. Each addresses a specific coupling or construction smell and has a TypeScript-idiomatic form.

- [Builder](#builder)
- [Facade](#facade)
- [Decorator](#decorator)
- [Observer](#observer)
- [Chain of Responsibility](#chain-of-responsibility)
- [Memento](#memento)
- [Iterator and Async Iterator](#iterator-and-async-iterator)

# Extract Composed Capability

Optional behavior should not force every object in a hierarchy or interface to carry methods it cannot honestly support. Extract the capability into a small component and compose it only into objects that have that capability.

## Use When

- Some objects support an operation and others only pretend to.
- A class has optional feature branches, nullable collaborators, or capability flags.
- The same optional behavior is spreading across unrelated types.
- You need to add a capability without widening a base class or central interface.

## Trigger

- Methods named `canX`, `supportsX`, `isXEnabled`, or `hasX` guard most calls.
- Base classes include hooks that only a few subclasses override.
- Interfaces grow optional methods because one implementer needs them.
- Feature flags decide whether an object has behavior that could be a component.

## Mechanics

1. Name the capability from the operation clients want, not from the current class.
2. Extract the capability interface and move related behavior into an implementation with [Extract Class](#extract-class).
3. Add the capability as a collaborator where supported.
4. Update clients to ask for or receive the capability directly instead of probing the host object.
5. Remove capability flags and optional base methods when no longer needed.

## Example

Before:

```ts
class Account {
  canExportCsv() { return this.plan === "pro"; }
  exportCsv() { /* pro-only export */ }
}
```

After:

```ts
class CsvExportCapability {
  export(account: Account) { /* export */ }
}

class Account {
  constructor(readonly csvExport?: CsvExportCapability) {}
}
```

## Related

- [Extract Class](#extract-class)
- [Remove Flag Argument](#remove-flag-argument)
- Replace Conditional with Polymorphism

---

# Extract Role Interface

Consumers should depend on the role they need, not on a concrete class or broad service. Extract a small consumer-owned interface so the dependency expresses one collaboration and can be composed, tested, or replaced independently.

## Use When

- A function accepts a concrete class but uses only a few methods.
- Tests need large real objects or mocks for a small interaction.
- Several consumers each use different slices of the same dependency.
- You want a stable boundary before moving implementation or introducing an adapter.

## Trigger

- Parameter types are concrete services, repositories, SDK clients, or framework classes.
- Call sites pass a large object when the callee needs one capability.
- Mock setup includes methods the test does not care about.
- A dependency change ripples into consumers that do not use the changed behavior.

## Mechanics

1. Look at one consumer and list only the methods it calls.
2. Create a role interface named from that consumer's need.
3. Change the consumer's parameter type to the role with [Change Function Declaration](#change-function-declaration).
4. Let the current concrete class implement the role without changing behavior.
5. Repeat for other consumers only when their role is actually different.

## Example

Before:

```ts
function renderInvoice(accountService: AccountService, accountId: string) {
  const account = accountService.find(accountId);
  return account.billingName;
}
```

After:

```ts
interface AccountReader {
  find(accountId: string): Account;
}

function renderInvoice(accounts: AccountReader, accountId: string) {
  const account = accounts.find(accountId);
  return account.billingName;
}
```

## Related

- [Split Interface with Composition](#split-interface-with-composition)
- [Introduce Port Adapter](#introduce-port-adapter)
- [Preserve Whole Object](#preserve-whole-object)

---

# Introduce Port Adapter

Concrete infrastructure and third-party APIs should not leak through core code. Introduce a small port owned by the caller and an adapter that translates between the port and the external API.

## Use When

- Business logic imports SDK clients, database handles, HTTP libraries, message brokers, or framework objects directly.
- Tests need real infrastructure or large mocks for simple behavior.
- A third-party API shape is spreading through many modules.
- You need to swap implementations without changing core behavior.

## Trigger

- Functions accept concrete clients instead of the operation they need.
- Domain code catches vendor-specific exceptions or builds vendor-specific request objects.
- The same SDK setup and response mapping appears in multiple places.
- A test failure requires network, credentials, clock, filesystem, or process state.

## Mechanics

1. Define a narrow port interface from the consumer's language.
2. Change the consumer to depend on the port with [Change Function Declaration](#change-function-declaration).
3. Move vendor-specific calls into an adapter that implements the port.
4. Translate vendor request/response/error shapes at the adapter boundary.
5. Replace direct SDK usage in core code, then delete duplicated setup and mapping code.

## Example

Before:

```ts
async function invoiceCustomer(stripe: Stripe, customerId: string, amount: number) {
  await stripe.charges.create({ customer: customerId, amount });
}
```

After:

```ts
interface PaymentPort {
  charge(customerId: string, amount: number): Promise<void>;
}

async function invoiceCustomer(payments: PaymentPort, customerId: string, amount: number) {
  await payments.charge(customerId, amount);
}
```

## Related

- [Extract Role Interface](#extract-role-interface)
- [Replace Query with Parameter](#replace-query-with-parameter)
- [Extract Class](#extract-class)

---

# Replace Conditional with Strategy

Conditionals that choose among interchangeable behaviors often want composition before inheritance. Move each behavior behind a strategy interface so callers can select, inject, or test the variation without growing a class hierarchy.

## Use When

- A conditional chooses an algorithm, policy, formatter, validator, or pricing rule.
- The cases are independent behaviors with the same input/output shape.
- Behavior should be selected at runtime or configured externally.
- Subclasses would exist only to represent one decision.

## Trigger

- Repeated `switch` or `if` branches on mode, type, region, plan, channel, or provider.
- New cases require editing a central function.
- Tests need to exercise each branch as a separate behavior.
- A planned inheritance hierarchy would vary by one replaceable policy.
- If cases are a closed set of data shapes, prefer [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union).

## Mechanics

1. Name the strategy role from the behavior clients need.
2. Extract the conditional body for each case into a function with [Extract Function](#extract-function).
3. Create a strategy interface and one implementation per case.
4. Change the host to receive or look up the strategy, then delegate through it.
5. Remove the old conditional when all callers select strategies directly.

## Example

Before:

```ts
function shippingCost(order: Order, method: string) {
  if (method === "express") return order.weight * 12;
  if (method === "pickup") return 0;
  return order.weight * 5;
}
```

After:

```ts
interface ShippingStrategy {
  cost(order: Order): number;
}

class ExpressShipping implements ShippingStrategy {
  cost(order: Order) { return order.weight * 12; }
}
```

## Related

- Replace Conditional with Polymorphism
- [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union)
- [Remove Flag Argument](#remove-flag-argument)

---

# Replace Inheritance with Composition

Inheritance is the wrong tool when a subclass mainly borrows implementation, overrides behavior to block inherited features, or needs to combine multiple variation axes. Replace inheritance with an owned collaborator so the object keeps the behavior it needs without exposing or depending on the whole superclass API.

## Use When

- The subclass is not truly substitutable for the superclass.
- The subclass overrides methods only to disable, narrow, or redirect inherited behavior.
- New behavior needs runtime selection, multiple independent variants, or testing with small fakes.
- Superclass changes frequently break subclasses that only wanted part of its implementation.

## Trigger

- "Is-a" relationship feels forced, but "has-a" reads naturally.
- Subclass has many unused inherited methods or protected-field access.
- Adding one new variant requires a new subclass even though only one behavior changes.
- Tests must instantiate a subclass mostly to reuse helper behavior from the parent.

## Mechanics

1. Create a collaborator that exposes only the behavior the subclass actually needs.
2. Move superclass-used behavior into the collaborator with [Move Function](#move-function) and [Move Field](#move-field).
3. Add the collaborator as a field and delegate through focused methods.
4. Update callers to depend on the concrete object's public API, not the old inherited API.
5. Remove inheritance once no caller needs the superclass relationship.

## Example

Before:

```ts
class CsvReport extends FileReport {
  render() {
    return this.rows.map(row => row.join(",")).join("\n");
  }
}
```

After:

```ts
class CsvReport {
  constructor(private readonly file: ReportFile) {}

  render() {
    return this.file.rows.map(row => row.join(",")).join("\n");
  }
}
```

## Related

- [Move Function](#move-function)

---

# Replace Singleton with Injected Dependency

Singletons and global service locators hide dependencies and make tests share state. Pass the dependency explicitly so each caller can compose the implementation it needs.

## Use When

- Code reaches into a singleton, global registry, static service, or process-wide context.
- Tests must reset global state or run in a special order.
- Behavior depends on time, configuration, I/O, randomness, environment variables, or current user state.
- You need different implementations for tests, tenants, regions, or runtime modes.

## Trigger

- Calls like `Logger.instance()`, `Config.current`, `ServiceLocator.get`, or module-level clients inside business logic.
- Hidden dependencies make a function hard to call in isolation.
- A change to global configuration affects unrelated tests.
- Constructors do little work because objects fetch collaborators later from globals.

## Mechanics

1. Identify the smallest interface the caller actually needs.
2. Add the dependency as a parameter or constructor field with [Change Function Declaration](#change-function-declaration).
3. Keep the singleton lookup only at composition roots, factories, or application startup.
4. Update tests to pass fakes or in-memory implementations.
5. Delete global access from core code once call sites inject dependencies.

## Example

Before:

```ts
function auditLogin(userId: string) {
  Logger.instance().info(`login ${userId}`);
}
```

After:

```ts
interface Logger {
  info(message: string): void;
}

function auditLogin(logger: Logger, userId: string) {
  logger.info(`login ${userId}`);
}
```

## Related

- [Replace Query with Parameter](#replace-query-with-parameter)
- [Introduce Port Adapter](#introduce-port-adapter)
- [Extract Role Interface](#extract-role-interface)

---

# Split Interface with Composition

A large interface forces implementers and consumers to depend on methods they do not use. Split it into small role interfaces, then compose objects from the roles each workflow actually needs.

## Use When

- Implementers have empty, throwing, or fake implementations for interface methods.
- Consumers use only one coherent slice of a broad API.
- One interface changes for several unrelated reasons.
- Tests require bulky stubs even when the code under test needs only one operation.

## Trigger

- Interface names end with generic words like `Manager`, `Service`, `Handler`, or `Client`.
- Implementations contain `UnsupportedOperation`, `NotImplemented`, or no-op methods.
- Call sites accept a large interface but touch only one or two methods.
- A new feature adds methods for one consumer and forces many unrelated implementers to change.

## Mechanics

1. Group interface methods by consumer role and change reason.
2. Extract one small interface per role, using names from the consumer's language.
3. Update consumers to depend on the smallest role interface they need with [Change Function Declaration](#change-function-declaration).
4. Let existing concrete objects implement multiple small interfaces during migration.
5. Compose broader services from smaller roles instead of growing one central interface.

## Example

Before:

```ts
interface UserService {
  findUser(id: string): User;
  saveUser(user: User): void;
  sendPasswordReset(id: string): void;
}
```

After:

```ts
interface UserReader {
  findUser(id: string): User;
}

interface PasswordResetSender {
  sendPasswordReset(id: string): void;
}
```

## Related

- [Extract Class](#extract-class)
- [Change Function Declaration](#change-function-declaration)
- [Preserve Whole Object](#preserve-whole-object)

---

# CHANGE FUNCTION DECLARATION
Change Function Declaration changes function name, parameters, or full signature. Use when current declaration misstates intent, limits reuse, or creates needless coupling.

## Use When

- Function name no longer says what callers need to know.
- Parameter list gives wrong context or couples caller to wrong object.
- Parameter should become one of its properties, or property should become whole object.
- Published API needs staged migration.

## Simple Mechanics

- If removing parameter, ensure body no longer references it.
- Change declaration.
- Update all references.
- Prefer separate steps for rename, add parameter, remove parameter, or larger signature change.

## Notes

- Use simple mechanics when declaration and callers can change together safely.
- Use migration when callers are many, hard to reach, polymorphic, or change is complex.
- For polymorphic methods, add forwarding method per binding; superclass forwarding is enough inside one hierarchy.
- For published APIs, keep old function as deprecated forwarder until clients migrate.

## Example

Rename unclear function declaration.

Before:

```ts
function circum(radius) {
  return 2 * Math.PI * radius;
}
```

After:

```ts
function circumference(radius) {
  return 2 * Math.PI * radius;
}
```

---

# COMBINE FUNCTIONS INTO CLASS
Move related functions and shared data into one class when they operate as one concept. Class makes common environment explicit, removes repeated arguments, and keeps derived values consistent when data can mutate.

## Use When

- Several functions take same record or parameter group.
- Calculations duplicate around same data.
- Clients need more than one related operation exposed.
- Source data may change after creation and derived values must stay current.
- Nested functions would hide behavior from tests or collaborators.

## Notes

- Alternative: Combine Functions into Transform.
- Prefer class over transform when core data can mutate; methods recalculate from current state.
- Transform fits immutable/read-only pipelines better.
- Uniform Access Principle: client need not know whether `baseCharge` is stored field or derived getter.
- TypeScript alternative: a plain module exporting functions over a `readonly` data type is idiomatic and testable without a class; use a class when private mutable state or encapsulated invariants are needed.

## Example

Move reading calculations into class.

Before:

```ts
const reading = acquireReading();
const baseCharge = baseRate(reading.month, reading.year) * reading.quantity;
const taxableCharge = Math.max(0, baseCharge - taxThreshold(reading.year));
```

After:

```ts
const rawReading = acquireReading();
const aReading = new Reading(rawReading);
const baseCharge = aReading.baseCharge;
const taxableCharge = aReading.taxableCharge;
```

---

# EXTRACT FUNCTION
Extract Function moves coherent code fragment into named function. Use when name reveals intent better than inline implementation.

## Use When

- Reader must inspect fragment to learn what it does.
- Comment explains intent; turn comment into function name.
- Same or similar code appears elsewhere; pair later with Replace Inline Code with Function Call.
- Short function still useful when name carries intent.

## Notes

- Inverse: [Inline Function](#inline-function).
- If no better name exists, do not extract.
- Nested functions reduce scope problems, but sibling/top-level extraction exposes variable pain earlier.

## Example

Extract banner printing into named function.

Before:

```ts
console.log("***********************");
console.log("**** Customer Owes ****");
console.log("***********************");
```

After:

```ts
printBanner();

function printBanner() {
  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");
}
```

---

# INLINE FUNCTION
Inline Function replaces function call with function body. Use when body communicates as well as name, or indirection hides useful structure.

## Use When

- Function name adds no meaning beyond implementation.
- Delegation chain creates noise.
- Badly factored functions need flattening before better extraction.
- Small body can fit caller with little adjustment.

## Notes

- Inverse: [Extract Function](#extract-function).
- Inlining can proceed one caller or one statement at time.
- For awkward bodies, use Move Statements to Callers first.
- Recursion, multiple returns, inaccessible object state, or heavy fitting usually mean choose different refactoring.

## Example

Inline helper whose body says same thing as name.

Before:

```ts
function rating(aDriver) {
  return moreThanFiveLateDeliveries(aDriver) ? 2 : 1;
}
function moreThanFiveLateDeliveries(aDriver) {
  return aDriver.numberOfLateDeliveries > 5;
}
```

After:

```ts
function rating(aDriver) {
  return aDriver.numberOfLateDeliveries > 5 ? 2 : 1;
}
```

---

# INTRODUCE PARAMETER OBJECT
Replace repeated parameter clumps with one object that names relationship between values. This shrinks signatures now and creates place for behavior later.

## Use When

- Same values travel together through many functions.
- Parameter lists repeat min/max, start/end, date range, options, or other data clumps.
- Callers already pull values as pair/group from another object.
- You want common behavior over that group to become explicit.

## Notes

- After object exists, move common behavior into it, such as `contains` on range object.
- Watch for nearby equivalent clumps with different names, such as `temperatureFloor`/`temperatureCeiling` versus `min`/`max`.
- Add value-based equality when object should behave as true value object.

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

---

# SPLIT PHASE
Split Phase separates mixed logic into sequential stages with explicit handoff data. Use when stages use different data, functions, or change reasons.

## Use When
- One fragment handles two topics in sequence.
- Input shape differs from model needed by main logic.
- Later changes likely hit one stage, not whole algorithm.
- Compiler-style pipeline fits: tokenize, parse, transform, generate.

## Notes
- Best clue: stages use different data/functions.
- Handoff structure names phase boundary; keep it small and meaningful.
- Leave params that truly belong only to second phase, such as external strategy/config input.

## Example

Split order pricing into pricing data phase and shipping phase.

Before:

```ts
function priceOrder(product, quantity, shippingMethod) {
  const basePrice = product.basePrice * quantity;
  const discount = Math.max(quantity - product.discountThreshold, 0) * product.basePrice * product.discountRate;
  const shippingPerCase = basePrice > shippingMethod.discountThreshold ? shippingMethod.discountedFee : shippingMethod.feePerCase;
  return basePrice - discount + quantity * shippingPerCase;
}
```

After:

```ts
function priceOrder(product, quantity, shippingMethod) {
  const priceData = calculatePricingData(product, quantity);
  return applyShipping(priceData, shippingMethod);
}
```

---

# ENCAPSULATE RECORD
Encapsulate Record controls access to a record whose shape, field names, or mutation should not leak freely. In TypeScript, prefer a typed interface with `readonly` fields for immutable data; use a class with private fields when you need validation, change notification, or mutation control.

## Use When
- Raw object shape spreads across modules and callers depend on field names directly.
- Field names need rename, validation, or derived values.
- Mutable record references leak across module boundaries.
- JSON/API-style nested data receives direct reads and writes in multiple places.

## Example

For **immutable data** — define a typed interface or type alias; callers read fields directly:

```ts
interface Organization {
  readonly name: string;
  readonly country: string;
}

const org: Organization = { name: "Acme Gooseberries", country: "GB" };
```

For **mutable data with controlled access** — use a class with private fields and accessors:

```ts
class Organization {
  #name: string;
  #country: string;

  constructor(data: { name: string; country: string }) {
    this.#name = data.name;
    this.#country = data.country;
  }

  get name() { return this.#name; }
  set name(value: string) { this.#name = value; }
  get country() { return this.#country; }
}
```

For **nested structures**, define nested interfaces and migrate update paths first before adding validation.

## Notes
- Immutable records gain most from typed interfaces; `as const satisfies T` locks shape at call site.
- Copy on construction or use `Readonly<T>` / `structuredClone` to avoid aliasing bugs with mutable data.
- Avoid wrapping every plain DTO in a class; reserve classes for records that need invariants, validation, or lifecycle behavior.

---

# EXTRACT CLASS
Extract Class splits bloated class by moving cohesive data and behavior into new class. Use when responsibilities, change rhythms, or subtype axes show one class hiding multiple concepts.

## Use When

- Fields and methods form separate cluster.
- Data changes together or depends tightly on other data.
- Removing one field/function would make small method group nonsense.
- Subclasses affect only part of class, or different features need different subtype axes.

## Notes

- Inverse: Inline Class.
- Inline Class folds weak source class into target when source no longer carries enough responsibility.
- Inline Class mechanics: add target delegators for source public functions, redirect clients, move data/functions, test each move, delete empty source.
- Reorganization tactic: Inline Class can collapse two awkward classes first, then Extract Class can split better boundary.

## Example

Move telephone data out of Person.

Before:

```ts
class Person {
  #officeAreaCode!: string;
  #officeNumber!: string;
  get officeAreaCode() {return this.#officeAreaCode;}
  get officeNumber() {return this.#officeNumber;}
  get telephoneNumber() {return `(${this.officeAreaCode}) ${this.officeNumber}`;}
}
```

After:

```ts
class Person {
  #telephoneNumber!: TelephoneNumber;
  get officeAreaCode() {return this.#telephoneNumber.areaCode;}
  get officeNumber() {return this.#telephoneNumber.number;}
  get telephoneNumber() {return this.#telephoneNumber.toString();}
}
```

---

# REPLACE PRIMITIVE WITH OBJECT
Replace Primitive with Object wraps simple value in class that can hold behavior. Formerly Replace Data Value with Object and Replace Type Code with Class; use when string/number logic spreads across code.

## Use When
- Primitive now needs formatting, parsing, validation, comparison, or domain rules.
- Same checks or conversions duplicate around codebase.
- Type code wants named behavior but full hierarchy unnecessary.
- Future behavior belongs with value, not callers.

## Notes
- Keep wrapper humble first; move behavior in after tests protect callers.
- If a type code has case-specific payload fields, prefer [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union).
- Constructor can accept existing `Priority` to ease migration.
- For value object role, make immutable and implement equality.
- Good follow-on methods: validation, `equals`, `higherThan`, `lowerThan`.
- TypeScript alternative: branded types (`type UserId = string & { readonly _brand: "UserId" }`) provide nominal type safety without a class wrapper; prefer them for pure identity/nominal typing. Use a class when the value needs methods such as `equals()`, `format()`, `higherThan()`, or domain validation.

## Example

Wrap priority string in value object.

Before:

```ts
orders.filter(o => o.priority === "high" || o.priority === "rush");
```

After:

```ts
orders.filter(o => o.priority.higherThan(new Priority("normal")));
```

---

# SUBSTITUTE ALGORITHM
Substitute Algorithm replaces hard-to-follow logic with clearer equivalent algorithm. Use after behavior is understood and candidate replacement can be checked against old output.

## Use When

- Simpler algorithm found.
- Library now covers custom code.
- Planned behavior change becomes easier after replacing algorithm.
- Existing function can be isolated and tested.

## Notes

- Decompose large algorithm first; whole-function replacement is hard while code remains tangled.
- Strong tests matter more here than small-step mechanics.

## Example

Replace search loop with direct algorithm.

Before:

```ts
function foundPerson(people) {
  for (const p of people) {
    if (p === "Don") return "Don";
    if (p === "John") return "John";
    if (p === "Kent") return "Kent";
  }
  return "";
}
```

After:

```ts
function foundPerson(people) {
  const candidates = ["Don", "John", "Kent"];
  return people.find(p => candidates.includes(p)) || "";
}
```

---

# MOVE FIELD
Move Field relocates data from source record or class to better target record or class without changing observable behavior. Use it when current data home forces repeated passing, duplicate updates, or hides domain relationship.

## Use When
- Field travels with another record whenever passed to functions.
- Change in one structure forces related field change in another structure.
- Same fact gets stored or updated in multiple places.
- Broader refactoring shows users should read data from target object instead of source.

## Notes
- Bare records need accessor functions and careful migration; prefer [Encapsulate Record](#encapsulate-record) first when possible.
- Immutable moved field can support duplicate writes while reads migrate.
- Shared target changes semantics unless all source objects already agree on value; verify with data checks, logging, or [Introduce Assertion](#introduce-assertion).
- If constructor or statement order blocks target access, use Slide Statements.
- Move often happens inside larger change; move field first, then migrate clients to target object.

## Example

Move discount rate from Customer to contract.

Before:

```ts
class Customer {
  #discountRate: number;
  #contract: CustomerContract;
  constructor(name: string, discountRate: number) {
    this.#discountRate = discountRate;
    this.#contract = new CustomerContract(dateToday());
  }
}
```

After:

```ts
class Customer {
  #contract: CustomerContract;
  constructor(name: string, discountRate: number) {
    this.#contract = new CustomerContract(dateToday(), discountRate);
  }
  get discountRate() {return this.#contract.discountRate;}
}
```

---

# MOVE FUNCTION
Move Function puts function in context where its data, callees, callers, and future use belong. Use when current module/class/function no longer gives clearest ownership or access.

## Use When

- Function references other context more than current one.
- Callers live near target context, or next feature needs target access.
- Nested helper has independent value.
- Method fits another class/module better.
- Moving cluster may reveal need for [Combine Functions into Class](#combine-functions-into-class) or [Extract Class](#extract-class).

## Notes

- Source delegator can stay for compatibility. Remove it when callers can reach target directly.
- Moving nested functions: pass captured data as parameters or move dependent helpers too.
- In JavaScript, prefer modules for visibility; nested functions can hide data dependencies.
- Moving between classes: pass simple values when enough; pass source object when target needs several values or future variation belongs there.

## Example

Move nested distance helpers out of `trackSummary`.

Before:

```ts
function trackSummary(points) {
  const totalDistance = calculateDistance();
  function calculateDistance() { ... }
  function distance(p1, p2) { ... }
}
```

After:

```ts
function trackSummary(points) {
  const totalDistance = totalDistance(points);
}
function totalDistance(points) { ... }
function distance(p1, p2) { ... }
```

---

# REPLACE LOOP WITH PIPELINE
Collection pipeline expresses collection processing as ordered operations such as `map`, `filter`, and `slice`. Replace loop when data flow reads clearer top to bottom than control flow inside loop.

## Use When

- Loop transforms, filters, skips, or accumulates collection data.
- Each loop step maps cleanly to pipeline operation.
- You want to remove control variables and make object flow explicit.

## Notes

- Keep intermediate collection variable when it explains source data.
- Rename lambda variables after behavior is safely moved.
- For more examples, see "Refactoring with Loops and Collection Pipelines".

## Example

Replace loop-based CSV parsing with pipeline.

Before:

```ts
const result = [];
for (const line of input.split("
")) {
  if (line.trim() === "") continue;
  const record = line.split(",");
  if (record[1].trim() === "India") result.push({city: record[0].trim(), phone: record[2].trim()});
}
```

After:

```ts
return input
  .split("
")
  .slice(1)
  .filter(line => line.trim() !== "")
  .map(line => line.split(","))
  .filter(record => record[1].trim() === "India")
  .map(record => ({city: record[0].trim(), phone: record[2].trim()}));
```

---

# SPLIT LOOP
One loop doing multiple jobs forces every change to understand every job. Split loop gives each behavior its own pass, then often enables [Extract Function](#extract-function), [Replace Loop with Pipeline](#replace-loop-with-pipeline), or [Substitute Algorithm](#substitute-algorithm).

## Use When

- Loop calculates or mutates more than one independent result.
- Combined loop exists only to avoid extra traversal.
- You want each calculation to return its own value instead of sharing locals or result structures.

## Notes

- Extra traversal is usually not real bottleneck; refactor for clarity first, optimize after measuring.
- Split loops can expose better optimizations than one dense loop.

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

---

# CHANGE REFERENCE TO VALUE
Replace shared reference object with immutable value object copied or reassigned as whole. Use when identity does not matter and updates should not leak across owners.

## Use When
- Inner object belongs to one owner or can be duplicated safely.
- You want immutable data, simpler reasoning, safer distribution or concurrency.
- Updating one holder should not update other holders.
- Candidate class can become immutable.

## Notes
- Inverse: [Change Value to Reference](#change-value-to-reference).
- Do not use when several objects must share one object and see same mutation.
- Value Object often final shape.

## Example

Replace mutable reference object with immutable value object.

Before:

```ts
aPerson.officeAreaCode = "312";
aPerson.officeNumber = "5550142";
```

After:

```ts
aPerson.telephoneNumber = new TelephoneNumber("312", "5550142");
```

---

# CHANGE VALUE TO REFERENCE
Replace duplicated value objects with one shared reference from repository. Use when copied records represent same entity and mutation must be visible everywhere.

## Use When
- Multiple host records carry copies of same logical entity.
- Entity data can change or be enriched after load.
- Duplicate objects risk inconsistent state.
- One identity per entity is clearer than many equal copies.

## Notes
- Inverse: [Change Reference to Value](#change-reference-to-value).
- Immutable and never-updated data may stay as value.
- Missing ID in preloaded repository should usually be error.
- Global repository couples constructors to global state; pass repository as parameter when that coupling matters.
- In TypeScript, prefer a reactive store, DI container, or event-based update over a global mutable registry; the registry approach hides coupling and complicates testing.

## Example

Use registry reference instead of new value copy.

Before:

```ts
class Order {
  #customer: Customer;
  constructor(data: OrderData) {
    this.#customer = new Customer(data.customer);
  }
}
```

After:

```ts
class Order {
  #customer: Customer;
  constructor(data: OrderData) {
    this.#customer = registerCustomer(data.customer);
  }
}
```

---

# REPLACE DERIVED VARIABLE WITH QUERY
Replace stored derived data with query that calculates same value from source data. Remove duplicated mutable state; source changes then cannot desync cached result.

## Use When
- Variable repeats value already derivable from other fields.
- Accumulator or cache adds update burden without proven performance need.
- Source data changes over time, and derived structure lifetime is hard to manage.

## Notes
- Immutable source data can justify keeping transformed derived data.
- Transient derived data can be fine either as query or transformation.

## Example

Calculate production from adjustments instead of storing derived copy.

Before:

```ts
class ProductionPlan {
  #adjustments: Adjustment[] = [];
  #production = 0;

  applyAdjustment(anAdjustment: Adjustment) {
    this.#adjustments.push(anAdjustment);
    this.#production += anAdjustment.amount;
  }

  get production() {return this.#production;}
}
```

After:

```ts
class ProductionPlan {
  #adjustments: Adjustment[] = [];

  applyAdjustment(anAdjustment: Adjustment) {
    this.#adjustments.push(anAdjustment);
  }

  get production() {
    return this.#adjustments.reduce((sum, a) => sum + a.amount, 0);
  }
}
```

---

# SPLIT VARIABLE
Formerly: Remove Assignments to Parameters; formerly: Split Temp. Variable assigned for multiple responsibilities hides meaning; split into one variable per responsibility.

## Use When

- Variable holds one meaning, then later reused for different meaning.
- Input parameter is overwritten to hold result.
- Temp should be assigned once but receives multiple independent assignments.

## Notes

- Do not split collecting variables such as sums, string concatenation, stream writes, or collection additions.
- Assignment like `i = i + something` usually signals collecting variable, not split candidate.
- For overwritten parameter, keep original parameter as input, create separate result variable, then use Rename Variable for clearer names.

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

---

# PRESERVE WHOLE OBJECT
Caller extracts several values from object then passes pieces. Pass whole object so callee derives needed values and parameter list shrinks.

## Use When

- Same source object supplies several arguments.
- Called function may need more values from same object later.
- Several callers duplicate extraction or manipulation logic.
- [Introduce Parameter Object](#introduce-parameter-object) created new whole object and old data clump still leaks through callers.

## Notes

- Avoid when callee should not depend on whole object, especially across module boundary.
- Repeated use of object parts may signal Feature Envy; moving behavior to whole object may be stronger.
- Same pattern applies when object passes several own fields; pass `this`.
- Same subset used everywhere may point to [Extract Class](#extract-class).

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

---

# REMOVE FLAG ARGUMENT
Literal flag parameter selects branch inside callee. Replace literal calls with explicit functions so call site states intent.

## Use When

- Callers pass literal boolean, enum, string, or symbol to choose behavior.
- Boolean `true`/`false` hides meaning at call site.
- Separate behaviors deserve separate API entries and clearer tooling visibility.

## Notes

- Not flag when value flows as data, such as `isRush = determineIfRush(anOrder)` then `deliveryDate(anOrder, isRush)`.
- Mixed callers: change literal callers; keep original function for data callers.
- Multiple boolean state fields often want [Replace Boolean Flags with State Union](#replace-boolean-flags-with-state-union), not many explicit functions.
- Multiple flags create many explicit combinations; often signal function doing too much.

## Example

Replace boolean delivery flag with explicit functions.

Before:

```ts
aShipment.deliveryDate = deliveryDate(anOrder, true);
```

After:

```ts
aShipment.deliveryDate = rushDeliveryDate(anOrder);

function rushDeliveryDate(anOrder) {return deliveryDate(anOrder, true);}
function regularDeliveryDate(anOrder) {return deliveryDate(anOrder, false);}
```

---

# REPLACE CONSTRUCTOR WITH FACTORY FUNCTION
Replace constructor calls with factory function when constructor rules constrain naming, return type, invocation, or substitution. Factory may call constructor internally, but callers gain normal function interface and room for subclass, proxy, or named variant.

## Use When

- Constructor name hides intent.
- Constructor must return same class, but caller should receive subclass, proxy, cached object, or environment-specific object.
- Call sites need normal function value instead of special syntax such as `new`.
- Literal type codes at call sites need named creation functions.

## Notes

- Factory keeps creation policy outside callers.
- Constructor can stay as implementation detail.

## Example

Replace type-code constructor call with factory.

Before:

```ts
const leadEngineer = new Employee(document.leadEngineer, "E");
```

After:

```ts
const leadEngineer = createEngineer(document.leadEngineer);

function createEngineer(name) {
  return new Employee(name, "E");
}
```

---

# REPLACE PARAMETER WITH QUERY
Parameter duplicates value callee can derive from existing context. Remove parameter and let function query value itself when dependency belongs there.

## Use When

- Callee can determine parameter just as easily as caller.
- Parameter comes from querying another parameter or receiver.
- Recent refactoring left parameter redundant.

## Notes

- Inverse: [Replace Query with Parameter](#replace-query-with-parameter).
- Avoid when query adds unwanted dependency to function body.
- Preserve referential transparency; do not replace parameter with mutable global access.
- Bias: simplify callers only when responsibility fits callee.

## Example

Let receiver query discount level itself.

Before:

```ts
const discountLevel = this.quantity > 100 ? 2 : 1;
return this.discountedPrice(basePrice, discountLevel);
```

After:

```ts
return this.discountedPrice(basePrice);

get discountLevel() {return this.quantity > 100 ? 2 : 1;}
```

---

# REPLACE QUERY WITH PARAMETER
Function reads value from surrounding scope or global dependency. Pass value as parameter to reduce coupling and make function easier to reason about.

## Use When

- Function depends on global, module, or receiver query you want to remove.
- Pure or referentially transparent core should be wrapped by I/O or mutable shell.
- Dependency direction should move from callee to caller.

## Notes

- Inverse: [Replace Parameter with Query](#replace-parameter-with-query).
- Tradeoff: caller must supply value, so call sites can become noisier.
- If the query reaches into singleton or process-wide state, consider [Replace Singleton with Injected Dependency](#replace-singleton-with-injected-dependency).
- Good for immutable or pure modules; repeated same parameter may signal excessive interface burden.
- Decision is responsibility allocation; use inverse when dependency belongs inside callee.

## Example

Pass target temperature source as parameter.

Before:

```ts
class HeatingPlan {
  #max!: number;
  targetTemperature() {
    if (thermostat.selectedTemperature > this.#max) return this.#max;
  }
}
```

After:

```ts
class HeatingPlan {
  #max!: number;
  targetTemperature(selectedTemperature: number) {
    if (selectedTemperature > this.#max) return this.#max;
  }
}
```

---

# DECOMPOSE CONDITIONAL
Split complex conditional into named condition and named branch actions. Names expose why branch exists, not just what code does.

## Use When
- Conditional logic grows long or dense.
- Boolean expression hides business rule.
- Then or else leg hides intent behind calculation details.
- Branch names would make caller read like domain language.

## Notes
- Pattern is special case of [Extract Function](#extract-function).
- Name condition for question being asked, not operators used.
- Name branch functions for outcome or policy.
- Leave tiny obvious conditionals alone if extraction only adds noise.

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

---

# INTRODUCE ASSERTION
Add assertion where code assumes condition must already be true. Use assertion to document programmer invariant, not to validate normal external input.

## Use When

- Algorithm depends on invariant hidden in code or comment.
- Failure means programmer error.
- Assertion clarifies required state at point of execution.
- Setter, constructor, or trusted boundary can catch invalid object state closer to source.

## Notes

- Do not use assertions for expected user, data, or service validation unless source is trusted and failure means bug.

## Example

Assert discount rate invariant where value enters object.

Before:

```ts
applyDiscount(aNumber) {
  return (this.discountRate) ? aNumber - (this.discountRate * aNumber) : aNumber;
}
```

After:

```ts
class Customer {
  #discountRate: number | null = null;

  set discountRate(aNumber: number | null) {
    assert(null === aNumber || aNumber >= 0);
    this.#discountRate = aNumber;
  }
}
```

---

# INTRODUCE SPECIAL CASE
Create special-case object for common response to null, `"unknown"`, or another sentinel value. Move default values and no-op behavior into that object so clients stop repeating checks.

## Use When

- Many clients compare same property or value and mostly do same fallback.
- Null object, `"unknown"` customer, empty record, or missing relationship has standard behavior.
- Client conditionals repeat name, plan, payment, status, or nested default values.
- Read-only data can use literal object; behavior or writes usually need class.

## Notes

- If absence should be part of a finite state model, prefer a domain-specific variant union over a broad optional record.
- Special-case objects should be immutable value objects; setters usually no-op when substitute must accept writes.
- If special case returns related object, return another special case such as `NullPaymentHistory`.
- Keep explicit check only for exceptional clients needing different behavior.
- Literal object works for read-only data; freeze if possible, but class usually clearer.

## Example

Replace repeated unknown-customer checks with special-case customer.

Before:

```ts
const name = aCustomer === "unknown" ? "occupant" : aCustomer.name;
const plan = aCustomer === "unknown" ? registry.billingPlans.basic : aCustomer.billingPlan;
```

After:

```ts
const name = aCustomer.name;
const plan = aCustomer.billingPlan;

class UnknownCustomer {
  get name() {return "occupant";}
  get billingPlan() {return registry.billingPlans.basic;}
}
```

---

# REPLACE NESTED CONDITIONAL WITH GUARD CLAUSES
Use guard clauses for exceptional branches so main path stays flat. Keep `if/else` for equal normal paths; return early when branch means stop.

## Use When

- Nested conditionals hide core behavior.
- One branch handles separated, retired, invalid, error, empty, or other edge case.
- Reversing condition makes normal path read straight.
- Multiple guards return same result; then use Consolidate Conditional Expression.

## Notes

- One exit point not goal; clarity is goal.
- Use normal conditionals when both branches have equal weight.
- Guard clause says: not main case, handle and leave.

## Example

Replace nested special cases with guard clauses.

Before:

```ts
function payAmount(employee) {
  let result;
  if (employee.isSeparated) result = {amount: 0, reasonCode: "SEP"};
  else if (employee.isRetired) result = {amount: 0, reasonCode: "RET"};
  else result = someFinalComputation();
  return result;
}
```

After:

```ts
function payAmount(employee) {
  if (employee.isSeparated) return {amount: 0, reasonCode: "SEP"};
  if (employee.isRetired) return {amount: 0, reasonCode: "RET"};
  return someFinalComputation();
}
```

---

# Add Exhaustive Match

Union types only pay off when consumers handle every variant deliberately. Replace loose conditionals or default fallthrough with exhaustive matching so new variants produce compile-time or test-time failures.

## Use When

- A union or enum exists but consumers rely on `default`, `else`, casts, or partial checks.
- New variants can be added without compiler or test failures.
- Logic for a variant is scattered across several fragile branches.
- You want TypeScript `never` checks or Rust `match` exhaustiveness to protect future changes.

## Trigger

- `switch` statements with `default` that hides missing cases.
- `if (x.kind === "a") ... else ...` where more than two variants exist.
- Type assertions after narrowing.
- Tests missing one or more union cases.

## Mechanics

1. Replace partial conditionals with a `switch` or `match` over the discriminant.
2. Handle each known variant explicitly.
3. In TypeScript, add a `never` assertion in the impossible branch.
4. In Rust, avoid wildcard `_` when each variant should be handled intentionally.
5. Add tests for the behavior of each variant when the logic is important.

## Example

Before:

```ts
function label(state: RequestState) {
  if (state.status === "success") return state.data.name;
  return "Not ready";
}
```

After:

```ts
function label(state: RequestState) {
  switch (state.status) {
    case "idle": return "Idle";
    case "loading": return "Loading";
    case "success": return state.data.name;
    case "error": return state.error.message;
  }
}
```

## Related

- [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union)
- [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union)
- [Decompose Conditional](#decompose-conditional)

---

# Replace Boolean Flags with State Union

Several boolean fields often encode a state machine badly. Replace the flag matrix with a union of named states so invalid flag combinations cannot be represented.

## Use When

- Multiple booleans describe mutually exclusive states.
- The number of possible flag combinations is larger than the number of valid states.
- Conditionals repeatedly combine flags to discover the real state.
- New behavior requires reasoning about every flag combination.

## Trigger

- Fields like `isLoading`, `isLoaded`, `hasError`, `isSaving`, `isDirty` on the same object.
- Guards such as `if (!isLoading && hasData && !hasError)`.
- Bug fixes that add another defensive flag combination check.
- Tests named after impossible or contradictory states.

## Mechanics

1. List the valid states in domain language.
2. Create a union variant for each state, including only data valid in that state.
3. Replace flag-setting code with functions that construct state variants.
4. Update consumers to switch or match on the state tag.
5. Delete flag combinations and defensive impossible-state checks.

## Example

Before:

```ts
type SaveState = {
  isSaving: boolean;
  isSaved: boolean;
  hasError: boolean;
  error?: string;
};
```

After:

```ts
type SaveState =
  | { state: "idle" }
  | { state: "saving" }
  | { state: "saved" }
  | { state: "failed"; error: string };
```

## Related

- [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union)
- [Split Phase](#split-phase)
- [Decompose Conditional](#decompose-conditional)

---

# Replace Enum Plus Payload Fields with Variant Union

An enum or type-code field plus a pile of optional payload fields is a union trying to get out. Move payload fields onto the enum variants that actually own them.

## Use When

- An enum says what kind of value this is, while separate optional fields carry kind-specific data.
- Each enum case has different required data.
- Adding an enum case forces changes to validation, construction, and consumers.
- Rust, TypeScript, or another typed language can encode payload-carrying variants directly.

## Trigger

- Fields named `kind`, `type`, `status`, or `mode` with many sibling optional fields.
- Switch branches each read a different subset of payload fields.
- Constructors accept broad optional data and validate based on enum value.
- Runtime errors say a field is missing for a specific enum case.

## Mechanics

1. Keep the enum only if cases have no payload; otherwise introduce payload-carrying variants.
2. Move each case-specific field into its variant.
3. Replace broad constructors with variant constructors or factory functions.
4. Update consumers to match on the variant and use payload values after narrowing.
5. Remove payload optionality that is no longer needed.

## Example

Before:

```ts
type Payment = {
  method: "card" | "bank";
  cardToken?: string;
  accountId?: string;
};
```

After:

```ts
type Payment =
  | { method: "card"; cardToken: string }
  | { method: "bank"; accountId: string };
```

## Related

- [Replace Optional Fields with Variant Union](#replace-optional-fields-with-variant-union)
- [Replace Primitive with Object](#replace-primitive-with-object)
- [Add Exhaustive Match](#add-exhaustive-match)

---

# Replace Optional Fields with Variant Union

A record with many optional fields often represents several different shapes hidden inside one type. Replace it with a tagged union so each variant carries only the fields that are valid for that case.

## Use When

- Many fields are optional but only certain combinations are valid.
- Code repeatedly checks a `status`, `kind`, or `type` field before reading optional fields.
- AI-generated DTOs use `foo?: T` for every possible state instead of modeling variants.
- Bugs come from impossible states such as `loaded` without `data` or `failed` without `error`.

## Trigger

- Interfaces where most properties are marked `?`.
- Comments saying "present only when status is X".
- Validation code rejects combinations the type system could have made impossible.
- Callers use non-null assertions or casts after checking a discriminant.

## Mechanics

1. Identify the real variants and choose a discriminant such as `kind`, `type`, or `state`.
2. Create one variant type per valid shape, moving required fields into the owning variant.
3. Replace the broad optional record with the union of variants.
4. Update constructors and parsers to produce exactly one variant.
5. Update consumers to narrow on the discriminant, then remove obsolete optional checks.

## Example

Before:

```ts
type RequestState = {
  status: "idle" | "loading" | "success" | "error";
  data?: User;
  error?: Error;
};
```

After:

```ts
type RequestState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: Error };
```

## Related

- [Replace Enum Plus Payload Fields with Variant Union](#replace-enum-plus-payload-fields-with-variant-union)
- [Add Exhaustive Match](#add-exhaustive-match)
- [Encapsulate Record](#encapsulate-record)

---

# Replace Subclasses with Union Variants

Some class hierarchies are only data variants with little or no behavior. Replace them with union variants when exhaustive handling and plain data are clearer than inheritance.

## Use When

- Subclasses mostly store different fields and contain little behavior.
- Callers immediately inspect subclass type to decide what to do.
- The hierarchy exists to model a closed set of cases.
- You want serialization, pattern matching, or exhaustive handling instead of virtual dispatch.

## Trigger

- Empty subclasses or subclasses that only set constructor fields.
- `instanceof` checks after objects are created.
- Visitor-like code whose only job is to recover the concrete subtype.
- A new subclass requires updating every consumer anyway.

## Mechanics

1. Confirm the set of cases is closed or controlled by this module.
2. Create one union variant per subclass, carrying the subclass fields.
3. Replace subclass construction with variant construction.
4. Move behavior either into functions that match the union or into composed strategies when behavior is open-ended.
5. Delete subclasses after all callers use the union.

## Example

Before:

```ts
class Circle { constructor(readonly radius: number) {} }
class Rectangle { constructor(readonly width: number, readonly height: number) {} }
type Shape = Circle | Rectangle;
```

After:

```ts
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number };
```

## Related

- [Replace Inheritance with Composition](#replace-inheritance-with-composition)
- [Add Exhaustive Match](#add-exhaustive-match)

---

# Builder

Complex construction should not be the caller's responsibility. Extract the construction sequence into a builder that accumulates configuration and returns a finished, validated object.

## Use When

- A constructor has more than four or five parameters and callers must pass `undefined` or `null` for unused slots.
- Object construction spans multiple optional configuration steps.
- The same object is constructed with slight variations across many call sites.
- An object should only exist in a valid, complete state — partial construction must not be observable.

## Trigger

- Constructors or factory functions with growing parameter lists.
- Callers repeating a sequence of setters or mutations before the object is usable.
- Test setup building the same object with minor variations.
- Boolean or enum parameters selecting a construction mode.

## Example

Fluent builder — each configuration method returns `this`; `build()` validates and returns a `Readonly<T>`:

```ts
class QueryBuilder {
  #table = "";
  #conditions: string[] = [];
  #limit?: number;

  from(table: string): this { this.#table = table; return this; }
  where(condition: string): this { this.#conditions.push(condition); return this; }
  limitTo(n: number): this { this.#limit = n; return this; }

  build(): Readonly<Query> {
    if (!this.#table) throw new Error("table is required");
    return Object.freeze(new Query(this.#table, this.#conditions, this.#limit));
  }
}

const q = new QueryBuilder().from("users").where("active = true").limitTo(10).build();
```

For **simple option bags**, prefer a typed options object with a factory function over a full builder class:

```ts
function createQuery(opts: { table: string; where?: string[]; limit?: number }): Query { ... }
```

## Notes

- Use a builder when construction logic is complex, shared, or multi-step; use a plain options object when callers just need named parameters.
- Make the built object immutable — `build()` should return a frozen or `Readonly<T>` value.
- The return type of `build()` can differ from the builder type, letting the type system enforce that construction is complete before use.
- Prefer [Introduce Parameter Object](#introduce-parameter-object) first; graduate to a builder only when the options object acquires validation or conditional steps.

## Related

- [Change Function Declaration](#change-function-declaration)
- [Introduce Parameter Object](#introduce-parameter-object)
- [Replace Constructor With Factory Function](#replace-constructor-with-factory-function)

---

# Facade

A complex subsystem should expose a simple surface for common use cases. Introduce a facade that orchestrates the subsystem and hides its internal structure from callers.

## Use When

- Callers must coordinate multiple subsystem components to perform one coherent task.
- The same sequence of subsystem calls repeats across unrelated callers.
- You want a stable public API over a subsystem that changes frequently.
- Tests need to mock a complex dependency and a narrow facade is easier to stub than the full subsystem.

## Trigger

- Callers import many unrelated modules just to complete one operation.
- Initialization or teardown sequences scattered across callers.
- A subsystem has many low-level classes with no obvious entry point.
- Changing an internal library forces changes in many caller files.

## Example

A facade is usually a plain exported function or a thin module:

```ts
// Subsystem internals
import { parseConfig } from "./config-parser.js";
import { validateSchema } from "./schema.js";
import { buildClient } from "./http.js";

// Facade — one import, one call
export async function createApiClient(configPath: string): Promise<ApiClient> {
  const config = parseConfig(configPath);
  validateSchema(config);
  return buildClient(config);
}
```

Use a class only when the facade must hold shared state:

```ts
export class ReportFacade {
  constructor(private readonly db: Db, private readonly mailer: Mailer) {}

  async sendMonthlyReport(userId: string): Promise<void> {
    const data = await this.db.fetchUsage(userId);
    const pdf = renderPdf(data);
    await this.mailer.send(userId, pdf);
  }
}
```

## Notes

- A facade does not prevent callers from accessing the subsystem directly when they need full control.
- Keep the facade thin — it orchestrates, it does not own business logic.
- Facade and [Introduce Port Adapter](#introduce-port-adapter) pair naturally: the adapter translates one external API, the facade orchestrates several.
- If the facade starts growing, extract further with [Extract Class](#extract-class) or [Split Phase](#split-phase).

## Related

- [Introduce Port Adapter](#introduce-port-adapter)
- [Extract Role Interface](#extract-role-interface)
- [Split Interface with Composition](#split-interface-with-composition)

---

# Decorator

Cross-cutting behavior should wrap an existing object or function rather than be mixed into it. A decorator implements the same interface as the wrapped subject and delegates to it, adding behavior before or after without changing the subject.

## Use When

- The same cross-cutting concern (logging, caching, retry, authorization, timing, rate limiting) applies to many different implementations.
- Behavior must be composable: one subject should be wrappable by multiple orthogonal decorators.
- A concern varies at runtime or per deployment without modifying the subject.
- Tests need to verify cross-cutting behavior independently of business logic.

## Trigger

- The same logging, error-handling, or retry logic copy-pasted into multiple service methods.
- Middleware logic hard-coded inside business functions.
- A class growing with concerns that are not its core responsibility.
- Adding a new cross-cutting concern requires touching every implementation.

## Example

**Function decorator** — wrap any function with the same signature:

```ts
function withRetry<A extends unknown[]>(
  fn: (...args: A) => Promise<void>,
  attempts = 3
): (...args: A) => Promise<void> {
  return async (...args) => {
    for (let i = 0; i < attempts; i++) {
      try { return await fn(...args); }
      catch (e) { if (i === attempts - 1) throw e; }
    }
  };
}

const reliableSend = withRetry(sendEmail);
```

**Class decorator** — implement the same interface as the subject:

```ts
class LoggingUserService implements UserService {
  constructor(private readonly inner: UserService, private readonly log: Logger) {}

  async findUser(id: string): Promise<User> {
    this.log.info(`findUser ${id}`);
    return this.inner.findUser(id);
  }
}

const service = new LoggingUserService(new DbUserService(db), logger);
```

Stack decorators explicitly:

```ts
const fetch = withLogging(withRetry(withCache(fetchUser)));
```

## Notes

- Prefer function decorators over class decorators when subjects are functions or simple callables.
- TypeScript `@Decorator` syntax is a separate mechanism (experimental, framework-specific); the structural pattern here does not require it.
- Keep each decorator focused on one concern — do not combine logging and caching into one wrapper.
- Decorators and [Chain of Responsibility](#chain-of-responsibility) both compose behavior, but a decorator always delegates while a chain handler may stop early.

## Related

- [Extract Role Interface](#extract-role-interface)
- [Introduce Port Adapter](#introduce-port-adapter)
- [Chain of Responsibility](#chain-of-responsibility)
- [Replace Singleton with Injected Dependency](#replace-singleton-with-injected-dependency)

---

# Observer

A component that changes state should not need to know what reacts to it. Let dependents subscribe to events so the producer stays decoupled from its consumers.

## Use When

- Multiple components must react to the same state change or event.
- The producer should not depend on its consumers.
- Consumers vary at runtime or are added without changing the producer.
- An action in one part of the system must trigger side effects elsewhere without explicit coupling.

## Trigger

- A function directly calls many unrelated components after completing its work.
- Adding a new reaction to an event requires modifying the event source.
- Component A imports Component B only to notify it of a change.
- Tests for the producer become complex because they must account for all notification side effects.

## Example

**Typed event bus**:

```ts
type Handler<T> = (event: T) => void;

class EventBus<Events extends Record<string, unknown>> {
  readonly #handlers = new Map<keyof Events, Set<Handler<unknown>>>();

  on<K extends keyof Events>(event: K, handler: Handler<Events[K]>): () => void {
    if (!this.#handlers.has(event)) this.#handlers.set(event, new Set());
    this.#handlers.get(event)!.add(handler as Handler<unknown>);
    return () => this.#handlers.get(event)?.delete(handler as Handler<unknown>);
  }

  emit<K extends keyof Events>(event: K, data: Events[K]): void {
    this.#handlers.get(event)?.forEach(h => h(data));
  }
}
```

**Callback list** for simple cases:

```ts
class Store<S> {
  #state: S;
  #listeners = new Set<(state: S) => void>();

  constructor(initial: S) { this.#state = initial; }

  subscribe(fn: (state: S) => void): () => void {
    this.#listeners.add(fn);
    return () => this.#listeners.delete(fn);
  }

  protected setState(next: S): void {
    this.#state = next;
    this.#listeners.forEach(fn => fn(next));
  }
}
```

Use **signals or RxJS** when observers need computed derivations, async streams, or backpressure.

## Notes

- Prefer typed event names over bare strings; a discriminated union of event objects gives full type safety.
- Always return an `unsubscribe` function or accept an `AbortSignal` to prevent memory leaks.
- For async reactions, return Promises from handlers and `await Promise.all(handlers.map(...))` when ordering matters.
- Observer and [Mediator](#mediator-facade) are related: an observer bus where the bus also routes and transforms becomes a mediator.

## Related

- [Replace Singleton with Injected Dependency](#replace-singleton-with-injected-dependency)
- [Extract Role Interface](#extract-role-interface)
- [Replace Boolean Flags with State Union](#replace-boolean-flags-with-state-union)

---

# Chain of Responsibility

When processing a request through multiple potential handlers, do not hard-code the sequence. Arrange handlers so each decides to handle or pass on the request, making the chain composable and variable.

## Use When

- A request may be handled by one of several handlers depending on its type or current state.
- Handlers should be composable and their order configurable without changing individual handlers.
- Adding a new handler should not require modifying existing ones.
- Processing is a pipeline where each stage can short-circuit, transform, or enrich the request.

## Trigger

- Nested if-else or switch blocks deciding which handler processes a request.
- Middleware-like logic embedded in a single large function.
- Adding a new processing step requires modifying the central dispatch function.
- Validation chains, permission checks, or request transforms applied sequentially.

## Example

**Middleware array** (functional, preferred in TypeScript):

```ts
type Middleware<T> = (req: T, next: () => Promise<void>) => Promise<void>;

async function runChain<T>(req: T, handlers: readonly Middleware<T>[]): Promise<void> {
  let i = 0;
  const next = (): Promise<void> =>
    i < handlers.length ? handlers[i++](req, next) : Promise.resolve();
  return next();
}

const pipeline: Middleware<Request>[] = [authMiddleware, rateLimitMiddleware, loggingMiddleware];
await runChain(request, pipeline);
```

**Handler interface** when each handler owns state or has complex logic:

```ts
interface Handler<T, R> {
  handle(req: T): R | null; // null = pass to next
}

function runHandlers<T, R>(req: T, handlers: readonly Handler<T, R>[]): R | null {
  for (const h of handlers) {
    const result = h.handle(req);
    if (result !== null) return result;
  }
  return null;
}
```

## Notes

- Prefer the functional middleware style over linked-list handler objects in TypeScript.
- Distinguish **pipeline** (every handler runs, transforms the request) from **chain** (first matching handler stops the rest).
- [Decorator](#decorator) and Chain of Responsibility both layer behavior; Decorator always delegates, CoR may stop the chain early.
- For HTTP middleware, Express/Koa/Hono already implement this pattern — model application-level chains after the same `(req, next)` convention.

## Related

- [Decorator](#decorator)
- [Replace Conditional with Strategy](#replace-conditional-with-strategy)
- [Remove Flag Argument](#remove-flag-argument)

---

# Memento

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

## Notes

- Keep the snapshot type serializable (`JSON.stringify`-safe) when persistence, DevTools replay, or cross-tab sync is needed.
- Store snapshots externally (a `History` class, Zustand slice, Redux state) — the originator should focus only on current state.
- For deep graphs, use structural sharing (`{ ...prev, field: newValue }`) rather than deep cloning every snapshot.
- Snapshot on meaningful transitions (save point, step boundary, commit), not on every keystroke — debounce or batch if needed.
- [Change Reference To Value](#change-reference-to-value) is often a prerequisite: value semantics make snapshots trivial to take and compare.

## Related

- [Change Reference To Value](#change-reference-to-value)
- [Replace Boolean Flags with State Union](#replace-boolean-flags-with-state-union)
- [Split Variable](#split-variable)

---

# Iterator and Async Iterator

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

## Notes

- Annotate return types explicitly: `Generator<Yield, Return, Next>` and `AsyncGenerator<Yield, Return, Next>` — TypeScript infers these but explicit types catch misuse early.
- Integrate `AbortSignal` in async generators: check `signal.aborted` at each `yield` point for cooperative cancellation.
- Use `Array.from(gen)` when you genuinely need a materialized array; avoid forcing materialization by default.
- Node.js `Readable` streams implement `AsyncIterable` since v10; `Response.body` (Fetch API) is `AsyncIterable<Uint8Array>` — consume with `for await...of` directly.
- For push-based sources (DOM events, WebSocket messages), convert to an async iterable with a small queue + `AsyncIterableIterator` wrapper rather than collecting into an array.

## Related

- [Split Loop](#split-loop)
- [Replace Loop With Pipeline](#replace-loop-with-pipeline)
- [Extract Function](#extract-function)
- [Observer](#observer)
