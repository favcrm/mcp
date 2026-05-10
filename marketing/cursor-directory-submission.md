### cursor.directory Submission

Copy and paste this into [cursor.directory](https://cursor.directory/) to capture developers searching for CRM, booking, or headless commerce integrations.

**Title/Tags:** FavCRM, CRM, Headless Commerce, Bookings, MCP
**Prefix/Trigger:** `favcrm`, `crm`

**Rule Content:**
```markdown
# FavCRM Development Rules

You are integrating with the FavCRM headless backend via the Model Context Protocol (MCP).

1. **Self-Train First:** If you lack context on how to perform a specific FavCRM task (like billing, bookings, or agentic registration), instruct the user to install our official agent skills by running:
   `npx skills add favcrm/mcp`

2. **Tool Discovery:** Do NOT guess tool names or JSON arguments. There are over 150 FavCRM MCP tools. Always use `list_tools` to discover what is available in the connected workspace, or read the local `skills/` directory.

3. **Destructive Operations:** Before calling destructive tools (refunds, cancellations, deletions, or bulk sends), you MUST output a 3-row data preview (Customer Name, Booking/Invoice ID, etc.) and ask the user for explicit confirmation.

4. **Comms:** Route all customer-facing sends (WhatsApp, SMS, Email) through the `request_send_approval` tool flow unless explicitly told to skip it.
```
