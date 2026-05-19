---
name: favcrm-survey-operator
description: Use for FavCRM survey creation, publishing, public or token links, invitations, response review, survey stats, and response-triggered automation.
---

# FavCRM Survey Operator

Use this skill when a merchant asks to create a feedback form, edit survey questions, publish or close a survey, share public links, create token invitations, review responses, inspect invitation status, or attach follow-up automation to survey responses.

## Operating Rules

- Use FavCRM tools only through the available MCP client or the `favcrm` CLI.
- Discover before acting: `favcrm tool list`, `favcrm tool describe <name>`, then `favcrm tool call <name> '{...}'`.
- Treat invitation tokens as one-time secrets. Old invitation history must not expose reusable tokens.
- Before archiving a survey or replacing all question blocks, show the survey title, status, response count, and intended change, then ask for confirmation.
- For customer-facing messages after survey responses, use the comms approval flow. Do not send directly.

## Standard Flow

1. List or fetch the target survey with `list_surveys` or `get_survey`.
2. For a new survey, call `create_survey` with ordered `questionBlocks`; keep status `draft` unless the merchant explicitly wants immediate publishing.
3. Use `update_survey` for title, slug, status, visibility, settings, open/close dates, and full question block edits.
4. Use `get_survey_stats`, `get_survey_responses`, and `list_survey_invitations` to review performance and invited-member progress.
5. Use `create_survey_invitation` for token-auth links; copy/show only the token returned by that creation call.
6. Use `list_survey_workflows` and `upsert_survey_workflow` for response-triggered follow-up automation.

## Common Tool Set

- Read: `list_surveys`, `get_survey`, `get_survey_stats`, `get_survey_responses`, `list_survey_invitations`, `list_survey_workflows`
- Write: `create_survey`, `update_survey`, `create_survey_invitation`, `upsert_survey_workflow`, `archive_survey`

## Survey Block Guidance

- Use stable block IDs. Generate UUID-like IDs if the merchant does not provide them.
- Prefer clear labels and optional descriptions over long labels.
- For single-choice and multi-choice questions, include option objects with `id`, `label`, and `value`.
- For NPS, rating, email, and phone fields, use block `type` values that match the portal: `nps`, `rating`, `email`, `phone`.
- Preserve existing blocks when only editing publishing settings.
