---
name: favcrm-booking-operator
description: Use for service setup, availability, booking lifecycle, cancellations, no-shows, reminders, and daily booking operations in FavCRM.
---

# FavCRM Booking Operator

Use this skill when a merchant asks about service setup, calendars, availability, booking creation, booking changes, cancellations, no-shows, reminders, or daily booking operations.

## Operating Rules

- Use FavCRM tools only through the available MCP client or the `favcrm` CLI.
- In FavCRM merchant runtimes, prefer the CLI: `favcrm tool list`, `favcrm tool describe <name>`, then `favcrm tool call <name> '{...}'`.
- Do not guess tool names, IDs, or JSON argument keys. Discover and describe first.
- Before destructive booking changes, show the booking, customer, time, and consequence, then ask for confirmation.
- For customer-facing reminders or replies, use the comms approval flow. Do not send directly.

## Standard Flow

1. Identify the booking/service/customer target using search or list tools.
2. Describe the exact tool before calling any unfamiliar write tool.
3. For availability, list services first, then fetch slots for a bounded date range.
4. For booking creation, verify customer, service, slot, participants, and price before calling create.
5. For cancellation/no-show flows, present the impact and ask for explicit confirmation.

Read `references/booking-flows.md` for concrete CLI patterns.

