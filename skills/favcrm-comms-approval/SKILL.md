---
name: favcrm-comms-approval
description: Use for FavCRM marketing campaigns, customer reactivation, broadcasts, WhatsApp, SMS, email, inbox replies, and approval-gated customer communications.
---

# FavCRM Comms Approval

Use this skill for marketing campaigns, customer reactivation, win-back messages, promotions, inbox replies, WhatsApp, SMS, email, broadcasts, campaign drafts, campaign validation, reminders, and any customer-facing message.

## Operating Rules

- Never send customer-facing messages directly.
- Always use `request_send_approval` for sends, broadcasts, campaigns, reminders, or replies that leave FavCRM.
- Before approval, show recipient/channel/count, draft content, and reason.
- For bulk sends, show count and a 3-row recipient preview before requesting approval.
- Match the merchant's language and tone. Use Traditional Chinese for zh-HK context.

## Standard Flow

1. Ground the recipient, conversation, campaign, or segment.
2. Draft the message.
3. Validate required fields and channel constraints.
4. Request merchant approval with the exact action type, payload, draft, recipients, and summary.
5. Do not claim delivery until FavCRM reports completion.

Read `references/comms-safety.md` for approval payload patterns.
