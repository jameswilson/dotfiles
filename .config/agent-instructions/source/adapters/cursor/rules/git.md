# Git

Never use `git commit -A` or `git add -A` across unrelated changes. Commit already-staged changes first; stage explicit files; ask before adding untracked files; preserve generated or untracked artifacts; confirm before deleting untracked files; omit AI-agent trailers; and push only to `origin` unless explicitly instructed otherwise. A rebase-only request stays local: do not push or force-push without separate authorization. Before creating a GitLab merge request, check for an existing MR for the branch or HEAD.
