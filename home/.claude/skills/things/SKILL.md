---
description: Manage the linked Things task (reschedule, complete, tag, etc.)
---

First, find the Things ID by looking for `Things ID:` in the workspace's CLAUDE.md file.

Use `update-things` to manage this Things task.

```
update-things <things-id> <param>=<value> [<param>=<value> ...]
```

| Action | Command |
|--------|---------|
| Schedule | `update-things <things-id> when=YYYY-MM-DD` |
| Deadline | `update-things <things-id> deadline=YYYY-MM-DD` |
| Complete | `update-things <things-id> completed=true` |
| Cancel | `update-things <things-id> canceled=true` |
| Add tags | `update-things <things-id> add-tags=Tag1,Tag2` |
| Append notes | `update-things <things-id> 'append-notes=text here'` |

`when` also accepts: today, tomorrow, evening, someday.
Convert natural language dates to YYYY-MM-DD. Use `date +%Y-%m-%d` for today.

The user said: $ARGUMENTS
