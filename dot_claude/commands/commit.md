---
description: Review staged and unstaged changes, then commit in logical units
argument-hint: [optional scope or message hint]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

Current state:

- Status: !`git status --short`
- Staged diff: !`git diff --cached --stat`
- Unstaged diff: !`git diff --stat`
- Recent commits (match this style): !`git log --oneline -10`

Commit the current work. $ARGUMENTS

Rules:

- Group changes into logical commits. Don't dump everything into one commit if it
  spans unrelated concerns -- stage selectively instead.
- Match the subject-line style of the recent commits above.
- Subject in the imperative mood, no trailing period. Body only when the _why_
  isn't obvious from the diff.
- Never `git add -A` blindly -- list what you're staging and why.
- Don't push. Don't amend anything already pushed.
- If the repo is on its default branch and this looks like feature work, say so
  and ask before committing.
