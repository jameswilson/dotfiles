# Shell agents

Assume shells may have aliases, hooks, pagers, read-only terminals, and noninteractive constraints. On this Mac, `rm`, `cp`, and `mv` may prompt; use explicit safe binaries or flags. Use `git --no-pager`; avoid `git ci` (`commit -a`), `git ui`, `.gr`, and `.gd`; disable editors; avoid TUIs and `sudo`; prefer project-local tools; and report hook errors. If input blocks a read-only agent terminal, terminate the process elsewhere and retry noninteractively. Force-push aliases are rewritten locally but still require explicit authorization.
