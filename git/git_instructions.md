# Git instructions

## Basic commands

- git status
- git add .
- git add -p index.html - can choose what to add to commit from file
- git commit -m "..."
- git commit -am "message" - commit when a file from repo modified (no new files added)
- git commit --amend -m "Edited message" - edit message for the last local commit (only for unpushed changes or EXTREMELLY carefully)
- git commit --amend --no-edit - add new files without editing message in last local commit (only for unpushed changes or EXTREMELLY carefully)

**Add new files without editing message in last local commit**

```git
git add .
git commit --amend --no-edit
```

## Working with branches

- git branch - show list of local branches
- git branch -d local-branch-name - remove local branchg
- git branch -r - shows all remote branches
- git branch -a - show all branches
- git branch -vv or -vva - detailed info about branches

- git branch -D $(git branch | grep backup/feature\*) - remove a few branches by pattern

**Delete remote branch**

- git push <remote_name> --delete <branch_name>
  **OR**
  git push <remote_name> :<branch_name>

- git checkout master - change branch
- git checkout -b custom - create branche and switch to that branch
- git checkout - -back to previous branch (if forgot the name of the branch)
- git checkout -b local_branch origin/remote_branch - switching to a remote branch throught creating a local branch, usually with the same name

- git push origin branchName - if local and remote branches have the same name
- git push origin localBranch:removeBranch - if local and remote branches have different names

## Working with Aliases

- git config --global alias.dog 'log --decorate --oneline --graph' - create a new alias or edit existing
- git config --get-regexp '^alias\.' - to see all aliases
- git config --global --unset alias.dog - remove alias OR edit config file

## Differences

- git diff file_specific - shows differences before changes and after
- git diff <commit_id> - shows changes in specific commit

## Undoing changes

**removed changes from the repo but leave it locally**

- git rm --cached -r design_patterns/.idea

**good video https://www.youtube.com/watch?v=lX9hsdsAeTk**

**Changes addded but not committed**

- git reset file_name or git reset

**Changes added and commited locally**

- git reset HEAD~1
- git reset commit_id - to undo all changes after specific commit (locally)
- git reset --hard commit_id - unstage and remove all changes after specific commit

**Restore**

- git restore <filename> - discarding all local changes (not commited) in a file or recover removed file
- git restore -p <filename> - discarding chunks/lines in a file
- git restore . - discarding all local changes
- git restore --source <commit_id> <filename> - resetting file to an old revision

**Revert**

- git revert <commit_id> - undo a commit with a new commit

- git reset --hard <commit_id> - resetting to an old revision with removing all changes
- git reset --mixed <commit_id> - resetting with leaving all changes uncommited

**Adding a change to an old commit, not the last commit**

```git
git add <filename>
git commit --fixup <id_for_which_fix> - will be created a new commit with fixup!
git rebase -i --autosquash HEAD~4 - fix commit will be in the next to our commit that should be fixed - save - close
fixup! commit will be automatically removed
```

## Reflog (recovery)

**reflog is a journal that logs every movement of the HEAD pointer**

- git reflog - shows all changes (and resets if we do by mistake)
- git branch branch_name commit_to_restore - create a new branch with recovery

**example with recovering removed commit or branch**

```git
git reset --hard <commit_parent_id> - removed all changes -> PANIC!!!
git reflog - to check ID BEFORE our reset
git reset ID
  OR
git branch <new_branch_name> <commit_to_restore> - create a separate branch with recovering
```

## Renaming local and remote branch

// Names of things - allows you to copy/paste commands
//remote=origin

- git branch -m $old_name $new_name - Rename the local branch to the new name
- git push $remote --delete $old_name - Delete the old branch on remote
- git push $remote :$old_name - Or shorter way to delete remote branch [:]
- git branch --unset-upstream $new_name - Prevent git from using the old name when pushing in the next step. Otherwise, git will use the old upstream name instead of $new_name.
- git push $remote $new_name - Push the new branch to remote
- git push $remote -u $new_name - Reset the upstream branch for the new_name local branch

**Renaming Only remote branch**

- git push $remote $remote/$old_name:refs/heads/$new_name :$old_name - In this option, we will push the branch to the remote with the new name, while keeping the local name as is

**If you have named a branch incorrectly AND pushed this to the remote repository follow these steps to rename that branch:**

```git
//Rename your local branch:
git branch -m new-name - If you are on the branch you want to rename
OR
git branch -m old-name new-name - If you are on a different branch
git push origin :old-name new-name - Delete the old-name remote branch and push the new-name local branch
git push origin -u new-name - Reset the upstream branch for the new-name local branch: Switch to the branch
```

## Merge

```git
git merge master - to get changes from master to our local branch (we should be on a local branch)
in case of merge conflicts in files edit changes and create a new commit
```

## Squashing

```git
git rebase branch_name - rebase current branch on branch_name !!!recheck it in console
git push -u origin custom_branch or
git rebase -i HEAD~number_commits_before
i -> change all pick to squash except first commit -> (windows ctrl + x ctrl+c) -> :wq enter
i -> edit commit message -> (windows ctrl + x ctrl+c) -> :wq enter
git push -u origin +custom_branch - if changes were pushed before (+ in this case is force on local branch, it is better use + instead of --force)

//delete commit
during interective rebase choose for commit 'drop'
```

## Cherry picking

- git cherry-pick commit_id - execute on the branch where the commit should be

## Logging

-git log --oneline --decorate --all --graph

## Search and find

    //----by date --before/--after----
    git log --after="2021-7-1"

    //----by message --grep----
    git log --grep="refactor"

    //------by author --author-----
    //------by file -- <file name>-----
    //------by branch <branch A>..<branch B>------

---

## Stash

- git stash -help - all necessary info about stash

## Patch

- git format-patch -<n> <rev> - create patch

**For example:**

```git
git format-patch -1 HEAD - The -1 flag indicates how many commits should be included in the patch: -<n> - Prepare patches from the topmost <n> commits.
git am < file.patch - Apply the patch with the command:
Alternatively you can also apply (should work on all OSes including Windows) with:
git apply --verbose file.patch - The -v or --verbose will show what failed, if any. Giving you a clue on how to fix.
```

## Submodules

- git submodule add remote_repo_url
- git submodule update --init --recursive - after cloning a project that already has submodules

## number of changes???

- git rev-list --count master..test_branch - changes in current branch comparing with master
- git rev-list --count test_branch..master - changes in master with current branch
