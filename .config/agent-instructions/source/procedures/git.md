# Git procedure

## Commit messages

- Derive a Jira issue ID from the current branch name or recent commits and use it as the commit-message prefix.
- If no Jira issue ID exists, follow the repository's recent commit-message style.

## Repository changes

- Never use `git commit -A`.
- Commit already-staged changes before considering unstaged changes.
- Stage explicit files; do not use `git add -A` over unrelated worktree changes.
- Ask before adding untracked files.
- Confirm before deleting untracked files.
- Preserve generated or untracked artifacts unless deletion is explicitly requested.
- Omit AI-agent commit trailers.

## Remotes and merge requests

- Push only to `origin` unless explicitly instructed otherwise.
- Treat rebase-only requests as local history rewrites; do not push or force-push without separate authorization.
- Before creating a GitLab merge request, check whether one already exists for the branch or HEAD commit.
