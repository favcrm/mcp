# FavCRM MCP

[![smithery badge](https://smithery.ai/badge/favcrm/favcrm)](https://smithery.ai/servers/favcrm/favcrm)

> Install snippets, examples, and docs for the [FavCRM](https://favcrm.io) Model Context Protocol server. The server itself is hosted at `https://api.favcrm.io/mcp` — this repo is for client setup and community examples.

156 typed tools — customers, bookings, loyalty, invoices, payments, WhatsApp / SMS / email — exposed via MCP. Works with any agentic client that speaks Streamable HTTP transport.

Public agent skills live in [`skills/`](./skills): portable workflow packages for agentic registration, booking operations, customer lifecycle, comms approval, billing/commerce, content, sales ops, knowledge training, and reporting. They are source-readable for agents and marketing, while FavCRM runtimes install vetted versions through the platform skill registry.

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

Two ways:

**Option A — your agent signs you up (no form, no portal click)**

Connect FavCRM to your client first (see Cursor section below) using a placeholder env var. Then ask your agent:

> "Sign me up for FavCRM. Yoga studio called Stretch + Breathe in Hong Kong."

The agent will:

1. Call `register_organisation_request` — server emails a 6-digit code to you
2. You paste the code back in chat
3. Agent calls `register_organisation_verify` — server returns a fresh `fav_mcp_*` key
4. Agent stores the key and starts working immediately

See [`skills/favcrm-agentic-registration`](./skills/favcrm-agentic-registration) for the portable SKILL.md workflow.

Behind the scenes: 10-min OTP, real email-ownership check, per-IP rate limit (3/hour, 20/day). No phishing surface, no fake demos.

**Option B — sign up the traditional way**

[favcrm.io/signup](https://favcrm.io/signup) → portal → `Settings → MCP Keys` → copy the `fav_mcp_*` value.

Existing FavCRM merchants: same place, no plan upgrade needed for MCP access.

**Free tier (both options):** 100 customers, 200 bookings/month, 1k MCP calls/month, 30-day trial of higher limits.

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

Restart Cursor → `Settings → MCP → favcrm` connects → 156 tools land in chat.

> Why `${env:VAR}` instead of inline? Cursor interpolates env vars at request time so the key never lands in your repo or shared config.

---

## Smithery

[`favcrm.io`](https://smithery.ai/servers/favcrm/favcrm) on Smithery — install via CLI:

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
3. 26 curated tools land in chat (read-mostly + safe writes; destructive ops gated behind confirmation)

---

## Test it

Once your config is live, ChatGPT/Cursor/Claude will list tools automatically. To smoke-test from the command line:

```bash
# Discovery (no auth needed — public-scan endpoint)
curl https://api.favcrm.io/.well-known/mcp/server-card.json | jq '.tools | length'
# → 156

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

156 tools across 22 scopes. Every tool ships with annotations:

- `title` — human-readable label
- `readOnlyHint` — `true` for `list_*` / `get_*` / `search_*` / etc.
- `destructiveHint` — `true` for `delete_*` / `cancel_*` / `void_*` / `refund_*`
- `openWorldHint` — `true` for tools that hit external services (WhatsApp, Stripe, email)
- `idempotentHint` — `true` for `set_*` / `update_*` / `upsert_*` and read-only

Clients can use these to gate destructive calls or estimate cost. The full catalog at `https://api.favcrm.io/.well-known/mcp/server-card.json` is the source of truth — listings here are summaries only.

| Scope | Sample tools | Read-only | Write |
|---|---|---|---|
| `contacts` | `search_members`, `get_member_profile`, `create_account`, `attach_tags` | 5 | 6 |
| `bookings` | `list_services`, `get_available_slots`, `create_booking` | 12 | 15 |
| `membership` | `list_tiers`, `enrol_membership`, `earn_loyalty_points` | 4 | 3 |
| `shop` | `list_products`, `get_order`, `create_order` | 8 | 6 |
| `invoices` | `list_invoices`, `mark_invoice_paid` | 4 | 4 |
| `campaigns` | `list_campaigns`, `send_campaign` (gated) | 5 | 3 |
| `blog` | `list_posts`, `publish_post` | 14 | 13 |

---

## Agent Issue Reports

Agents should call `report_agent_issue` when an MCP-native path is missing, a tool schema is confusing, a tool fails unexpectedly, or they had to fall back to REST/SDK behavior. Include expected behavior, actual behavior, steps tried, relevant tool calls/logs, AI analysis, and clarification questions. FavCRM routes these reports to the platform support queue for triage.

Example:

```bash
favcrm tool call report_agent_issue '{"title":"Missing account creation MCP tool","severity":"high","area":"mcp_tool_missing","expectedBehavior":"Agent can create an account via MCP only.","actualBehavior":"Agent had to use SDK fallback.","stepsTried":["Listed tools","Tried create_contact"],"aiAnalysis":"Account creation exists in backend services but was not exposed in MCP."}'
```

## Plan operations

Agents can inspect and preflight plan access without leaving MCP:

```bash
favcrm tool call get_plan_status '{}'
favcrm tool call check_plan_operation '{"toolName":"create_account"}'
favcrm tool call list_plan_options '{}'
favcrm tool call create_plan_upgrade_link '{"planCode":"favcrm-lite","billingCycle":"monthly","confirm":true}'
```

Use `check_plan_operation` before writes that may hit module, scope, subscription, or quota gates. If the result includes `upgradeAction`, show the user the returned action. Stripe links are only created by `create_plan_upgrade_link` with `confirm=true`.

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
- Agent workflow skills: PRs welcome under [`skills/`](./skills).
- Contribution guidelines: [`CONTRIBUTING.md`](./CONTRIBUTING.md).
- Security reports: please follow [`SECURITY.md`](./SECURITY.md); do not open public vulnerability issues.
- Server bugs / new tool requests / commercial questions: [dev@favcrm.io](mailto:dev@favcrm.io).

---

## Links

- [favcrm.io](https://favcrm.io) — landing page
- [favcrm.io/integrations/vercel](https://favcrm.io/integrations/vercel) · [/cursor](https://favcrm.io/integrations/cursor) · [/chatgpt](https://favcrm.io/integrations/chatgpt) — per-platform install guides
- [favcrm.io/developers](https://favcrm.io/developers) — full developer docs
- [favcrm.io/pricing](https://favcrm.io/pricing) — pricing matrix
- [favcrm.io/privacy-policy](https://favcrm.io/privacy-policy) · [/terms-of-use](https://favcrm.io/terms-of-use)

## Brand assets

Marketplace-ready 1:1 icons with background plate, in [`assets/`](./assets):

| File | Use |
|---|---|
| [`assets/icon.png`](./assets/icon.png) | 512×512 PNG — Cursor / Smithery / mcp.so listing |
| [`assets/favcrm-icon-256-dark.svg`](./assets/favcrm-icon-256-dark.svg) | 1:1 SVG, ink plate, light glyph — most marketplaces |
| [`assets/favcrm-icon-256-light.svg`](./assets/favcrm-icon-256-light.svg) | 1:1 SVG, canvas plate, ink glyph — light-themed UIs |
| [`assets/favcrm-icon-256-dark.png`](./assets/favcrm-icon-256-dark.png) | 256×256 PNG fallback |

All icons are 1:1 aspect ratio with rounded-square plate (48px corner radius on 256-unit grid) and centered "fav." wordmark glyph.

## License

This repo (docs + examples) is MIT — see [`LICENSE`](./LICENSE). The hosted MCP server is proprietary FavCRM SaaS; install requires a FavCRM account.
