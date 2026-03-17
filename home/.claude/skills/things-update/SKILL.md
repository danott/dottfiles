---
description: Write a result back to the Things task
---

Your job is to update the linked Things task with a human-readable summary.

First, find the Things ID by looking for `Things ID:` in the workspace's CLAUDE.md file.

1. Review the conversation so far
2. Write a concise summary of findings, decisions, or next steps
3. Run `update-things` with your summary:

```
update-things <things-id> 'append-notes=\n\n---\n\nYour summary here'
```

IMPORTANT: The append-notes value must be your written summary — a few sentences a human would find useful.
Do NOT pass IDs, metadata, or JSON. Write like you're leaving a note for a coworker.

If the user provided arguments to this command, use those as the summary: $ARGUMENTS
