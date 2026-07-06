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
2. Change the consumer to depend on the port with Change Function Declaration.
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

- [Extract Role Interface](extract-role-interface.md)
- [Replace Query with Parameter](replace-query-with-parameter.md)
- [Extract Class](extract-class.md)
