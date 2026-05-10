# Agentic Registration Flow

## Step 1: Request Code

Call:

```json
{
  "name": "register_organisation_request",
  "arguments": {
    "organisationName": "Stretch + Breathe",
    "email": "owner@example.com",
    "industry": "fitness",
    "country": "HK",
    "timezone": "Asia/Hong_Kong"
  }
}
```

Expected result includes:

- `requestId`
- `expiresAt`
- `maskedEmail`
- `instructions`

Tell the user to check the masked inbox and paste the 6-digit code.

## Step 2: Verify Code

Call:

```json
{
  "name": "register_organisation_verify",
  "arguments": {
    "requestId": "<requestId from step 1>",
    "code": "123456"
  }
}
```

Expected result includes:

- `organisationId`
- `companyId`
- `userId`
- `apiKey`
- `loginUrl`
- `nextSteps`

## Key Handling

Tell the user:

- Use `Authorization: Bearer <apiKey>` for future MCP calls.
- Store the key in an environment variable such as `FAVCRM_API_KEY`.
- Do not commit the key to source control.
- Use `loginUrl` and forgot-password flow to set a portal password.

## Failure Handling

- Existing email: user should sign in at `https://app.favcrm.io` and create an MCP key from settings.
- Expired code: call `register_organisation_request` again.
- Wrong code: ask the user to re-check the email code.
- Rate limit: report the tool summary and wait; do not loop retries.

