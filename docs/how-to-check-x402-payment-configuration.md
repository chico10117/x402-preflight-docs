<!-- fuente: https://x402.chikocorp.com/docs/how-to-check-x402-payment-configuration.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · how to check a payment configuration


# How to check an x402 payment configuration before launch

**A read-only check of the live HTTP 402 challenge: scheme, network, asset, amount, receiver, extensions, CORS and discovery metadata — without a wallet and without spending USDC.**


## What the check looks at

The endpoint's live 402 response is authoritative. Inspect the challenge header (x402 v2 carries it in `payment-required`), then compare it against what the endpoint advertises: price, network (CAIP-2, e.g. `eip155:8453` for Base), asset contract, receiver address, scheme, timeout, and the Bazaar discovery entry. A mismatch between the advertised price and the live challenge price is the most common silent failure.


## Free, one call, no wallet

POST https://x402.chikocorp.com/api/preflight/inspect with `{"resource_url":"<URL>","method":"GET"}`. The response returns a decision (ALLOW / BLOCK), a score, the observed price in USDC, the pay-to address, whether discovery metadata resolves, and a machine-readable list of findings.


## What it does not prove

A read-only check cannot prove settlement, paid delivery, seller identity, or future availability. It is time-bound evidence, not launch certification.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### What is the authoritative source for an x402 payment configuration?

The live HTTP 402 response. Static metadata (OpenAPI, `/.well-known/x402`) can drift from runtime behaviour, so always read the challenge itself.


### Do I need a wallet to check an x402 endpoint?

No. A read-only probe reads the 402 challenge without credentials, without signing and without spending USDC.

[Back to x402 Preflight](https://x402.chikocorp.com/) — launch diagnostics for x402 API developers.
