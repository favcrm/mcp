---
name: favcrm-knowledge-training
description: Use for training the FavCRM AI agent with URLs or pasted text, listing knowledge documents, checking ingestion status, and pruning outdated knowledge.
---

# FavCRM Knowledge Training

Use this skill when a merchant wants the FavCRM AI agent to learn policies, services, FAQs, pricing, scripts, SOPs, or website content.

## Operating Rules

- Confirm source ownership or permission before adding content.
- Prefer URLs for public pages and pasted text for private SOPs.
- Use descriptive document names so retrieval can disambiguate.
- Deleting knowledge is destructive. Confirm document ID/title before deletion.
- Do not claim the agent has learned content until status confirms ready or queued.

## Standard Flow

1. Identify source type: URL or pasted text.
2. Confirm title/name and business purpose.
3. Add or scrape document.
4. List/check documents to confirm status.
5. Report document ID, status, and expected retrieval timing.

Read `references/knowledge-flows.md` for exact patterns.

