# Vim spelling and syntax review

Approved: full CSpell checks on save, plus an explicit `:CSpell` command.

The existing native spell checker runs across source identifiers. One Monokai
does not define its spelling groups, so Vim retains a bright red terminal
background. Saved views also restore the old `spell` flag.

Keep native spelling off by default, preserve syntax colors when it is enabled,
and save views without local options. Existing view spell flags are backed up
and removed without changing cursor positions or folds.

Use the actual CSpell engine rather than extracting a subset of its word lists.
Install pinned dependencies under the XDG data directory. A small Node bridge
reads the saved file, discovers its nearest project configuration, and applies
the shared Drupal dictionary plus core word lists from a detected Drupal site.
Project imports, exclusions, overrides, inline directives, and dictionary paths
remain CSpell's responsibility. Missing configuration uses CSpell defaults.

Vim runs the checker asynchronously on save and through `:CSpell`. Results go to
a location list and background-free underlines. Do not open a list on every save;
the explicit command opens it when findings exist. Discard stale results after
an edit or file switch. Report dependency or configuration errors distinctly.

Create representative language fixtures and a terminal-based checker covering
filetype detection, loaded syntax, spell defaults, spelling highlight colors,
and obviously unreadable foreground/background combinations. Include the actual
IULD8 composer.json in verification without changing it. Visual inspection is
still needed for aesthetic preferences and terminal-specific rendering.

Keep the existing migration commit separate. Commit implementation, dependency
lockfile, fixtures, tests, and instructions in the spelling follow-up.
