---
name: favcrm-content-publisher
description: Use for FavCRM blog posts, CMS content blocks, landing-page content, AI-generated images, post publishing, post updates, and content workflows.
---

# FavCRM Content Publisher

Use this skill when a merchant asks to draft, generate, edit, publish, unpublish, or audit FavCRM CMS/blog content.

## Operating Rules

- Discover exact tool schemas before writes: `favcrm tool describe create_post`, `update_post`, `append_post_block`, and image tools.
- Keep drafts as drafts until the merchant explicitly approves publishing.
- For AI-generated images, confirm prompt direction and model choice when the user cares about style.
- Publishing and deleting content are sensitive. Show title, slug, status change, and public impact before action.
- Do not invent CMS block shape. Use the described schema.

## Standard Flow

1. Clarify title, audience, goal, language, CTA, and publish status.
2. Create or find the post.
3. Build content as structured blocks.
4. Generate or attach media only after confirming direction.
5. Preview summary and ask approval before publishing.
6. Report post ID, slug, status, and next action.

Read `references/content-flows.md` for common workflows.

