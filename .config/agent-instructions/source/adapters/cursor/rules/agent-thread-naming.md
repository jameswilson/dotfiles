# Agent thread naming

When creating or suggesting an agent, chat, thread, or session name, prefix it with the active Jira issue ID.

Format: `ABC-123: Short task name`

- Extract the ID from the branch name, commit prompt, ticket URL, task text, or user message.
- Jira IDs match `[A-Z][A-Z0-9]+-[0-9]+`.
- If multiple IDs are present, use the most specific current one.
- If no Jira ID is available, use `NO-JIRA: Short task name`.
- Never generate a bare thread name.
