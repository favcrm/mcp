# Customer Lifecycle Patterns

## Discovery

```bash
favcrm tool list
favcrm tool describe search_members
favcrm tool describe get_member_profile
```

## Search And Profile

```bash
favcrm members search alice --limit 5
favcrm members get <account-id>
```

Generic fallback:

```bash
favcrm tool describe create_account
favcrm tool call search_members '{"query":"alice","limit":5}'
favcrm tool call get_member_profile '{"accountId":"..."}'
```

## Create Account / Enroll Member

Create a customer account first. This also creates the primary contact.

```bash
favcrm members create "Ada Lovelace" --email ada@example.com --phone +15550001001
```

Generic fallback:

```bash
favcrm tool call create_account '{"name":"Ada Lovelace","email":"ada@example.com","phone":"+15550001001"}'
```

To create and enroll immediately:

```bash
favcrm tool call create_account '{"name":"Ada Member","enrollMembership":true,"tierId":"<tier-id>"}'
```

For an existing account:

```bash
favcrm tool call enrol_membership '{"accountId":"<account-id>","tierId":"<tier-id>"}'
```

## Customer 360 Summary

Include only grounded fields:

- profile identity
- membership tier
- loyalty balance
- recent bookings
- recent orders/invoices
- tags or segment membership
- open conversations or tickets when available

## Bulk Cohort Changes

Before mutation, show:

- filter used
- total count
- 3-row preview
- exact change to apply
