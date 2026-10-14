<!-- fuente: repositorio del servicio -->

# Bazaar discovery and catalog evidence

This change builds on the merged x402scan/OpenAPI work in #18. Bazaar is a
separate discovery path; being discoverable in one index says nothing about
another index's coverage.

## What is published

All five canonical paid operations (POST audit, GET audit compatibility alias,
POST remediation, and both paid MCP tools) publish optional provider metadata:

```json
{
  "serviceName": "x402 Preflight",
  "tags": ["x402", "preflight", "api-audit", "agent-commerce", "developer-tools"]
}
```

The metadata is set on the HTTP route configuration and emitted under
**PaymentRequired.resource**, not under `extensions.bazaar.info`. Integration
tests showed the locked SDK ignores these newer route fields, so a small adapter
uses its existing `enrichPaymentRequiredResponse` hook before header encoding.
It delegates to the official Bazaar extension, preserves all its other hooks,
and only adds provider fields for the five canonical operation identities. It
does not mutate payment requirements or relabel legacy routes. The Bazaar
`info` object remains the existing HTTP/MCP input/output declaration. An icon is
not advertised because this change does not establish a real, stable icon asset.
Legacy routes are not relabeled. Service name/tag strings are printable ASCII,
at most 32 characters each, with at most five tags.

Prices, payee, facilitator selection, request validation, SSRF restrictions,
settlement logic, and the three canonical capabilities are unchanged. The
OpenAPI PaymentRequired resource schema gains these optional properties without
allowing arbitrary additional fields. No dependencies, migrations, credentials,
or environment variable names are added.

## Verification commands

```bash
# Deterministic, offline declarations; no server required.
npm run verify:bazaar

# Read the deployed x402 manifest, probe five unpaid challenges, inspect its catalog.
PUBLIC_URL=https://x402.chikocorp.com npm run verify:bazaar

# CI/operator gate: also fail unless all five exact listings can be confirmed.
PUBLIC_URL=https://x402.chikocorp.com npm run verify:bazaar -- --require-indexed

# Bound catalog scanning (1..20 pages per resource type; default 5, 100 items/page).
PUBLIC_URL=https://x402.chikocorp.com npm run verify:bazaar -- --max-pages=10
```

`npm run validate:bazaar` remains an alias, but its old JSON shape changes to the
new evidence report. The old hard-coded CDP merchant lookup and unconditional
claim that CDP settlement is required have been removed.

Public mode takes the canonical payment requirements and facilitator from the
live `/.well-known/x402.json` document, and checks each 402 against that manifest.
It supports this service's current exact EVM payment configuration. Override
only the catalog being inspected with the existing
`X402_FACILITATOR_URL=https://...` setting, or
`X402_USE_CDP_FACILITATOR=true`. The report records whether its facilitator came
from the manifest or an explicit override. These flags do not reconfigure the
server and do not load or send CDP credentials. An authenticated catalog will
therefore correctly return UNKNOWN/AUTH_REQUIRED.

Only the three known HTTP operations and two known MCP tools are probed. Inputs
are public example URLs, never a customer's data. The client sends no wallet
signature, authorization, cookie, or payment header. Unpaid probes can increment
ordinary HTTP telemetry, but cannot pay or complete a paid intake. There is no
call to `/verify`, `/settle`, a registration endpoint, or a third-party resource
URL returned by the catalog.

## Reading the report

| Observation | Meaning |
| --- | --- |
| `declarations.*.status: VALID` | The local declaration passed the SDK's schema validator. |
| `runtime.*.status: VALID` | A live 402 matched the expected operation, payment tuple, service metadata and schema. |
| `catalog.support.status: ADVERTISED` | This facilitator's `/supported` response advertises Bazaar; not proof of indexing. |
| `catalog.resources.*.status: INDEXED` | A matching row was observed in that facilitator's catalog. |
| `catalog.resources.*.status: NOT_FOUND` | A complete, consistent paginated scan returned no exact match, in this catalog only. |
| `catalog.resources.*.status: UNKNOWN` | The lookup could not establish presence or absence. `indexed` is null, never false. |

Matching checks origin/path, HTTP method or MCP tool name, type, x402 version,
payee, network, asset, scheme, and exact atomic amount. Query input values do not
create separate identities for this service's fixed HTTP routes. MCP tools may
use the canonical `.../mcp#toolName` identifier or the plain `/mcp` transport URL
plus the correct tool name. An opaque identifier such as `mcp://tool/name` is not
accepted as proof of our origin. An address match or similar-looking URL alone
is insufficient. Rows with old prices are not exact matches. A confirmed row
with stale/missing provider tags is reported as indexed with
`serviceMetadata: MISSING_OR_STALE` rather than falsely reported absent.

A 404/405 means that endpoint is unavailable, not that our service is unlisted.
401/403, 429, network failures, malformed responses, incomplete pagination,
repeated pages, changing totals and page-budget exhaustion leave unresolved
resources UNKNOWN. Already confirmed rows are retained when later pages fail.
The list API's `items` and `pagination {limit,offset,total}` contract is supported;
a facilitator-specific search response is not guessed to be a complete list.

`ok` is a local/runtime contract check, **not** a synonym for indexed. Catalog
absence/uncertainty only makes the command fail when `--require-indexed` is used.
`indexingVerified` requires a matching row for every advertised paid operation.
Observation timestamps are included; no result proves future availability,
settlement, seller trust, ranking, or buyer demand.

Each request uses the existing public-target policy, HTTPS only, no redirects,
a bounded DNS/request/body deadline (8 seconds), and at most 1 MB of response
text. Catalog page counts are capped. Responses are reduced to fixed status
codes and matching identifiers; arbitrary metadata, examples, headers and
remote error text are not logged. The GET audit retains its <8 KB payment-header
budget. Other response sizes and middleware behavior are unchanged.

## Tests and activation

Tests cover pure matching/pagination logic, manifest and runtime validation,
HTTP safety limits, local/strict CLI behavior, and actual Express/x402 SDK
challenge generation with a mock facilitator. SDK tests assert zero verify and
settle calls, and check metadata on all five operations. CI stays offline except
for dependency installation; it does not depend on a live catalog or spend money.

After deployment, run the public command. Resolve invalid runtime declarations
or mismatched payment metadata first. For valid challenges but missing listings,
inspect the selected facilitator's support, client extension forwarding and
catalog policy. Do not force a self-payment or change facilitators just to turn a
status green. Check that real clients propagate the declared Bazaar extension;
a successful settlement alone is not proof of catalog inclusion. No automatic
registration, payment or deployment is performed by this PR.

## Primary references checked 2026-09-30

- [Bazaar documentation](https://docs.x402.org/extensions/bazaar): provider metadata, optional catalog endpoints, client forwarding, and catalog-visibility caveats.
- [Extension lifecycle](https://docs.x402.org/extensions/overview): the response enrichment hook used for locked-SDK compatibility.
- [HTTP SDK route configuration](https://github.com/x402-foundation/x402/blob/6b6ee91fee027b540faabcb25774e73851006c3b/typescript/packages/core/src/http/x402HTTPResourceServer.ts): route-level serviceName/tags, emitted as resource metadata.
- [Bazaar facilitator client contract](https://github.com/x402-foundation/x402/blob/6b6ee91fee027b540faabcb25774e73851006c3b/typescript/packages/extensions/src/bazaar/facilitatorClient.ts): path-preserving list URL, payTo/type/network filters, items and offset pagination.
