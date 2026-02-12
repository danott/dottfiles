---
name: pr
description: Create a pull request with a narrative about human impact
disable-model-invocation: true
---

# Pull Request

1. Identify the base branch (main or master)
2. Review ALL commits on this branch since it diverged from base — not just the latest
3. Push the branch if it hasn't been pushed yet (`git push -u origin HEAD`)
4. Create a pull request with `gh pr create`:
   - **Title**: emoji + one sentence on the human impact of this change
   - **Body**: a narrative rollup telling the story of how these changes make a real difference for people — not a list of commits, not a checklist

## Writing the body

- Use human-centered language: who benefits and how
- Tell the story of the branch as a whole — synthesize, don't enumerate
- No boilerplate sections, no checkboxes, no "## Test Plan"
- Keep it concise but meaningful

## Format

```
gh pr create --title "<emoji> <Impact sentence>" --body "$(cat <<'EOF'
<Narrative about what this means for people who use the software.
How it changes their experience. Why it matters.>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
