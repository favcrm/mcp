# Booking Flow Patterns

## Discovery

```bash
favcrm tool list
favcrm tool describe list_services
favcrm tool describe get_available_slots
favcrm tool describe create_booking
```

## Daily Dashboard

```bash
favcrm bookings list --status confirmed --limit 20
favcrm bookings stats
```

If wrappers are not available, use generic calls:

```bash
favcrm tool call list_bookings '{"status":"confirmed","limit":20}'
```

## Create A Booking

1. Search or create the customer.
2. List services and confirm the intended service.
3. Fetch slots for a specific date or short date range.
4. Confirm the exact slot with the merchant.
5. Call the booking create tool with described schema-compliant JSON.

## Cancellation Or No-Show

Always show a preview before the mutation:

- customer name
- booking ID
- service
- scheduled time
- cancellation/no-show consequence

Then ask for explicit confirmation.

