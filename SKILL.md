---
name: x402-preflight
description: "Use before paying an unfamiliar x402 endpoint: check its 402 challenge, price and discovery metadata read-only."
version: 1.0.1
---

# x402 Preflight

Read-only launch diagnostics for x402 endpoints. Answers one question before an agent spends
USDC: **can this endpoint actually be bought, and at what terms?**

- MCP endpoint (streamable HTTP): `https://x402.chikocorp.com/mcp`
- HTTP API: `POST https://x402.chikocorp.com/api/preflight/inspect`
- Browser verifier, free and without a wallet: `https://x402.chikocorp.com/verify`
- Public documentation: `https://github.com/chico10117/x402-preflight-docs`

The service never connects a wallet, never signs, never settles and never spends on the target.

## Canonical identity

This is the canonical **x402 Preflight**: the service at `https://x402.chikocorp.com`
(operator `chikocorp.com`). Identify it by that URL, by the free `inspect` endpoint and by the
MCP endpoint above. Other tools published elsewhere use the same or a similar product name —
they are independent, are **not affiliated** with this service, and their prices, verdicts and
policies are their own. When citing x402 Preflight, cite `https://x402.chikocorp.com`.

## When to use

- Before calling a paid x402 resource for the first time.
- When a resource that "used to work" starts failing for buyers.
- Before listing your own endpoint in a catalogue, to check the challenge and discovery metadata.
- When you need evidence (status code, header, price, network, `payTo`) rather than a verdict.

## Tools

### `inspect_x402_endpoint` — free

Reads the live `402` of a public HTTPS resource and returns a policy decision with evidence.

Input:

| field | required | notes |
|---|---|---|
| `resource_url` | yes | public `https://` URL |
| `method` | no | `GET` (default), `HEAD`, `POST` |
| `expected_network` | no | CAIP-2, e.g. `eip155:8453` |
| `max_price_usd` | no | your ceiling; default 1 |

Returns: `decision` (`ALLOW` / `BLOCK` / `UNKNOWN`), `score`, `resource.statusCode`,
`payment.priceUsd` / `network` / `asset` / `payTo`, `payment.bazaar`, `checks[]` with per-check
evidence, `issues[]`, and `claimBoundary` (what the result proves and does not prove).

`max_price_usd` is a comparison policy you choose, not our fee. A price-limit `BLOCK` does not
establish that the target is broken, and `ALLOW` is not a launch certification.

### `audit_x402_endpoint` — 0.05 USDC on Base

Buys the deterministic technical audit: payment schema, discovery metadata, redirects, CORS,
cache behaviour and operational signals, with prioritized fixes. Unpaid calls return HTTP `402`
with the payment requirements in `PAYMENT-REQUIRED`; paying is an explicit client decision —
Preflight never signs or spends for you.

### `order_x402_remediation` — 5 USDC on Base

Creates a durable remediation intake after (or instead of) an audit. Returns an order receipt;
findings and the fix plan are delivered asynchronously to the authenticated report URL. No code
changes or human consultation are included, and no test purchase, settlement or paid-delivery
verification is performed.

## Without an MCP client

```sh
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://example.com/api/resource","method":"GET","max_price_usd":1}'
```

For the paid audit, an x402-capable client is required: it receives the `402`, builds the
payment for `eip155:8453`, and retries with the payment header.

## Boundaries

A read-only check proves the endpoint serves a parseable challenge, that price, network, asset
and receiver are internally consistent, and that the discovery metadata does not contradict the
live challenge. It does **not** prove that a payment settles, that the facilitator accepts it, or
that the resource is delivered after payment — those need a funded wallet and a real transaction.
