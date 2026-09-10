# Environment

## Source control

Repos live at `~/git/<org>/<repo>`, as a bare repo plus one worktree per branch.
See the `starting-work` skill before cloning or branching.

## Dotfiles

Managed by chezmoi. Never edit a tracked file under `$HOME` directly. See the
`chezmoi-dotfiles` skill.

## Shell

zsh with oh-my-zsh. Custom aliases and functions live in `~/.config/zsh/*.zsh`.
Check there before claiming a command does not exist.

## Agents and the Task tool

When running in tmux, always use foreground agents. Do NOT set
`run_in_background: true`, so I can watch progress across panes.

# Process

## Working preferences

- Answer the question asked. No preamble, no summary of what you are about to do.
- Show me the command output that backs a claim. "Tests pass" without the run is
  not evidence.
- Match the surrounding style of whatever file you are editing. Existing code is
  the spec for comment density, naming and idiom.
- Shell scripts: `set -eu`, quote expansions, prefer `[[ ]]`. Match the style in
  the dotfiles repo's `run_*.sh` scripts.
- Do not commit or push unless I ask.
- Ask before anything destructive or outward-facing: force-push, resource
  deletion, `chezmoi apply` over uncommitted work.

## Minimising permission prompts

- My permissions live in `~/.claude/settings.json` (curated baseline) and
  `~/.claude/settings.local.json` (approvals accumulated on this machine). Read
  them at the start of a session, and again after compaction, so you know what
  will match.
- Format commands to match those patterns rather than triggering a prompt.
- Prefer separate parallel Bash calls when the commands are independent. Group
  into one compound command only when the steps genuinely depend on each other.

## Pull requests

Do NOT include rollout plans or test plans in PR descriptions.

# Output style

## Unicode

Avoid unicode as much as possible except when making diagrams. Prefer ASCII arrows outside of diagrams (->, =>).

NEVER use unicode quotes. Use standard double quotes (") when quoting inline text.
NEVER use curly or angle quotation marks. Use two backticks (``) for the opening double quotes and two standard quotes for the closing double quotes ('') when quoting a verbatim excerpt.
NEVER use emdashes. Use a double hyphen instead (--) and space it with a single space.
NEVER use tabs. Always spaces.

## Markdown

If `prettier` is installed, format `.md` files.
