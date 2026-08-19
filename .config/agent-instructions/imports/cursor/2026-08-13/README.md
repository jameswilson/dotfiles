# Cursor import snapshot — 2026-08-13

## Captured locally

- `file-rules/karpathy-guidelines.mdc`: verbatim copy of the active native file.
- `file-rules/shell-agent-gotchas.mdc`: verbatim recovery of the tracked file deleted from the working tree, read from `HEAD`.
- `user-rules-cache.json`: complete text of the 12 titled cloud User Rules recovered from the newest matching local Cursor prompt cache.

## Cloud User Rules

The installed Cursor 3.14.27 app keeps User Rules as account-backed knowledge-base objects. They are not present in `settings.json`, a dedicated live-state key, or an export command in `cursor-agent`.

Cursor's built-in `cursor-app-control.cursor_dialog` tool can list the complete User Rules from an Agents Window. Run `bin/cursor-rules export-prompt` and execute that prompt in Cursor to create `user-rules.json` in this directory. Do not treat this snapshot as complete until that file exists.

Complete titled User Rule bodies are also embedded in serialized agent prompt snapshots in `User/globalStorage/state.vscdb` under `cursorDiskKV`. `bin/import-cursor-cache` extracts only those rule bodies into `user-rules-cache.json`; it does not copy conversations, built-in rules, credentials, or unrelated prompt context. The cache has no cloud ids and can lag the UI.

## Screenshot inventory

The screenshot at `/Users/jameswilson/Screenshots/Screen Shot 2026-08-13 at 12.19.41.png` shows 13 user-level entries:

1. `Agent thread naming`
2. `Browser tests`
3. `Commit messages`
4. `DDEV`
5. `Formatting`
6. `Git`
7. `Jira`
8. `Karpathy behavioral guidelines`
9. `Responses`
10. `Shell agents`
11. `Socket`
12. `User context`
13. `gitlab-workflow`

The first 12 are visibly labeled `User Rule`. Local prompt evidence identifies `gitlab-workflow` as a plugin-provided agent-requestable rule at a Cursor plugin-cache path, not a cloud User Rule. Body previews are truncated; this inventory alone is not a content export.
