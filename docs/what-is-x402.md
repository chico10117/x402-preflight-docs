<!-- fuente: https://x402.chikocorp.com/docs/what-is-x402.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · what is x402


# What is x402?

**x402 is an open, HTTP-native payment standard that lets a server charge per request: an unpaid call returns `402 Payment Required` with a payment challenge, the client pays in stablecoin (commonly USDC on Base), and the retried call is served — no account and no API key required for that call.**


## How a call works

- A client (often an AI agent) requests the resource with no payment.
- The server answers `402` with a challenge naming the network, asset, amount and receiver.
- The client settles the payment and retries with proof.
- The server verifies and returns the payload.


## Why it exists

Card rails carry fixed fees that make sub-cent, machine-to-machine calls uneconomic. x402 moves the payment into the HTTP exchange itself so an endpoint can be monetized per call, and agents can pay without a signup flow.


## What it does NOT prove

A working 402 proves the endpoint can ask for payment. It does not prove the service is honest, that payment will settle, that delivery will happen, or that the listing is indexed by any catalogue. Those are separate checks — which is exactly what a read-only inspection reports.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### What is x402 in one sentence?

x402 is an open, HTTP-native payment standard that lets a server charge per request: an unpaid call returns 402 with a payment challenge, the client pays in stablecoin, and the retried call is served.


### Does x402 replace API keys?

For per-call billing it can: the payment authorizes the request, so a paying client needs no account or key. Sellers can still combine it with keys for other purposes.


### Which network and asset does x402 use?

The challenge is authoritative. In practice most listings accept native USDC on Base (eip155:8453), but the live 402 decides, not the advertised default.

[More answers for x402 API developers](https://x402.chikocorp.com/docs/) — [back to x402 Preflight](https://x402.chikocorp.com/).
