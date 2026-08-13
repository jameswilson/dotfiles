# Skill policy

- Keep installed Agent Skills under `~/.agents/skills/` as runtime data.
- Treat `~/.agents/.skill-lock.json` as tool-generated realized state.
- Do not duplicate full skill instructions in global preferences or procedures.
- Promote a procedure to a skill when it has a clear trigger, reusable multi-step workflow, references, scripts, or independent validation.
- Keep simple always-applicable constraints in instruction files.
- Prefer a small global skill baseline; keep specialist skills project-local, plugin-provided, or loaded on demand.
- Add a desired-state skill manifest only after the existing skill inventory is reconciled.

