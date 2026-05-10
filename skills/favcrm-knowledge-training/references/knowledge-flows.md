# Knowledge Training Patterns

## Discovery

```bash
favcrm tool describe list_knowledge_documents
favcrm tool describe scrape_knowledge_url
favcrm tool describe add_knowledge_text
favcrm tool describe delete_knowledge_document
```

## Add URL

1. Confirm URL and title.
2. Call `scrape_knowledge_url`.
3. Check status with `list_knowledge_documents`.
4. If failed, ask for pasted text or alternate URL.

## Add Pasted Text

1. Ask for concise title.
2. Call `add_knowledge_text`.
3. Confirm document ID and status.

## Prune Knowledge

Before deletion show:

- document ID
- title/name
- status
- reason for deletion

Then ask explicit confirmation.

