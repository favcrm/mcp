# FavCRM Agent Skills

Public agent workflow skills for using FavCRM from MCP-compatible clients and merchant runtimes.

These packages teach agents how to perform real CRM work with the FavCRM MCP server and the `favcrm` CLI. They are written as portable `SKILL.md` packages so agents can inspect them directly, while FavCRM runtimes install vetted versions through the platform skill pipeline.

## Skills

| Skill | Use when |
|---|---|
| `favcrm-booking-operator` | Service setup, availability, bookings, cancellations, no-shows, reminders, and daily booking operations. |
| `favcrm-customer-lifecycle` | Customer search, member profiles, tags, tiers, loyalty, segments, onboarding, retention, and customer 360 summaries. |
| `favcrm-comms-approval` | Drafting, validating, and approval-gating WhatsApp, SMS, email, inbox replies, broadcasts, and campaigns. |
| `favcrm-billing-commerce` | Invoices, payments, products, orders, promotions, subscriptions, overdue follow-up, and commerce operations. |

## Runtime Model

Public source lives here. FavCRM merchant runtimes do not pull arbitrary GitHub content at boot.

1. FavCRM imports a vetted repo ref/path into the platform skill registry.
2. The package is stored as an immutable platform skill version in DB/R2.
3. Merchants opt in to selected skills.
4. Runtime sidecars sync enabled skills from `/v6/internal/assistant/skills` into `/data/skills`.

## Agent Safety

All skills use the same safety baseline:

- Discover before acting with `favcrm tool list` and `favcrm tool describe <name>`.
- Do not guess tool names or JSON argument keys.
- Show count and a 3-row preview before bulk sends, refunds, deletes, voids, or cancellations.
- Route all customer-facing sends through `request_send_approval`.
- Never ask the merchant for API keys inside a FavCRM runtime.

