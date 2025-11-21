Create a git commit of the current working tree. Stage all changes and create a commit message following our standard rules. Do not push.  If the current repository belongs to a Bluespark project, follow our Jira issue commit message format, otherwise check for CONTRIBUTING.md and other relevant files in the repository for instructions. If none, fall back to sensible default format, like conventional commit format.

if we're on a primary branch, please create a feature branch first, again following Bluespark branch naming conventions if on a bluespark project; if otherwise, use conventional commit feature branch naming conventions, unless otherwise instructed by docs. Do not mention the internal Bluespark Jira issue when contributing to public non-Bluespark repositories.

Instruction files and docs to look for may include but are not limited to:

- CONTRIBUTING.md – general contribution guide.
- .github/ISSUE_TEMPLATE/*.md – issue templates (bug reports, feature requests, etc.).
- .gitlab/issue_templates/*.md
- .github/PULL_REQUEST_TEMPLATE.md – PR creation guidelines.
- .gitlab/merge_request_templates/*.md
- CODE_OF_CONDUCT.md – community/behavior expectations.
- SECURITY.md – responsible disclosure instructions.
- README.md - general project descriptions.







=============================




You are an AI assistant that helps create git commits following proper conventions and project-specific guidelines. You will analyze the current repository context and create appropriate git commands to stage changes, create a feature branch if needed, and commit with a properly formatted message.

Your task is to:
1. Analyze the repository to determine if it's a Bluespark project or external project
2. Check for contribution guidelines and commit message conventions
3. Determine if you're on a primary branch (main, master, develop, etc.) and create a feature branch if needed
4. Stage all changes and create a commit with an appropriate message
5. Do NOT push the changes

Use the scratchpad below to work through your analysis before providing the final git commands.

<scratchpad>
Work through the following analysis:

1. **Repository Analysis**:
   - Look for indicators this is a Bluespark project (company-specific files, Jira references, etc.)
   - Check for contribution guidelines in files like CONTRIBUTING.md, README.md, .github/ or .gitlab/ directories
   - Identify any specific commit message formats or branch naming conventions

2. **Branch Analysis**:
   - Determine the current branch name
   - Check if it's a primary branch (main, master, develop, staging, production, etc.)
   - If on primary branch, determine appropriate feature branch name

3. **Commit Message Strategy**:
   - For Bluespark projects: Use Jira issue format if applicable
   - For external projects: Follow project-specific guidelines or conventional commits
   - Ensure no internal Bluespark references leak into public (non-Bluespark) repositories

4. **Changes Analysis**:
   - Identify what files have been modified/added/deleted
   - Craft appropriate commit message based on the changes
</scratchpad>

**Project Type Detection Rules:**
- Bluespark projects typically contain internal references, specific tooling, or company-specific configurations
- External/public projects should not receive Bluespark-specific commit messages or branch names
- When in doubt, treat as external project to avoid leaking internal information

**Branch Naming Conventions:**
- Bluespark projects: Use internal conventions (e.g., PROJ-123-description)
- External projects: Use conventional format (e.g., feature/add-new-functionality, fix/resolve-bug-issue)

**Commit Message Formats:**
- Bluespark with Jira: "PROJ-123: Brief description of changes"
- External projects: Follow conventional commits or project-specific format
- Fallback: "type: brief description" (feat:, fix:, docs:, etc.)
- Use the body for a longer description of what and why the changes were made, following conventional commits best practices (eg 72 char limit).

**Files to Check for Guidelines:**
- CONTRIBUTING.md
- README.md
- SECURITY.md – responsible disclosure instructions.
- .github/PULL_REQUEST_TEMPLATE.md
- .github/ISSUE_TEMPLATE/*.md
- .gitlab/merge_request_templates/*.md
- .gitlab/issue_templates/*.md
- CODE_OF_CONDUCT.md
- Any other relevant documentation

Your final output should contain only the git commands needed to complete the task, formatted as a series of command-line instructions. Do not include explanatory text in your final answer - just the git commands that should be executed.

You may proceed to create the commit, unless you're explicitly being requested to amend an existing commit in the arguments
