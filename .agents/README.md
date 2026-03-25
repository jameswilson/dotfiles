# Agent Skills

Skills installed via the [vercel-labs/skills](https://github.com/vercel-labs/skills) CLI.

## Reinstalling from the lock file

Use [reinstall-all-skills.sh](/Users/jameswilson/.agents/reinstall-all-skills.sh) to reinstall the skills listed in `~/.agents/.skill-lock.json` for specific global agent targets.

```bash
# Preview the reinstall commands for Codex
~/.agents/reinstall-all-skills.sh --agent codex --dry-run

# Reinstall for Codex and Cursor
~/.agents/reinstall-all-skills.sh --agent codex --agent cursor

# Remove lock-managed skills from the selected agent paths first, then reinstall
~/.agents/reinstall-all-skills.sh --agent codex --prune
```

Notes:

- `--agent` is required. Repeat it to target multiple agents.
- The script only manages global installs, matching the existing `-g` workflow.
- `--dry-run` prints the planned commands without making changes.
- `--prune` only removes skill directories named in the lock file for the selected agents. It does not wipe all installed skills.

## Finding unmanaged skills

Use [find-unmanaged-skills.sh](/Users/jameswilson/.agents/find-unmanaged-skills.sh) to scan known global agent skill directories for skills that are not tracked in `~/.agents/.skill-lock.json`.

```bash
# Human-readable report
~/.agents/find-unmanaged-skills.sh

# JSON output for automation
~/.agents/find-unmanaged-skills.sh --json
```

Notes:

- The script looks for `SKILL.md` files at expected skill-layout depths under each agent's global `skills` directory.
- It derives the skill name from the immediate parent folder containing `SKILL.md`.
- It suppresses copied or mirrored skills when the same relative directory exists under `~/.agents/skills` and the contents match.
- Exit codes are `0` when no unmanaged skills are found, `1` when findings exist, and `2` for usage or prerequisite errors.

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

**Workaround:** Reinstall the affected skill:

```bash
npx skills add <owner/repo> --skill <skill-name> -g -y
```

For a full lock-file-driven reinstall to one or more agents, use:

```bash
~/.agents/reinstall-all-skills.sh --agent codex --dry-run
```

### Update doesn't actually update

`npx skills update` can report success but the skill still shows as needing an update on the next `npx skills check`. Known quirk; reinstall the skill manually if needed.
