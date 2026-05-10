# Sales Ops Flow Patterns

## Discovery

```bash
favcrm tool describe list_deals
favcrm tool describe update_deal_stage
favcrm tool describe list_tasks
favcrm tool describe create_task
favcrm tool describe update_task
favcrm tool describe list_my_companies
favcrm tool describe switch_company
```

## Move Deal

1. List/find deal.
2. Show current stage, value, owner, and customer.
3. Confirm target stage.
4. Call update stage tool.
5. If won, create onboarding task or invoice when requested.

## Manage Task

Before changing another person's task, confirm:

- task title
- assignee
- due date
- priority
- requested change

## Switch Workspace

1. Call `list_my_companies`.
2. Ask user to confirm target company by name.
3. Call `switch_company`.
4. State all future calls use new workspace.

