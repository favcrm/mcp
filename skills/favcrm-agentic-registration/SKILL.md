---
name: favcrm-agentic-registration
description: Use when a new user wants to register for FavCRM from inside an MCP client, create a FavCRM workspace, request or verify signup OTP, receive a fav_mcp_* API key, or continue setup after agentic registration.
---

# FavCRM Agentic Registration

Use this skill when a new user wants to sign up for FavCRM without leaving an MCP client. The real product flow is the no-auth MCP tool pair `register_organisation_request` -> `register_organisation_verify`.

## Operating Rules

- Primary MCP path is `register_organisation_request` followed by `register_organisation_verify`.
- When operating through a shell, the `favcrm` CLI supports the same no-auth flow with `favcrm signup request` and `favcrm signup verify`.
- Treat `/v6/dev/signup` and `/v6/dev/verify` as REST sandbox fallback/docs only.
- Never ask the user to paste the API key into a repo, prompt history file, shared config, or source code.
- If the user already has a FavCRM account, tell them to sign in and create an MCP key from portal settings.

## Required Inputs

- `email`: owner email that receives the 6-digit code.
- `organisationName`: business or brand name.

## Optional Inputs

- `industry`: one of `beauty`, `fitness`, `tutoring`, `retail`, `hospitality`, `services`, `other`.
- `country`: ISO 3166-1 alpha-2 country code, such as `HK`, `US`, `GB`.
- `timezone`: IANA timezone, such as `Asia/Hong_Kong`.

## Standard Flow

1. Collect required inputs and optional fields if known.
2. Call `register_organisation_request`.
3. Tell the user to check the masked email for the 6-digit code.
4. When the user provides the code, call `register_organisation_verify` with `requestId` and `code`.
5. Return the `loginUrl`, workspace IDs if useful, and secure key handling guidance.
6. Tell the user to set the API key as the MCP Bearer token or environment variable for future calls. If using the CLI, `favcrm signup verify` saves the key by default unless `--no-save` is used.

Read `references/agentic-registration-flow.md` for exact call shapes and failure handling.
