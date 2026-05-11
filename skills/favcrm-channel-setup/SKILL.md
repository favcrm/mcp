---
name: favcrm-channel-setup
description: Use when checking or connecting FavCRM communication channels, especially WhatsApp Business Embedded Signup from an MCP client or the favcrm CLI.
---

# FavCRM Channel Setup

Use this skill when a merchant asks to connect WhatsApp Business or diagnose whether a communication channel is ready.

## Operating Rules

- Check current state first with `get_whatsapp_connection_status`.
- Create a browser handoff only when WhatsApp is not connected or the user explicitly wants to reconnect.
- Use `create_whatsapp_connect_link` for Meta Embedded Signup. Meta requires a browser interaction; the agent cannot complete this fully headlessly.
- After the user finishes the browser flow, call `get_whatsapp_connection_status` again.
- For plan or module blockers, call `check_plan_operation` and show any returned upgrade action.

## CLI Flow

```bash
favcrm whatsapp status
favcrm whatsapp connect --mode cloud-api
favcrm whatsapp status
```

Use `--mode coexistence` only when the user is connecting a WhatsApp Business App number that should coexist with Cloud API.

## MCP Flow

1. Call `get_whatsapp_connection_status`.
2. If not connected, call `create_whatsapp_connect_link` with `onboardingMode`.
3. Ask the user to open the returned `url` in a browser.
4. When they confirm completion, call `get_whatsapp_connection_status`.
5. Report WABA ID, phone number ID, verified name, and any pending session state.

## Failure Handling

- Expired session: create a new connect link.
- Browser flow abandoned: keep the pending session visible and ask the user to retry.
- Plan/module blocked: call `check_plan_operation` for module `whatsapp` and surface upgrade instructions.
