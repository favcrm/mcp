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

## Campaign Audience Exclusions

Campaign exclusions narrow a base audience. They do not replace consent, opt-out, or channel-eligibility checks.

- `accountIds` contains FavCRM customer account IDs, not email addresses or phone numbers. Resolve them with `search_members`.
- `campaignIds` contains previous campaign IDs. Resolve them with `list_campaigns` and confirm the intended campaign and status with the merchant.
- The rules use OR semantics: a recipient matching any account or previous-campaign exclusion is omitted.
- Duplicate IDs are normalized. The limits are 1,000 account IDs and 50 campaign IDs per campaign.
- On `update_campaign`, pass empty arrays to clear saved exclusions.

Create or update a draft with the confirmed IDs:

```bash
favcrm tool call create_campaign '{"name":"September offer","channel":"email","recipientSource":"all","audienceExclusions":{"accountIds":["ACCOUNT_ID"],"campaignIds":["PREVIOUS_CAMPAIGN_ID"]},"channelConfig":{"subject":"September offer","htmlBody":"<p>Offer details</p>"}}'
```

Before requesting approval:

1. Call `get_campaign` and verify the saved base audience and exclusion IDs.
2. Call `validate_campaign` immediately before approval and report the final contactable count and content preview.
3. Call `request_send_approval` with `actionType="send_campaign"`, `payload={"campaignId":"..."}`, and a summary containing the base audience, confirmed exclusions, final count, content, and schedule.
