# scripts/

## refresh-reference.sh

`reference/llms.txt` and `reference/openapi.json` are **mirrors** of the live
discovery documents served by `https://x402.chikocorp.com`. They are copied here
so the repository is self-contained and citable, but the **live documents are
authoritative** and can change with any service deploy.

Run this script to refresh the mirrors:

```bash
./scripts/refresh-reference.sh          # refresh in place
./scripts/refresh-reference.sh --check  # exit 1 if out of date (CI-friendly)
```

Set `X402_BASE_URL` to point at a different host (default `https://x402.chikocorp.com`).
