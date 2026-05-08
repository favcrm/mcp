# FavCRM MCP

> Install snippets, examples, and docs for the [FavCRM](https://favcrm.io) Model Context Protocol server. The server itself is hosted at `https://api.favcrm.io/mcp` — this repo is for client setup and community examples.

136 typed tools — customers, bookings, loyalty, invoices, payments, WhatsApp / SMS / email — exposed via MCP. Works with any agentic client that speaks Streamable HTTP transport.

| Client | Status | Setup |
|---|---|---|
| **Vercel v0** | ✅ Live | [Marketplace install](https://vercel.com/integrations/favcrm) — auto-provisions a workspace + injects env vars |
| **Cursor** | ✅ Live | [`mcp.json` snippet](#cursor) |
| **Smithery** | ✅ Live | [`smithery mcp add favcrm/favcrm`](#smithery) |
| **Claude Desktop / Connector** | 🚧 Pending | OAuth provider (Phase 3, ~3 weeks) |
| **ChatGPT Apps Directory** | 🚧 Pending | Listing under review |
| **Windsurf / Continue.dev / Zed** | ✅ Works | Same `mcp.json` shape as Cursor |

---

## Get a key

Sign up at [favcrm.io/signup](https://favcrm.io/signup). The free tier covers 100 customers, 200 bookings/month, and 1k MCP calls/month. Mint an API key from the merchant portal at `Settings → MCP Keys` — keys look like `fav_mcp_xxxxxxxxxxxx`.

Existing FavCRM merchants: same place, no plan upgrade needed for MCP access.

---

## Cursor

Verified shape, [cursor.com/docs/mcp](https://cursor.com/docs/mcp).

**`~/.cursor/mcp.json`** (or `.cursor/mcp.json` in your project):

```json
{
  "mcpServers": {
    "favcrm": {
      "url": "https://api.favcrm.io/mcp",
      "headers": {
        "Authorization": "Bearer ${env:FAVCRM_API_KEY}"
      }
    }
  }
}
```

Then export the key — anywhere your Cursor process reads env vars:

```bash
# shell rc
echo 'export FAVCRM_API_KEY=fav_mcp_...' >> ~/.zshrc

# or per-project (direnv)
echo 'export FAVCRM_API_KEY=fav_mcp_...' >> .envrc
```

Restart Cursor → `Settings → MCP → favcrm` connects → 136 tools land in chat.

> Why `${env:VAR}` instead of inline? Cursor interpolates env vars at request time so the key never lands in your repo or shared config.

---

## Smithery

[`favcrm.io`](https://smithery.ai/server/favcrm/favcrm) on Smithery — install via CLI:

```bash
npm i -g @smithery/cli
smithery login
smithery mcp add favcrm/favcrm
```

For a project-scoped install, `smithery mcp add favcrm/favcrm --client cursor` writes the right `mcp.json` block.

---

## Claude Desktop

🚧 OAuth-based connector pending Phase 3. Once live:

1. `claude.com → Connectors → Add custom connector`
2. URL: `https://api.favcrm.io/mcp`
3. Authorize via OAuth → workspace selector → tool list

Until then, advanced users can wire FavCRM into Claude Desktop's `claude_desktop_config.json` via the same Bearer-header pattern as Cursor (community-only path; not currently in Anthropic's connector directory).

---

## ChatGPT

🚧 Apps Directory listing under review. Once approved:

1. ChatGPT → Tools menu → Apps → search "FavCRM"
2. Add → OAuth handshake → workspace selector
3. 24 curated tools land in chat (read-mostly + safe writes; destructive ops gated behind confirmation)

---

## Test it

Once your config is live, ChatGPT/Cursor/Claude will list tools automatically. To smoke-test from the command line:

```bash
# Discovery (no auth needed — public-scan endpoint)
curl https://api.favcrm.io/.well-known/mcp/server-card.json | jq '.tools | length'
# → 132

# Auth + initialize
curl -s https://api.favcrm.io/mcp \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer $FAVCRM_API_KEY" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"curl","version":"1"}}}' \
  | jq

# Call a read-only tool
curl -s https://api.favcrm.io/mcp \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer $FAVCRM_API_KEY" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_membership_tiers","arguments":{}}}' \
  | jq
```

See [`examples/`](./examples) for more.

---

## Tool surface

136 tools across 22 scopes. Every tool ships with annotations:

- `title` — human-readable label
- `readOnlyHint` — `true` for `list_*` / `get_*` / `search_*` / etc.
- `destructiveHint` — `true` for `delete_*` / `cancel_*` / `void_*` / `refund_*`
- `openWorldHint` — `true` for tools that hit external services (WhatsApp, Stripe, email)
- `idempotentHint` — `true` for `set_*` / `update_*` / `upsert_*` and read-only

Clients can use these to gate destructive calls or estimate cost. The full catalog at `https://api.favcrm.io/.well-known/mcp/server-card.json` is the source of truth — listings here are summaries only.

| Scope | Sample tools | Read-only | Write |
|---|---|---|---|
| `contacts` | `search_members`, `get_member_profile`, `attach_tags` | 5 | 5 |
| `bookings` | `list_services`, `get_available_slots`, `create_booking` | 12 | 15 |
| `membership` | `list_tiers`, `enrol_membership`, `earn_loyalty_points` | 4 | 3 |
| `shop` | `list_products`, `get_order`, `create_order` | 8 | 6 |
| `invoices` | `list_invoices`, `mark_invoice_paid` | 4 | 4 |
| `campaigns` | `list_campaigns`, `send_campaign` (gated) | 5 | 3 |
| `blog` | `list_posts`, `publish_post` | 14 | 13 |

---

## Auth modes

| Token kind | Lifetime | Use case |
|---|---|---|
| **`fav_mcp_*` API key** | Long-lived, revocable | Cursor, Windsurf, Zed, Continue.dev, scripts |
| **`fav_v0_*` partner token** | Per-Vercel-project, scoped | v0 / Vercel install only |
| **OAuth bearer (15-min JWT + 30-day refresh)** | Short-lived | Claude Connectors (Phase 3), ChatGPT Apps |
| **OTP-issued JWT (60 min)** | Short-lived | Interactive humans (merchant portal exchange) |

Marketplace tokens (`fav_v0_*`, OAuth-issued) are hard-blocked from superadmin tools (raw SQL, plan management) regardless of underlying scopes — defence in depth at the request layer, not just per-token RBAC.

---

## Pricing

| Tier | Price | Limits |
|---|---|---|
| **Free** | $0 | 100 customers · 200 bookings/mo · 1k MCP calls/mo |
| **Lite** | $19 / mo | 1 seat · email comms · BYO-AI via your agent |
| **Starter** | $49 / mo | 3 seats · 1M AI credits · WhatsApp + SMS · meeting notes |
| **Enterprise** | Custom | Unlimited seats · multi-location · custom routing |

Full table: [favcrm.io/pricing](https://favcrm.io/pricing).

---

## Issues / contributions

- Bugs in tool behaviour or MCP transport: [open an issue](../../issues/new/choose) here.
- Examples for a new client (Cline, Replit Agent, Roo, etc.): PRs welcome under [`examples/`](./examples).
- Server bugs / new tool requests / commercial questions: [dev@favcrm.io](mailto:dev@favcrm.io).

---

## Links

- [favcrm.io](https://favcrm.io) — landing page
- [favcrm.io/integrations/vercel](https://favcrm.io/integrations/vercel) · [/cursor](https://favcrm.io/integrations/cursor) · [/chatgpt](https://favcrm.io/integrations/chatgpt) — per-platform install guides
- [favcrm.io/developers](https://favcrm.io/developers) — full developer docs
- [favcrm.io/pricing](https://favcrm.io/pricing) — pricing matrix
- [favcrm.io/privacy-policy](https://favcrm.io/privacy-policy) · [/terms-of-use](https://favcrm.io/terms-of-use)

## License

This repo (docs + examples) is MIT — see [`LICENSE`](./LICENSE). The hosted MCP server is proprietary FavCRM SaaS; install requires a FavCRM account.
