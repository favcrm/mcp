#!/usr/bin/env bash
# Smoke-test the FavCRM MCP server end-to-end.
# Requires: FAVCRM_API_KEY (mint at https://app.favcrm.io/settings/mcp-keys)
set -euo pipefail

: "${FAVCRM_API_KEY:?FAVCRM_API_KEY env var is required (fav_mcp_...)}"

ENDPOINT="${FAVCRM_MCP_URL:-https://api.favcrm.io/mcp}"
HEADERS=(
  -H "Content-Type: application/json"
  -H "Accept: application/json, text/event-stream"
  -H "Authorization: Bearer $FAVCRM_API_KEY"
)

echo "→ Discovery (public, no auth)"
curl -s "${ENDPOINT%/mcp}/.well-known/mcp/server-card.json" \
  | jq '{server: .serverInfo.name, version: .serverInfo.version, tools: (.tools | length), resources: (.resources | length), prompts: (.prompts | length)}'

echo
echo "→ initialize"
curl -s "$ENDPOINT" "${HEADERS[@]}" -X POST -d '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {},
    "clientInfo": { "name": "favcrm-smoke-test", "version": "1.0" }
  }
}' | jq '.result.serverInfo'

echo
echo "→ tools/list (sample first 3)"
curl -s "$ENDPOINT" "${HEADERS[@]}" -X POST -d '{
  "jsonrpc": "2.0", "id": 2, "method": "tools/list"
}' | jq '.result.tools[0:3] | .[] | {name, title: .annotations.title, readOnly: .annotations.readOnlyHint}'

echo
echo "→ tools/call list_membership_tiers"
curl -s "$ENDPOINT" "${HEADERS[@]}" -X POST -d '{
  "jsonrpc": "2.0", "id": 3, "method": "tools/call",
  "params": { "name": "list_membership_tiers", "arguments": {} }
}' | jq '.result.content[0].text' -r | jq -c '.tiers[0:3] // .[0:3] // .' 2>/dev/null || true
