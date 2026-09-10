---
name: starting-work
description: Use when cloning a repo, or when I say I want to work on an issue -- either an existing one with a number like #412, or a new one that needs creating. Covers the ~/git/<org>/<repo> clone layout and deriving the branch name from the issue title.
---

# Starting work

Two entry points: cloning a repo, and turning an issue into a checked-out branch.
They compose -- if an issue needs a repo that isn't cloned yet, clone it first.

## Cloning

Repos live at `~/git/<org>/<repo>`, where `<org>` is the second-to-last path
segment of the URL. `wcl` clones into the **current directory**, so the org
directory must exist and be the CWD first:

```bash
mkdir -p ~/git/junegunn
cd ~/git/junegunn
wcl https://github.com/junegunn/fzf
```

That lands you in `~/git/junegunn/fzf/<default-branch>` -- `wcl` creates the bare
repo at `<repo>/repo.git` and a worktree per branch alongside it, named after the
branch it holds.

Parsing the org out of either URL form:

| URL                                   | Org        | Repo  |
| ------------------------------------- | ---------- | ----- |
| `https://github.com/junegunn/fzf`     | `junegunn` | `fzf` |
| `https://github.com/junegunn/fzf.git` | `junegunn` | `fzf` |
| `git@github.com:junegunn/fzf.git`     | `junegunn` | `fzf` |

Before cloning, check `~/git/<org>/<repo>` doesn't already exist -- `wcl` aborts if
the target directory is present. If it does exist, `cd` into its default-branch
worktree instead of re-cloning.

## Working on an existing issue

Given an issue number (`#412`, ...):

1. Fetch the title with `gh issue view <number> --json title`.
2. Derive the branch name (algorithm below) and check it out -- don't ask first.
   Report the name you used.
3. Identify the repo. If the CWD is inside a repo, use it. If not, ask which repo
   -- don't guess.
4. Branch from an up-to-date default branch (`main` on new repos, `master` on
   older ones -- read it, don't assume):

   ```bash
   wco main
   git pull
   wco 412_multiple_pods_in_bad_state
   ```

   `wco` creates the branch from current `HEAD`, so the `wco main; git pull`
   prologue is what makes the branch point at fresh `origin/main`. Never skip
   it, and never branch off whatever worktree happens to be current.

## Branch name derivation

`<issue-number>_<slug>`, where the slug comes from the issue title. With no issue,
use the slug alone.

1. Lowercase it.
2. Replace every non-alphanumeric run with a single space -- this keeps word
   boundaries, so `v1.11.3` -> `v1 11 3` and `multi-tenant` -> `multi tenant`.
3. Drop the articles `a`, `an`, `the` as whole words, anywhere in the string.
4. Trim and collapse whitespace.
5. Join the remaining words with `_`.
6. Cap the **slug** at 50 characters, breaking on a word boundary -- add whole
   words until the next one would exceed 50, then stop. Never cut mid-word.
7. Prefix the issue number with `_`. The number is not counted against the 50.

Worked examples:

| Issue  | Title                                                                     | Branch                                               |
| ------ | ------------------------------------------------------------------------- | ---------------------------------------------------- |
| `#39`  | `Multiple pods in a bad state.`                                           | `39_multiple_pods_in_bad_state`                      |
| `#88`  | `Upgrade the CoreDNS deployment to v1.11.3`                               | `88_upgrade_coredns_deployment_to_v1_11_3`           |
| `#201` | `Investigate intermittent NFS mount failures on the diva-h2 worker nodes` | `201_investigate_intermittent_nfs_mount_failures_on` |

The third case truncates: adding `_diva` would take the slug to 51, so it stops at 46. A dangling word like the trailing `on` is expected -- don't hand-tune the slug
to read better, keep the derivation mechanical and reproducible.

## Working on a new issue

1. Ask whatever you need to write a sensible title -- what's broken or being
   built, which service/repo, and any issue fields the repo's template requires.
   Ask in one batch, not one question at a time.
2. Propose the title and the repo, and **wait for my confirmation**. Creating an
   issue is outward-facing and not undoable.
3. Create it with `gh issue create`.
4. Take the returned number and follow _Working on an existing issue_ from step 2
   -- derive the branch from the title as created, not from your draft.

## Rules

- Create the branch and worktree without confirming the name first. Tell me what
  you created; I will rename it if I don't like it.
- Never create an issue without explicit confirmation of title + repo.
- `wco` exits non-zero on a clean create (it reports `No stash entries found`
  after checking out). Don't chain anything after it with `&&`, and don't read
  that exit code as a failure -- verify with `git worktree list` instead.
- `wco` sanitises branch names to `[a-zA-Z0-9_-]` and names the worktree
  directory after the result. A correctly derived slug is already safe; if
  sanitisation would change your branch name, the derivation was wrong.
- If `git pull` on the default branch is not a fast-forward, stop and tell me
  rather than merging or rebasing.
