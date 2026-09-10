---
name: chezmoi-dotfiles
description: Use when changing any dotfile or shell config under $HOME (.zshrc, .vimrc, .gitconfig, .tmux.conf, .config/**, .claude/**) -- edits must go through the chezmoi source tree, never the live file
---

# Editing chezmoi-managed dotfiles

Dotfiles under `$HOME` are **generated artifacts**. Editing them directly gets the
change silently reverted on the next `chezmoi apply`.

## Workflow

1. Confirm the file is managed and find its source:

   ```bash
   chezmoi source-path ~/.zshrc
   ```

   If that errors, the file is unmanaged -- edit it directly and consider whether
   it should be tracked instead.

2. Edit the **source** file, not the target.

3. Preview, then apply:

   ```bash
   chezmoi diff
   chezmoi apply
   ```

4. New files get added to the source tree with `chezmoi add <path>`, or authored
   directly in the source tree using the naming convention below.

## Source naming convention

| Source                             | Target                                   |
| ---------------------------------- | ---------------------------------------- |
| `dot_zshrc`                        | `~/.zshrc`                               |
| `dot_config/zsh/foo.zsh`           | `~/.config/zsh/foo.zsh`                  |
| `*.tmpl` suffix                    | Go-template rendered on apply            |
| `run_once_<n>-name.sh`             | Script, runs once per machine            |
| `run_onchange_<n>-name.sh`         | Script, re-runs when its contents change |
| `private_`, `executable_` prefixes | Set mode 0600 / 0700                     |

`.chezmoiexternal.toml` pulls in upstream repos (oh-my-zsh, powerlevel10k,
vim-plug). Don't vendor those by hand.

## Rules

- Never `chezmoi apply` when the target has uncommitted local edits you haven't
  looked at -- `chezmoi diff` first and confirm the direction of the change.
- Machine-specific or secret-bearing files stay out of the source tree; add them
  to `.chezmoiignore.tmpl`, which also carries the Linux/macOS split.
- Shell changes need a syntax check before apply: `zsh -n <source-file>`.
