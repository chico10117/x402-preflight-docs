<!-- fuente: https://x402.chikocorp.com/docs/x402-endpoint-returns-200-without-charging.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · endpoint returns 200 without charging


# x402 endpoint returns 200 without a payment challenge

**If a plain GET returns the data instead of a 402, the listing cannot earn: any agent calling it gets the result for free. It is usually the payment middleware not mounted on that route, or a proxy answering first.**


## What it means

An x402-protected resource must answer an unauthenticated request with a `402 Payment Required` carrying the payment challenge. A `200` with the payload means the payment requirement never executed — the resource is public.


## Why it happens

The middleware is registered on the wrong path or only on a prefix; a CDN, edge function or cache answers before the origin; or the route was refactored and the payment wrapper was dropped while the discovery listing stayed.


## How to verify

Request the resource with no payment header and inspect the status: 402 with a challenge is expected, 200 is the bug. The free check reports this as *responds 200 without a payment challenge* and states the advertised price so the seller can size the leak.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### Should an x402 endpoint ever return 200 without payment?

Only for free or public routes. If a resource is listed with a price, an unpaid request must return 402.


### Can a cache hide the 402?

Yes. A cached 200 or an edge rule can return content before the origin's payment middleware runs; check cache headers alongside the status.

[Back to x402 Preflight](https://x402.chikocorp.com/) — launch diagnostics for x402 API developers.
