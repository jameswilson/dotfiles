# Agent thread naming

- When creating or suggesting an agent, chat, thread, or session name, prefix it with the active Jira issue ID.
- Use the format `ABC-123: Short task name`.
- Extract Jira IDs from the branch name, commit prompt, ticket URL, task text, or user message.
- Treat `[A-Z][A-Z0-9]+-[0-9]+` as the Jira ID pattern.
- If multiple IDs are present, use the most specific current issue.
- If no Jira ID is available, use `NO-JIRA: Short task name`.
- Do not generate a bare thread name without the prefix.
