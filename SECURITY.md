# Security Policy

## Reporting a vulnerability

Please do not open a public GitHub issue for suspected vulnerabilities.

Report security concerns privately by emailing `security@favcrm.io`. Include:

- Affected repository or service.
- Impact and exploitability.
- Steps to reproduce.
- Logs, request IDs, or timestamps if available.
- Whether any token, customer data, or merchant data may have been exposed.

We aim to acknowledge reports within 3 business days and will coordinate fixes and disclosure based on severity.

## Scope

In scope:

- Public docs or examples that could leak credentials.
- MCP setup guidance that causes unsafe token handling.
- Agent workflows that can perform destructive or external-world actions without clear approval.
- Vulnerabilities in public CLI or setup code.

Out of scope:

- Account support, billing, and feature requests.
- Reports that require access to data you do not own.
- Automated scans without a concrete exploit path.

