# Drupal-related skills

Extracted from `.skill-lock.json` in this directory.

## Table

| Repository | Skills |
|------------|--------|
| https://github.com/grasmash/drupal-claude-skills | drupal-at-your-fingertips, drupal-config-mgmt, drupal-contrib-mgmt, drupal-ddev, ivangrynenko-cursorrules-drupal |
| https://github.com/Omedia/drupal-skill | drupal-backend, drupal-frontend, drupal-tooling |
| https://github.com/madsnorgaard/agent-resources | ddev-expert, drupal-expert, drupal-migration, drupal-security |
| https://github.com/sparkfabrik/sf-awesome-copilot | drupal-cache-contexts, drupal-cache-debugging, drupal-cache-maxage, drupal-cache-tags, drupal-dynamic-cache, drupal-lazy-builders, http-cache-tools |
| https://github.com/kanopi/cms-cultivator | drupalorg-contribution-helper, drupalorg-issue-helper |
| https://github.com/Mindrally/skills | drupal-development |
| https://github.com/scottfalconer/drupal-contribute-fix | drupal-contribute-fix |
| https://github.com/scottfalconer/drupal-intent-testing | drupal-intent-testing |
| https://github.com/scottfalconer/drupal-issue-queue | drupal-issue-queue |

## How to regenerate

Run the extraction script from this directory:

```bash
cd ~/.agents
./extract-drupal-skills.sh
```

Or with a custom path to `skill-lock.json`:

```bash
./extract-drupal-skills.sh /path/to/.skill-lock.json
```

**Requires:** `jq` (install via `brew install jq` on macOS)
