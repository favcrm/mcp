---
name: favcrm-customer-lifecycle
description: Use for customer search, member profiles, tags, tiers, loyalty, segments, onboarding, retention, and customer 360 summaries in FavCRM.
---

# FavCRM Customer Lifecycle

Use this skill for customer lookup, member records, tags, membership tiers, loyalty, segments, onboarding, retention, reactivation, and customer 360 summaries.

## Operating Rules

- Ground every factual claim in FavCRM data. Search or get records before answering.
- Use `favcrm tool list` and `favcrm tool describe <name>` when the exact tool or schema is unknown.
- Keep list responses bounded unless the merchant asks for an export.
- For bulk tagging, tier changes, points changes, or reactivation campaigns, show count and a 3-row preview before mutation.
- For customer-facing outreach, draft and request approval. Do not send directly.

## Standard Flow

1. Search customers/members with narrow terms or filters.
2. Fetch the profile before summarizing spend, tier, points, bookings, or order history.
3. Confirm identity before applying tags, tier changes, or loyalty changes.
4. For cohorts, build a preview first, then ask for confirmation before bulk actions.

Read `references/customer-flows.md` for concrete CLI patterns.

