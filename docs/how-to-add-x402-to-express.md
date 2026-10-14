<!-- fuente: https://x402.chikocorp.com/docs/how-to-add-x402-to-express.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · add x402 to Express


# How to add x402 to an Express API

**Mount the x402 payment middleware before the protected route, configure the accepted network/asset and receiver, and confirm an unauthenticated request returns a `402` with a readable price. The runtime 402 is authoritative — static metadata is not.**


## Steps

- Install the x402 server SDK for Express.
- Configure network, asset and receiver (for example native USDC on Base, `eip155:8453`).
- Register the payment middleware *before* the route handler.
- Make sure the 402 carries a decodable challenge with price, network, asset and receiver.
- Verify with no wallet: the unpaid call must return 402, not 200 and not 403.


## Common mistakes

Middleware on a prefix but not the route; a proxy or edge cache answering before the origin; declaring a price only in OpenAPI while the live challenge omits it; or a discovery manifest that names a network the challenge does not accept.


## What this does NOT prove

A correct 402 does not prove settlement, delivery, or catalogue indexing. Verifying the challenge is the first step, not the whole guarantee.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### Where does the x402 middleware go in Express?

Before the protected route handler, and after any parsing the handler needs, so an unpaid request is answered with 402 before paid work runs.


### Why does my route return 200 instead of 402?

The middleware is usually on the wrong path or only on a prefix, or a proxy answers first. The route must sit behind the payment wrapper.

[More answers for x402 API developers](https://x402.chikocorp.com/docs/) — [back to x402 Preflight](https://x402.chikocorp.com/).
