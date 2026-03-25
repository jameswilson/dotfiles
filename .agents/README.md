# Agent Skills

Skills installed via the [vercel-labs/skills](https://github.com/vercel-labs/skills) CLI.

## Updating skills

```bash
# Check for available updates
npx skills check

# Update all installed skills to latest versions
npx skills update
```

Both commands read from `~/.agents/.skill-lock.json` and compare against current GitHub content.

## Troubleshooting

### "Could not check N skill(s) (may need reinstall)"

The CLI checks each skill via GitHub Trees API. Failures happen when:

- **Rate limits** – One API call per skill; 42 skills = 42 calls. Unauthenticated = 60 req/hr.
- **Repo changes** – Repo moved, renamed, or restructured; skill path no longer exists.
- **Network** – Timeouts, connection errors.

Even with `gh auth login` (or `GITHUB_TOKEN`), some skills may still fail to check. The CLI does not report which ones.

**Workaround:** Remove and reinstall the skill:

```bash
npx skills remove <skill-name>
npx skills add <owner/repo> --skill <skill-name> -g -y
```

### Update doesn't actually update

`npx skills update` can report success but the skill still shows as needing an update on the next `npx skills check`. Known quirk; reinstall the skill manually if needed.
