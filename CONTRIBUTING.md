# Contributing to FavCRM MCP

Thanks for helping improve the public MCP setup docs, examples, and agent skills.

## What belongs here

- Client setup examples for MCP-compatible tools.
- Fixes to docs, examples, and smoke-test snippets.
- Public agent workflow skills under `skills/`.
- Clear bug reports for hosted MCP behavior when a public reproduction is safe to share.

Server implementation, billing/account questions, and production support requests are handled outside this repository. Email `dev@favcrm.io` for those.

## Before opening an issue

1. Search existing issues.
2. Check the latest README setup for your client.
3. Redact API keys, request IDs that reveal private data, customer data, phone numbers, emails, and merchant-specific payloads.
4. For bugs, include the client, token kind, approximate UTC timestamp, request ID if available, what you ran, what happened, and what you expected.

Do not open public issues for suspected vulnerabilities. Follow `SECURITY.md`.

## Pull requests

Keep PRs focused. A good PR changes one guide, one example, or one skill workflow at a time.

For agent skills, reviewers will check that:

- Required human approvals are explicit for destructive actions.
- External-world actions such as WhatsApp, SMS, email, Stripe, refunds, deletes, and cancellations are clearly gated.
- Tool names and arguments match the public MCP catalog.
- The workflow avoids collecting secrets or customer data in public logs.

## Local checks

This repo has no build step. Before opening a PR:

```bash
grep -R --line-number -E 'fav_(mcp|v0)_[A-Za-z0-9_-]{12,}' README.md examples skills
```

That command should produce no output.

