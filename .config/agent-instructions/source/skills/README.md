# Skill policy

- Keep installed Agent Skills under `~/.agents/skills/` as runtime data.
- Keep personally authored cross-agent skills in dedicated version-controlled repositories; install or link their skill folders into `~/.agents/skills/`.
- Use `~/App/Bluespark/developer-skills/` as the canonical checkout for Bluespark's shared development workflow skills.
- Use `github.com/BluesparkLabs/developer-skills` as that checkout's upstream repository.
- On this machine, link the three `developer-skills` packages from the canonical checkout into `~/.agents/skills/`, then link Claude and Cursor to those entries. Do not use `npx skills add` or `npx skills update` for this checkout locally because those commands replace the live links with managed copies.
- Treat `$XDG_STATE_HOME/skills/.skill-lock.json` as tool-generated realized state when `XDG_STATE_HOME` is set; otherwise `npx skills` falls back to `~/.agents/.skill-lock.json`.
- Do not use `npx skills --all` unless every registered harness is an intentional target. Select the supported agents explicitly.
- Do not duplicate full skill instructions in global preferences or procedures.
- Do not maintain parallel slash-command prompt files for workflows available as skills. Add a thin harness-specific alias only when native skill invocation is unavailable.
- Promote a procedure to a skill when it has a clear trigger, reusable multi-step workflow, references, scripts, or independent validation.
- Keep simple always-applicable constraints in instruction files.
- Prefer a small global skill baseline; keep specialist skills project-local, plugin-provided, or loaded on demand.
- Add a desired-state skill manifest only after the existing skill inventory is reconciled.
