---
name: favcrm-billing-commerce
description: Use for invoices, payments, products, orders, promotions, subscriptions, overdue follow-up, and commerce operations in FavCRM.
---

# FavCRM Billing Commerce

Use this skill for invoices, payments, products, orders, promotions, subscriptions, overdue follow-up, payment reminders, and commerce operations.

## Operating Rules

- Ground every invoice, order, subscription, or payment claim with FavCRM data.
- Use `favcrm tool list` and `favcrm tool describe <name>` before unfamiliar billing or commerce tools.
- For plan, quota, permission, or upgrade questions, call `get_plan_status`, `check_plan_operation`, and `list_plan_options` before advising. Only call `create_plan_upgrade_link` after explicit user confirmation.
- Treat refunds, voids, cancellations, payment recording, and subscription changes as sensitive mutations.
- Show count and 3-row preview before bulk billing actions.
- Use the comms approval flow for overdue reminders or payment chase messages.

## Standard Flow

1. Identify the customer, invoice, order, product, promotion, or subscription.
2. Fetch the current record before proposing a change.
3. Preview sensitive mutations and ask for explicit confirmation.
4. For reminders, draft the message and request approval rather than sending directly.
5. Report the resulting status and record IDs after confirmed writes.

Read `references/billing-commerce-flows.md` for concrete CLI patterns.
