# Agent instructions control plane

This directory is the human-owned source of truth for cross-agent context. Agent-native files and ChatGPT fields are deployment targets, not canonical sources.

## Layout

- `source/facts/`: durable identity, professional, environment, and workflow facts.
- `source/preferences/`: response, reasoning, code, source, and policy preferences.
- `source/procedures/`: durable operating rules for engineering tools and workflows.
- `source/state/`: current, reviewable context that may become stale.
- `source/skills/`: desired skill policy; installed skill packages remain runtime data.
- `source/adapters/`: deliberately compressed or platform-specific authored projections.
- `imports/`: dated, verbatim snapshots copied down from external platforms.
- `dist/`: generated projections ready for manual synchronization.
- `targets.toml`: source-to-target mappings and native comparison paths.
- `bin/render`: render, verify, or compare projections without modifying native files.

## Commands

```bash
~/.config/agent-instructions/bin/render
~/.config/agent-instructions/bin/render --check
~/.config/agent-instructions/bin/render --diff-native codex
~/.config/agent-instructions/bin/render --diff-native cursor
~/.config/agent-instructions/bin/import-cursor-cache
~/.config/agent-instructions/bin/cursor-rules export-prompt
~/.config/agent-instructions/bin/cursor-rules deploy-prompt
```

`bin/render` writes only under `dist/`. It never installs files into Codex, Cursor, ChatGPT, or another agent.

## Manual synchronization

### Sync down

1. Copy each remote field verbatim into a new dated directory under `imports/<platform>/YYYY-MM-DD/`.
2. Reconcile new facts, preferences, procedures, or state into `source/`.
3. Preserve historical wording in `imports/`; do not turn raw history into live instructions.

### Sync up

1. Run `bin/render`.
2. Review `dist/` and `bin/render --diff-native <target>` where supported.
3. Copy the relevant generated field or file to the platform manually.
4. After confirming the platform state, save a new dated import snapshot.

### Cursor

- `dist/cursor/user-rules.json` is the primary Cursor target. It preserves semantic rule boundaries and contains one titled cloud User Rule per managed module.
- `dist/cursor/shared-agent-instructions.mdc` is an optional file-based fallback. Do not depend on global `~/.cursor/rules/` behavior without testing the specific Cursor surface in use.
- `bin/import-cursor-cache` extracts complete titled User Rule bodies from the newest suitable local Cursor prompt snapshot in `state.vscdb`. This is a useful sync-down path, but it has no cloud ids and may be stale until a new Cursor agent prompt has loaded the latest rules.
- Cursor 3.14 exposes User Rules through its internal `cursor-app-control.cursor_dialog` tool, but not through the shell CLI. Run `bin/cursor-rules export-prompt` or `deploy-prompt` and paste the emitted prompt into a Cursor Agents Window rooted at `/Users/jameswilson`.
- Deployment is additive and title-scoped. It requires a pre-deploy export, updates only exact managed titles, refuses ambiguous duplicates, and never removes unmanaged rules.

## Boundaries

- Do not store secrets or credential values here.
- Do not edit `dist/`; rerender it.
- Keep adapter sources semantically aligned with their canonical facts, preferences, and procedures.
- Do not copy vendor-managed memory databases into this directory.
- Keep project-specific rules in the project's `AGENTS.md` or equivalent.
- Keep task history and transient work out of always-loaded instructions.
