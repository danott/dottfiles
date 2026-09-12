---
description: Manage or update the linked Things task (reschedule, complete, summarize, etc.)
---

Find the Things ID by looking for `Things ID:` in the workspace's CLAUDE.md.

Use the native `things` CLI to manage the task. Pick `todo` or `project` based on the `Kind:` line in CLAUDE.md.

| Action | Command |
|--------|---------|
| Schedule | `things todo update <id> --when YYYY-MM-DD` |
| Deadline | `things todo update <id> --deadline YYYY-MM-DD` |
| Complete | `things todo complete <id>` |
| Cancel | `things todo cancel <id>` |
| Add tags | `things todo update <id> --add-tags Tag1,Tag2` |
| Append notes | `things todo update <id> --append-notes "text here"` |

`--when` also accepts: `today`, `tomorrow`, `evening`, `someday`, `anytime`.
Convert natural-language dates to YYYY-MM-DD. Use `date +%Y-%m-%d` for today.

For projects, swap `todo` for `project` (e.g. `things project update <id> --append-notes "..."`).

When appending notes (e.g. summarizing work), write like you're leaving a note for a coworker. A few useful sentences — no IDs, metadata, or JSON.

The user said: $ARGUMENTS
