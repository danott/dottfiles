---
name: commit
description: Create a git commit with emoji prefix and why-focused message
disable-model-invocation: true
---

# Commit

1. Stage all changes (prefer specific files over `git add -A`)
2. Run `git diff --cached` to analyze what's staged
3. Craft a commit message:
   - **Subject**: emoji + one sentence about WHY this change exists (not what changed)
   - **Body**: what this unlocks, alternatives you considered, why this approach was chosen
   - Never describe what changed — the diff speaks for itself
4. After committing, check the current branch. If it is NOT main or master, push automatically.

## Subject line examples

- `🔒 Secure personal information`
- `🍼 Provide new parents with tools`
- `🧹 Reduce friction for future changes`
- `📬 Let subscribers know when plans change`

## Format

```
git commit -m "$(cat <<'EOF'
<emoji> <Why this change exists>

<What this unlocks or enables. Alternatives considered. Why this approach.>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```
