# Agent discovery: x402scan, OpenAPI-first

Chosen channel: **x402scan**. This change improves the existing `/openapi.json`
contract for an actual agent discovery consumer, rather than adding another
unconsumed manifest, changing payment middleware, or spreading effort across
multiple directories.

## Evidence checked on 2026-09-30

The first-party [discovery spec](https://github.com/Merit-Systems/x402scan/blob/131a5d3ca9f71f145b6da4a40334c0b52544194c/docs/DISCOVERY.md)
recommends OpenAPI-first discovery. The more detailed
[integration spec](https://github.com/Merit-Systems/x402scan/blob/131a5d3ca9f71f145b6da4a40334c0b52544194c/apps/scan/src/app/(app)/(home)/integration-spec/_content/markdown.ts)
provides the exact protocol-object shape, `info.x-guidance`, explicit free-route
classification, and input examples as a way to avoid invalid probes.

Before this change our paid operations had `x-payment-info.protocol: "x402"`
and `priceUsd`, but lacked the scanner's `protocols` array and structured `price`.
The free inspector had no explicit `security: []`. These are concrete contract
mismatches; they are **not proof** of the cause of every historical indexing
failure, evidence of demand, or a guarantee of ranking/traffic.

## Changes and compatibility

The existing discovery builders are preserved byte-for-byte in
`src/preflight/discovery-contracts.js`. `src/preflight/discovery.js` retains the
same public exports and decorates only the OpenAPI document through the isolated,
dependency-free `x402scan-discovery.js` adapter.

Paid operations retain all legacy fields and gain:

```json
{
  "protocols": [{ "x402": {} }],
  "price": { "mode": "fixed", "currency": "USD", "amount": "0.050000" }
}
```

That amount is decimal USD. The runtime USDC challenge still uses `"50000"`
atomic units for a $0.05 payment. Runtime `402` is authoritative. Configured
prices must be positive, finite and representable at USDC's six-decimal precision;
invalid metadata is rejected instead of publishing a misleading quote.

The free inspector gains `security: []`; existing explicit/inherited auth is
never overwritten. `info.x-guidance` explains free inspection, deeper paid audit,
explicit approval for remediation intake, safety limits and report limitations.
JSON-body and GET-query examples preserve required fields and existing schemas.
The GET audit remains an alias, not a fourth canonical tool. No changes are made
to SSRF checks, credentials, payments, settlements, wallets, database schema or
prices. No new dependencies or configuration names are introduced.

## Validation

```bash
npm ci
npm run check
npm test
npm run verify:discovery
node scripts/verify-x402scan-discovery.js
PUBLIC_URL=https://x402.chikocorp.com node scripts/verify-x402scan-discovery.js
```

Without `PUBLIC_URL`, the new script validates a deterministic local contract.
With it, the script fetches only `/openapi.json` with a timeout, response-size
limit and no redirects. It never invokes paid tools, sends payment signatures,
or submits a registration. It requires all three payable HTTP operations
(POST audit, GET audit alias, POST remediation) and the explicit free inspector.
It exits nonzero on a mismatch and always reports external `indexing: "UNKNOWN"`.
This is a targeted check of the fields this service emits, not a complete OpenAPI
validator or an implementation of every pricing mode supported by x402scan.

The PR adds deterministic adapter tests, real-builder integration tests and a
read-only GitHub Actions job that runs syntax checks, the full test suite and
both discovery checks. PostgreSQL integration still needs its existing optional
`TEST_ORDER_DATABASE_URL`; no secrets are added to the workflow.

## Activation after merge/deployment

1. Deploy to the canonical origin and run the public check above. Passing proves
   only metadata compatibility; it does not prove deployment solely from a merge.
2. In x402scan, use **Add Server** with `https://x402.chikocorp.com` so it follows
   OpenAPI discovery. Review method-specific failed/skipped reasons. Registration
   is a separate external action and is not performed by this PR or CI.
3. Verify the canonical POST audit and remediation URLs in the resulting listing
   and an agent-facing search result. Record listing URL and observation time;
   until then, treat external indexing as unknown. The unauthenticated GET audit
   without `resource_url` intentionally stays HTTP 400; use its published example
   or canonical POST rather than weakening request validation for a crawler.

A runtime `402` challenge, valid OpenAPI, successful listing and an actual paid
customer are four different milestones. This PR addresses the OpenAPI contract;
it does not buy traffic, fabricate usage, pay a facilitator to force indexing,
claim ownership, or promise placement.
