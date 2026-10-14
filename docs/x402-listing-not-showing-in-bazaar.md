<!-- fuente: https://x402.chikocorp.com/docs/x402-listing-not-showing-in-bazaar.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · listing not showing in Bazaar


# x402 resource listed in the Bazaar but buyers cannot find or pay it

**The usual causes: the resource returns 404/410 while still listed, the discovery metadata drifted from the live challenge, the method differs, or the discovery consumer never indexed the update.**


## Most common cause: the listing outlives the route

In a sample of 230 endpoints taken from the public x402 catalogue, 20 answered 404 or 410 while still listed, and 8 returned a 402 without a readable price. A buyer agent that finds you in the catalogue gets nothing, and there is no way to pay you.


## Second cause: metadata drift

The advertised price, network or method in the discovery document stopped matching the live challenge (for example, the catalogue says `GET` and the route only accepts `POST`). Consumers that cache the metadata keep sending the wrong request.


## How to check it in one call

POST https://x402.chikocorp.com/api/preflight/inspect with the resource URL. The report shows the live status code, the live price versus the advertised price, whether the discovery entry resolves, and whether CORS would block a browser-hosted agent.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### Why does my x402 resource return 404 if it is in the catalogue?

Because the catalogue is a cache of discovery metadata: the route was removed or renamed after publication and nothing re-published the entry.


### Does the catalogue index every update automatically?

No. Discovery consumers re-read metadata on their own schedule, and a settled payment is not proof that the listing was indexed.

[Back to x402 Preflight](https://x402.chikocorp.com/) — launch diagnostics for x402 API developers.
