---
description: Pull latest changes and switch to the current project branch.
agent: build
---

Update the git repository and switch to the branch of the project currently being worked on.

1. Ensure there are no uncommitted changes before switching branches; if there are, ask the user whether to stash or commit them.
2. Run `git pull --prune` to fetch and fast-forward the current branch.
3. Determine the target project branch:
   - If an explicit branch is given in $ARGUMENTS, use it.
   - If the current branch is already a long-lived project branch named `project/<slug>` (e.g. `project/major-refactor`), keep it.
   - If the current branch is an issue branch (e.g. `TPV-123-fix-login`), switch to its parent project branch.
   - Otherwise, ask the user which project branch to target.
4. Run `git switch <target-project-branch>`.
5. If the target branch is not yet up to date, run `git pull --prune` again on it.
6. Delete the local branch if the origin branch is deleted
7. Report the final branch, its tracking status, and any locally deleted remote branches.

