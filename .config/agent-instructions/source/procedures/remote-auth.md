# Remote authentication procedure

## General

- Validate authentication before relying on `gh`, `glab`, `jira`, or remote DDEV interactions.
- When authentication fails, distinguish among:
  - Missing binary.
  - Missing or incorrect configuration.
  - Missing, expired, or invalid credential.
  - Incorrect host selection.
  - Sandbox or network failure.
- Validate the configured credential source before recommending credential replacement.
- Store only credential patterns, configuration locations, and validation commands in instructions; never store secret values.

## GitHub CLI

- Load GitHub credentials from `~/.codex/.env`, not browser or keychain state.
- Use `GH_TOKEN` for `github.com`.
- Use `GH_ENTERPRISE_TOKEN` for `github.umn.edu`.
- Outside a repository, set `GH_HOST=github.umn.edu` when the host is not otherwise inferable.
- Validate each host independently:
  - `gh auth status`
  - `GH_HOST=github.umn.edu gh auth status`
- Treat an in-sandbox invalid-token result as provisional until the same read-only check is rerun outside the sandbox.

## GitLab CLI

- Use per-host keyring-backed `glab` logins.
- Expected login commands:
  - `glab auth login --hostname gitlab.com --use-keyring`
  - `glab auth login --hostname git.drupalcode.org --use-keyring`
- Expect non-secret CLI state in `~/.config/glab-cli/config.yml` and credentials in the OS keyring.
- Validate with `glab auth status --all`.
- Treat in-sandbox failure as inconclusive until the same check is rerun once outside the sandbox.
- Do not set global `GITLAB_TOKEN`, `GITLAB_ACCESS_TOKEN`, or `OAUTH_TOKEN` in `~/.codex/.env`; these override per-host configuration.

## Jira CLI

- Use `~/.config/.jira/.config.yml` plus `JIRA_API_TOKEN` from `~/.codex/.env`.
- For Atlassian Cloud, authenticate with email plus API token, not a password.
- Validate with:
  - `jira me`
  - `jira serverinfo`

