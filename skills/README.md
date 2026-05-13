# FavCRM Agent Skills

Public agent workflow skills for using FavCRM from MCP-compatible clients and merchant runtimes.

These packages teach agents how to perform real CRM work with the FavCRM MCP server and the `favcrm` CLI. They are written as portable `SKILL.md` packages so agents can inspect them directly, while FavCRM runtimes install vetted versions through the platform skill pipeline.

## Skills

To install any of these skills for your local AI agent (Cursor, Windsurf, Claude Code), use the `npx skills add` command. You can install all skills together via `npx skills add favcrm/mcp`, or install them individually:

| Skill | Install Command | Use when |
|---|---|---|
| `favcrm-agentic-registration` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-agentic-registration` | New user registration, workspace creation, signup OTP, and first `fav_mcp_*` API key from inside an MCP client. |
| `favcrm-booking-operator` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-booking-operator` | Service setup, availability, bookings, cancellations, no-shows, reminders, and daily booking operations. |
| `favcrm-team-onboarding` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-team-onboarding` | Team invites, invite token acceptance, invite OTP verification, and invited-user MCP API keys. |
| `favcrm-channel-setup` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-channel-setup` | WhatsApp Business connection status, Meta Embedded Signup handoff, and channel readiness checks. |
| `favcrm-customer-lifecycle` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-customer-lifecycle` | Customer search, member profiles, tags, tiers, loyalty, segments, onboarding, retention, and customer 360 summaries. |
| `favcrm-comms-approval` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-comms-approval` | Marketing campaigns, customer reactivation, promotions, broadcasts, WhatsApp, SMS, email, inbox replies, and approval-gated sends. |
| `favcrm-billing-commerce` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-billing-commerce` | Invoices, payments, products, orders, promotions, subscriptions, overdue follow-up, and commerce operations. |
| `favcrm-content-publisher` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-content-publisher` | Blog posts, CMS blocks, landing-page content, AI images, publishing, and content updates. |
| `favcrm-sales-ops` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-sales-ops` | Deals, pipeline stages, tasks, follow-ups, owners, workspace switching, and operational handoffs. |
| `favcrm-knowledge-training` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-knowledge-training` | Train the FavCRM AI agent from URLs or text, list knowledge docs, check status, and prune stale content. |
| `favcrm-business-reporting` | `npx skills add https://github.com/favcrm/mcp/tree/main/skills/favcrm-business-reporting` | Dashboards, weekly snapshots, KPI summaries, revenue, bookings, invoices, subscriptions, and risk reports. |

## Runtime Model

Public source lives here. FavCRM merchant runtimes do not pull arbitrary GitHub content at boot.

1. FavCRM imports a vetted repo ref/path into the platform skill registry.
2. The package is stored as an immutable platform skill version in DB/R2.
3. Merchants opt in to selected skills.
4. Runtime sidecars sync enabled skills from `/v6/internal/assistant/skills` into `/data/skills`.

## Agent Safety

All skills use the same safety baseline:

- For merchant runtime skills, discover before acting with `favcrm tool query_favcrm_platform '{"query":"..."}'`, then `favcrm tool describe <name>` for exact arguments.
- For merchant-specific facts, use `favcrm tool query_company_knowledge '{"query":"..."}'` and cite the returned source document ID.
- For `favcrm-agentic-registration`, use the no-auth MCP tools directly or the `favcrm signup` CLI commands.
- For team invite acceptance, use the no-auth `accept_team_invite_request` / `accept_team_invite_verify` pair or `favcrm team invite accept-*`.
- Do not guess tool names or JSON argument keys.
- Show count and a 3-row preview before bulk sends, refunds, deletes, voids, or cancellations.
- Route all customer-facing sends through `request_send_approval`.
- Never ask the merchant for API keys inside a FavCRM runtime.
