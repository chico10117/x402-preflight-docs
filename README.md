# x402 Preflight — public documentation

Documentation only. This repository holds the public, citable material for **x402 Preflight**, a
read-only launch-diagnostics service for [x402](https://x402.org) endpoints
(`https://x402.chikocorp.com`).

The service code is private; nothing in this repository is required to run it, and no payment
logic, credentials or infrastructure configuration belongs here.

## What the service does

It reads the live `402` challenge your endpoint serves and compares it with what the endpoint
advertises — price, network, asset, receiver, scheme — plus discovery metadata, input schemas,
CORS, redirects and cache behaviour, and returns findings with evidence. It never connects a
wallet, signs nothing, and makes no purchase on the target.

## Free check (no account, no wallet)

```bash
curl -s -X POST https://x402.chikocorp.com/api/preflight/inspect \
  -H 'content-type: application/json' \
  -d '{"resource_url":"https://your-api.example.com/resource","method":"GET"}'
```

## Machine-readable manifests

Everything a registry, directory or agent needs to index this server without filling a form:

| file | for |
|---|---|
| [server.json](server.json) | official MCP registry manifest (streamable HTTP remote) |
| [glama.json](glama.json) | Glama maintainer claim |
| [SKILL.md](SKILL.md) | agent skill: tools, inputs, prices and boundaries |
| [gemini-extension.json](gemini-extension.json) | Gemini CLI extension pointing at `https://x402.chikocorp.com/mcp` |

Live equivalents served by the service: [`/llms.txt`](https://x402.chikocorp.com/llms.txt),
[`/mcp`](https://x402.chikocorp.com/mcp) and [`/.well-known/x402.json`](https://x402.chikocorp.com/.well-known/x402.json).

## Contents

- [docs/](docs/README.md) — short answers: what x402 is, how to add it, and how to tell whether
  an endpoint really charges.
- [guides/x402scan-discovery.md](guides/x402scan-discovery.md) — discovery requirements for
  catalogue listings (OpenAPI as the canonical contract).
- [guides/bazaar-listing-verification.md](guides/bazaar-listing-verification.md) — how a Bazaar
  listing is verified and what the catalogue evidence says.
- [reference/](reference/) — mirrors of the live public artifacts (`llms.txt`, `openapi.json`).

## Canonical source

The rendered pages live at <https://x402.chikocorp.com/docs/>. If this repository and the site
disagree, the live service wins — the runtime `402` is the authoritative contract.

## Contributing

Corrections and additions are welcome: see [CONTRIBUTING.md](CONTRIBUTING.md). Keep claims
verifiable — a finding without a reproducible command is not documentation.

## Contact

`admin@chikocorp.com`
