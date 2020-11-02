# git-cheatsheet version 2.23

## 1. Adding and committing files

There are three different areas where files are stored locally:

1. The working tree where you edit files
2. The staging area or index where files are added
3. The local repository where files are committed

Files that have been added to the staging area are tracked for modifications.

```bash
# Create a new file hello.txt
echo "Hello, world" > hello.txt

# Track it and add it to the staging area
git add hello.txt

# Track and add every files in the current directory
git add .

# Unstage and untrack the file (delete it from the index)
git rm --cached hello.txt

# Delete the file from both the working tree and the index (a commit is required to also delete the file from the local repository)
git rm hello.txt

# Delete all untracked files (files which are not present in the index)
git clean --force

# Commit the modifications to the local repository
git commit --message="added hello.txt"

# Modify hello.txt
echo "Hello, again" >> hello.txt

# Add all tracked files to the staging area and commit the modifications
git commit --all --message="modified hello.txt"

# Access the commit log
git log
```

## 2. Branches

Branches are used to create another line of development, the default branch is the master branch.

Every branch is referenced by its HEAD, which points to the latest commit in that branch. Thus, the branch name is an alias for the latest commit.

HEAD is a pointer which always points to the lastest commit in a branch, when you make a new commit, HEAD is updated to point to the latest commit.

You can move to a specific commit in detached HEAD and create a new branch starting from that commit.

|      Ancestry references      |                           Meaning                           |
|-------------------------------|-------------------------------------------------------------|
| `HEAD~1, HEAD~, HEAD^`        | One commit older than HEAD                                  |
| `HEAD~2, HEAD~~, HEAD^^`      | Two commits older than HEAD                                 |
| `HEAD^1`                      | The first parent of HEAD from the left                      |
| `HEAD^2`                      | The second parent on HEAD from the left if HEAD was a merge |

New commits made while in detached HEAD will not be referenced until a new branch is created. The latest commit hash can still be used to merge commits made while in detached HEAD.

```bash
# Create the branch hotfix starting from the commit referenced by the HEAD pointer
git branch hotfix

# List all the branches
git branch --list

# Switch to the branch hotfix and move the HEAD pointer to the latest commit
git switch hotfix
# --- or ---
git checkout hotfix

# Similar to the previous command but causes a new branch to be created
git switch --create hotfix
# --- or ---
git checkout -b hotfix

# Rename the current branch hotfix to hotfix-2
git branch --move hotfix-2
# --- or ---
git branch --move hotfix hotfix-2

# Delete the branch hotfix
git branch --delete hotfix

# Move the HEAD pointer one commit back (detached HEAD state)
git switch --detach HEAD~
# --- or ---
git checkout HEAD~

# Move the HEAD pointer to the latest commit on the branch master (detached HEAD state)
git switch --detach master

# Access full log of commits including those made while in detached HEAD
git reflog
```

## 3. Merge and rebase

The merge and rebase features are used to join two or more development histories together. Let us consider two different branches: master and hotfix.

To merge hotfix into master will incorporate changes starting from the branching commit to the tip of hotfix into master and record the result in a new commit with the name of the two parents commits.

If master has been unchanged after being branched out into hotfix and that we are trying to merge hotfix into master, then the merge will result in a *fast-forward*: the branch master is moved to the tip of hotfix since it is a direct descendant.

In this case, it is also possible to force a *true merge* by using the *no fast-forward* option by specifying `--no-ff`.

A merge conflict can occur when changes in hotfix conflict with changes in master, for instance if a file has been modified after branching in both branches. When a merge conflict occurs, the user is prompted for manual review.

To rebase master onto hotfix will reapply all the commits starting from the branching commit to the tip of master onto the tip of the branch hotfix.

It is also possible to use the *interactive* option and *cherry-pick* commits or edit messages before rebasing by specifying the option `--interactive`.

```bash
# Merge the branch hotfix into the current branch
git merge hotfix

# Rebase the current branch at the tip of the branch hotfix
git rebase hotfix
```

## 4. Undo changes

If the HEAD pointer is reset to a specific commit then all the past commits starting from that specific commit are also discarded (but not deleted since they still appear in the reflog).

By default, the restore sources for working tree and the index are the index and HEAD respectively.

```bash
# Reset the HEAD pointer to HEAD~2 and discards following commits (modified files are to be committed again)
git reset --soft HEAD~2

# Reset the HEAD pointer to HEAD~2 and restore the index (modified files are to be both tracked and committed again)
git reset --mixed HEAD~2

# Reset the HEAD pointer to HEAD~2 and restore both the index and the working directory (discard all changes)
git reset --hard HEAD~2

# Restore hello.txt in the index from the copy stored in HEAD or unstage the file if not present in HEAD (equivalent to git rm --cached)
git reset HEAD hello.txt
# --- or ---
git restore --source=HEAD --staged hello.txt

# Restore hello.txt in the working directory from the copy stored in the index
git restore --worktree hello.txt
# --- or ---
git checkout hello.txt

# Restore hello.txt in both the index and the working directory from the copy stored in HEAD
git restore --source=HEAD --staged --worktree hello.txt
# --- or ---
git checkout HEAD hello.txt

# Create a new commit with the inverse modifications of the specified commit HEAD~2
git revert HEAD~2
```

## 5. Remote repositories

```bash
# Add the remote with the name origin and the url https://example.com/repo.git
git remote add origin https://example.com/repo.git

# Print information about the remote origin
git remote show origin

# Fetch the remote branch hotfix from origin with the name origin/hotfix in the local repository
git fetch origin hotfix

# Similar to the previous command but causes the branch origin/hotfix to be merged into the current local branch
git pull origin hotfix
# -- equivalent to --
git fetch origin hotfix
git merge origin/hotfix

# Push the modifications from the current local branch and creates a new branch master in origin or creates a temporary local branch in origin which will be merged into the remote branch master if the branch already exists
git push origin master
# or specify the branch (for example hotfix) to be pushed to master with
git push origin hotfix:master

# If the current local branch is up to date or successfully pushed to the remote branch master then the remote branch master is tracked by the local branch
git push --set-upstream origin master

# When the remote branch master is set to be tracked by the local branch then the following command
git push
# is equivalent to
git push origin master

# List remote-tracking branches
git branch --list --remotes

# Force the push even if this causes remote commits to be discarded (non fast-forward push)
git push --force origin master

# Delete the remote branch master from origin
git push --delete origin master
# -- equivalent to --
git push origin :master

# Delete the remote origin and all the associated tracking data
git remote rm origin
```

## 6. Tags

```bash
# List tags
git tag --list

# Tag the commit pointed by HEAD~ with the reference 1.2.0
git tag 1.2.0 HEAD~

# Delete the tag 1.2.0
git tag --delete 1.2.0

# Push the tags
git push --tags
```

## 7. Stash

The stash feature is used to temporarily save modifications while switching to another branch to avoid committing unfinished work.

```bash
# Save the current unfinished work made on the current branch
git stash push

# Recover your saved work
git stash pop
```
