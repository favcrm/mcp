# Comms Approval Patterns

## Direct Sends Are Forbidden

Do not call tools like:

- `send_message`
- `send_whatsapp_message`
- `send_test_campaign`
- `send_campaign`

Use:

```bash
favcrm tool describe request_send_approval
favcrm tool call request_send_approval '{"actionType":"send_message","summary":"...","payload":{}}'
```

## Approval Summary

Include:

- channel
- recipient or segment
- recipient count
- draft message
- business reason
- any dynamic fields

## Bulk Send Gate

Before requesting approval for bulk sends:

1. Show total recipients.
2. Show 3-row preview.
3. Confirm exclusions or filters.
4. Ask for explicit approval.

