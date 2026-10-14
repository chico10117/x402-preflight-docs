<!-- fuente: https://x402.chikocorp.com/docs/x402scan-discovery-requirements.html -->

[x402 Preflight](https://x402.chikocorp.com/) · [docs](https://x402.chikocorp.com/docs/) · discovery requirements


# Discovery requirements for x402 catalogues (OpenAPI + x-payment-info)

**Catalogue crawlers prefer OpenAPI-first discovery: each paid operation declares x-payment-info with protocols and a fixed or dynamic price, plus a 402 response; /.well-known/x402 remains the compatibility path.**


## OpenAPI-first

At `/openapi.json`, each paid operation must declare `x-payment-info` with `protocols` (for example `[{"x402": {}}]`) and a price object (`{"mode":"fixed","currency":"USD","amount":"0.05"}`), include a `402` response, and state auth through `security` / `components.securitySchemes`. The runtime 402 stays authoritative over any static metadata.


## Compatibility path

Keep `/.well-known/x402` during migration: legacy consumers still read it, and the version 2 manifest lists each capability with its URL, method and accepted payment (network, asset, amount, receiver).


## Common gaps

Missing `402` in the operation responses, price present only as a custom field, or a manifest that names a network the challenge does not accept. Each one silently drops the endpoint from catalogue pickup.


## Check your own endpoint (free, read-only)

```
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

Deeper read: the technical audit is 0.05 USDC and the full diagnostic report 5 USDC, paid in USDC on Base and delivered by API. Monthly monitoring is 29 USDC/month.


## Frequently asked questions


### What does x-payment-info need to contain?

A protocols entry naming x402 and a price object with mode, currency and amount (or a min/max range for dynamic pricing), plus a 402 response on the operation.


### Is /.well-known/x402 still needed?

Yes as a compatibility path. New consumers prefer OpenAPI, but the well-known manifest keeps older clients working during migration.

[Back to x402 Preflight](https://x402.chikocorp.com/) — launch diagnostics for x402 API developers.
