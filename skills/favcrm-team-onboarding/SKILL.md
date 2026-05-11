---
name: favcrm-team-onboarding
description: Use when inviting a teammate to FavCRM, generating a one-time team invite token, accepting an invite, verifying an emailed invite OTP, or issuing an MCP API key for an invited team member.
---

# FavCRM Team Onboarding

Use this skill when a merchant wants to add another human or agent-operated team member to a FavCRM workspace.

## Operating Rules

- To invite a teammate, use `create_team_member_invite` from an authenticated owner or manager context.
- To accept an invite, use the no-auth pair `accept_team_invite_request` -> `accept_team_invite_verify`.
- Never expose the full returned API key unless the user explicitly needs to configure a client. Prefer storing it in the MCP client, CLI config, or environment variable.
- Do not invent roles. Use `staff` by default, or `manager` only when the user asks for elevated access.

## CLI Flow

```bash
favcrm team invite create --email teammate@example.com --role staff
favcrm team invite accept-request --token <invite-token>
favcrm team invite accept-verify --token <invite-token> --code <code>
```

## MCP Flow

1. Call `create_team_member_invite` with `email`, optional `name`, and `role`.
2. Give the invite token or invite link to the invited user.
3. Call `accept_team_invite_request` with `token`.
4. Ask the invited user for the 6-digit code from email.
5. Call `accept_team_invite_verify` with `token`, `code`, and optional `name`.
6. Return secure key handling guidance. The API key is shown once.

## Failure Handling

- Expired invite: ask an authenticated manager to create a new invite.
- Wrong code: retry `accept_team_invite_verify` with the corrected 6-digit code.
- Role/permission denied: call `check_plan_operation` or ask an owner/manager to perform the invite.
