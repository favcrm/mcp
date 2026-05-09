# Billing And Commerce Patterns

## Discovery

```bash
favcrm tool list
favcrm tool describe list_invoices
favcrm tool describe create_invoice
favcrm tool describe list_orders
favcrm tool describe validate_promotion
```

## Invoice Work

```bash
favcrm invoices list --status overdue
favcrm invoices send <invoice-id>
```

Generic fallback:

```bash
favcrm tool call list_invoices '{"status":"overdue","limit":20}'
```

## Sensitive Mutations

Require explicit confirmation for:

- void invoice
- refund payment
- cancel subscription
- record manual payment
- fulfil or cancel order
- bulk payment reminders

## Overdue Follow-Up

1. List overdue invoices.
2. Show amount, due date, customer, and invoice ID.
3. Draft reminder.
4. Route through `request_send_approval`.

