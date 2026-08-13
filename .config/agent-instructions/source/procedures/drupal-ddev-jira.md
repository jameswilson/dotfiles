# Drupal, DDEV, and Jira procedure

## Jira evidence

- Treat an unqualified ticket or issue reference as Jira unless context establishes otherwise.
- Prefer Atlassian MCP for Jira details and use the Jira CLI as an appropriate fallback.
- Fetch the description and complete comment history.
- Treat newer comments as authoritative over older comments and the original description when they conflict.
- For worktree-and-branch planning, reconcile the complete Jira history and latest comment before implementation.

## DDEV

- If the project root contains `.ddev/`, treat DDEV as the project runtime unless repository guidance says otherwise.
- Prefix project `drush`, `composer`, `php`, and similar commands with `ddev`.
- Before depending on the environment, validate:
  - `ddev version`
  - Docker access.
  - The smallest relevant project connectivity check.
- Before remote DDEV or Acquia SSH work, run `ddev auth ssh` successfully in the current environment.
- Verify forwarded keys inside DDEV with `ddev exec ssh-add -l >/dev/null 2>&1`.
- If key validation fails, distinguish among missing DDEV, Docker startup failure, missing key forwarding, and sandbox or network failure.

## Solr reindexing

- Determine the Search API server machine name instead of assuming it is `solr`.
- Run the complete sequence:
  1. `ddev drush sapi-sc <server_machine_name>`
  2. `ddev drush sapi-c`
  3. `ddev drush sapi-r`
  4. `ddev drush sapi-rt`
  5. `ddev drush sapi-i`

## Drupal implementation

- Prefer native Drupal permissions and APIs over role-name overrides or custom glue.
- Prefer the least logic and fewest special cases that satisfy the requirement.
- Validate Drupal PHP with applicable Drupal and DrupalPractice standards.

