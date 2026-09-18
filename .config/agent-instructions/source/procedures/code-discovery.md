# Code discovery procedure

- Prefer an available codebase knowledge graph for functions, classes, routes, variables, architecture, and call-path discovery.
- Use graph operations in this order when supported:
  1. Search symbols and patterns.
  2. Trace inbound or outbound paths.
  3. Retrieve specific code snippets.
  4. Run graph queries for complex relationships.
  5. Read the architecture summary.
- Fall back to `rg` or file search for:
  - String literals and error messages.
  - Configuration and non-code files.
  - Cases where graph results are insufficient.
- Use `rg` before slower filesystem search tools when textual search is appropriate.

