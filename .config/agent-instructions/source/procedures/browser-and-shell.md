# Browser and shell procedure

## Browser validation

- Check a URL with `curl` before opening a browser when HTTP-level evidence is sufficient.
- For responsive, mobile, interaction, or visual review, use Playwright or equivalent real-browser automation.
- Do not treat lightweight embedded webviews as equivalent visual evidence.

## Shell execution

- The login shell sources `~/.aliases`, `~/.environment`, and `~/.git-safe-force-push.sh`.
- Assume agent shells may have aliases, hooks, pagers, read-only terminals, and noninteractive constraints.
- Avoid interactive or TUI flows when a noninteractive alternative exists.
- Disable pagers and editors where necessary.
- Prefer explicit binaries, noninteractive flags, and project-local tooling.
- Report environment hook errors explicitly.
- If a command appears stuck awaiting input, stop it and use a safer noninteractive approach.
- Do not assume a remote service is broken until local configuration, credentials, host selection, and sandbox/network access have been separated.

## Local command hazards

- `rm`, `cp`, and `mv` may be interactive aliases. In noninteractive work, use an explicit safe form such as `command rm`, `rm -f`, `git mv`, or `/bin/cp` after resolving the exact target.
- Never chain a copy followed by a bare removal; the interactive `rm` alias can block indefinitely.
- Do not use `sudo`, the `hosts` or `h` aliases, interactive pagers or TUIs such as `tig`, or `brew_update` in agent shells unless the task explicitly requires and authorizes them.
- Use `git --no-pager` or `GIT_PAGER=cat` when parsing Git output.
- Do not use `git ci`; the global alias expands to `commit -a`.
- Be aware that `git push -f` and `git push --force` are locally rewritten to `--force-with-lease --force-if-includes`; force-pushing still requires explicit authorization.
- Avoid `git ui`, which opens `tig`, and the repository aliases `.gr`, which mass-deletes untracked files, and `.gd`, which invokes `git delete`.
- Use `GIT_EDITOR=true`, `EDITOR=true`, or `git commit --no-edit` when automation must not open Vim.
- GNU coreutils are prepended through `~/.environment`, and `ls` may resolve to `gls`; do not assume BSD `ls` behavior in portable scripts.
- `direnv` is hooked into Zsh. Report `.envrc` or hook errors rather than initiating an interactive flow.
- If a command waits for confirmation or a password in a read-only agent terminal, terminate it from a separate shell or session and retry noninteractively.
- When `CURSOR_AGENT` is set, Powerlevel10k heavy prompt initialization is intentionally skipped.
