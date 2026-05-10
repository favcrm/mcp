# Content Flow Patterns

## Discovery

```bash
favcrm tool list
favcrm tool describe list_posts
favcrm tool describe create_post
favcrm tool describe append_post_block
favcrm tool describe update_post
```

## Draft Blog Post

1. Confirm title, target reader, key points, CTA, and language.
2. Call `create_post` with draft status.
3. Add blocks with `append_post_block`.
4. Summarize draft structure for merchant review.

## Publish Gate

Before publishing show:

- title
- slug
- post type
- current status
- next status
- public visibility impact

Then call `update_post` only after explicit approval.

## AI Cover Image

1. Confirm visual direction.
2. Describe image generation tools.
3. Generate image.
4. Attach cover only after successful job result.

