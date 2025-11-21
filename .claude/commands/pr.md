Create a PR (or MR as the case may be) to the origin upstream from the current branch.

## Pre-flight Checks

1. **Branch Safety**: Confirm we're not on master/main/dev/develop/stage or similarly named branches before proceeding.
2. **Branch Naming**: Ideally the branch name should follow our Jira ticket naming convention. Warn me first before proceeding if not currently on a feature branch.
3. **Branch Validity**: Sanity check that the current branch actually has commits from the base branch from which it was created.
4. **Working Tree**: Ensure the working tree is clean (no uncommitted changes).
5. **Existing PR**: Check if there is already a PR for the current branch. If so, push and update the PR with a comment.

## PR Content

- The body of the PR should contain a link back to the associated Jira issue.

## Jira Integration

If there is a Jira ticket associated:

- Add a comment pointing out that the PR is ready (with link to PR) and brief summary of the change.
- Keep the description less technical and geared for non-technical client reviewers.
- Make sure to note whether there are any additional manual steps required to deploy this change to production.
