# Dependency selection procedure

- When adding a dependency and the Socket MCP `depscore` tool is available, check the dependency score.
- If the score is low, consider a better-supported alternative or a small local implementation.
- If the score is ambiguous, request review from someone with deeper dependency or ecosystem experience.
- Inspect actual imports as well as manifest files such as `composer.json`, `pyproject.toml`, or `package.json` when auditing dependencies.
