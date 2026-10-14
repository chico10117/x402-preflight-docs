#!/usr/bin/env bash
#
# refresh-reference.sh — keep reference/ mirrors in sync with the live site.
#
# reference/llms.txt and reference/openapi.json are snapshots of the public
# discovery documents served by https://x402.chikocorp.com. They are copied
# here so the repo is self-contained and citable, but the live documents are
# authoritative. Run this to refresh the mirrors and open a change if they drifted.
#
# Usage:
#   ./scripts/refresh-reference.sh            # refresh in place
#   ./scripts/refresh-reference.sh --check    # exit 1 if out of date, no writes
#
set -euo pipefail

BASE="${X402_BASE_URL:-https://x402.chikocorp.com}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF="$ROOT/reference"
CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

command -v curl >/dev/null 2>&1 || { echo "error: curl is required" >&2; exit 2; }

drift=0
fetch() {
  local path="$1" out="$2" tmp
  tmp="$(mktemp)"
  if ! curl -fsS --max-time 30 "$BASE$path" -o "$tmp"; then
    echo "error: failed to fetch $BASE$path" >&2
    rm -f "$tmp"
    return 1
  fi
  if [ ! -s "$tmp" ]; then
    echo "error: $BASE$path returned an empty body" >&2
    rm -f "$tmp"
    return 1
  fi
  if [ -f "$out" ] && cmp -s "$tmp" "$out"; then
    echo "ok: $path unchanged"
    rm -f "$tmp"
  else
    echo "drift: $path differs from $out"
    drift=1
    if [ "$CHECK" -eq 0 ]; then
      mkdir -p "$(dirname "$out")"
      mv "$tmp" "$out"
    else
      rm -f "$tmp"
    fi
  fi
}

fetch "/llms.txt"     "$REF/llms.txt"
fetch "/openapi.json" "$REF/openapi.json"

if [ "$CHECK" -eq 1 ] && [ "$drift" -ne 0 ]; then
  echo "reference/ is out of date; run scripts/refresh-reference.sh" >&2
  exit 1
fi

[ "$drift" -eq 0 ] && echo "reference/ is up to date."
