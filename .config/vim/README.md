# XDG Vim configuration

Vim and vi use `vimrc`, which loads the recovered SPF13 setup and `vimrc.local`.
Edit personal settings in `vimrc.local`. Installed plugins and the CSpell engine
live under `$XDG_DATA_HOME/vim` (default `~/.local/share/vim`). Editor history,
views, backups, undo, and swap files live under `$XDG_STATE_HOME/vim`.

## Spelling

CSpell is enabled by default when a normal saved file is opened and after a
successful save (`BufWinEnter` and `BufWritePost`). Checks run asynchronously;
typing is not blocked and files are never automatically saved. Findings use
underlines without replacing syntax foreground or background colors.

- `:CSpell` checks the current saved file and opens a location list if issues exist.
- `:CSpellDisable` disables automatic checks and clears marks for the current buffer.
- `:CSpellEnable` enables the current buffer and checks it immediately.
- `:lopen` reopens a findings list created by `:CSpell`; `:lclose` closes it.
- `:echo b:cspell_result` shows the configuration, dictionary files, and results.

An explicit check asks you to save first if the buffer has unsaved changes.
Background results are discarded if the buffer changes before the check finishes.
Marks are cleared while editing and refreshed after the next save.

The actual CSpell engine discovers configuration upward from each file. It
honors project JSON/YAML/JavaScript CSpell configuration, imports, custom word
files, inline directives, overrides, and exclusions. Excluded files stay excluded
even when checked explicitly. Vim's native `:set spell` is independent and remains
off to avoid duplicate English-dictionary warnings on identifiers.

Drupal projects additionally use their own core `misc/cspell/drupal-dictionary.txt`
and `dictionary.txt`. The usual `web/core`, `docroot/core`, and `core` layouts are
detected. Shared copies of those lists are used elsewhere. See
`cspell/dictionaries/README.md` for source and update instructions.

IULD8 currently has CSpell configuration inside `web/core`, but no CSpell config
at the project root. Checking its root `composer.json` therefore uses CSpell
defaults plus Drupal words. Contributed module names and organization names may
still need a project word list. No project files were changed for this setup.

Install the pinned runtime on another Mac with Node.js 22.18 or later:

```sh
python3 ~/.config/vim/cspell/setup.py
```

To disable automatic checks globally, put `let g:cspell_auto_enabled = 0` in
`vimrc.local`; `:CSpell` will remain available.

An already-open Vim can load the new setup without closing its buffer:

```vim
:source ~/.config/vim/vimrc.local
:runtime plugin/cspell.vim
:CSpellEnable
```

## Syntax gallery and checks

Open 41 representative file samples:

```sh
vim -S ~/.config/vim/tests/review.vim
```

Use `:next`, `:previous`, and `:args` to navigate. The samples cover Drupal PHP
extensions, JSON, YAML, JS/JSX, TS/TSX, HTML, XML, Twig, CSS/SCSS/LESS, Markdown,
plain text, shell variants, Python, Ruby, Go, Rust, C/C++, Java, TOML, INI,
Dockerfile, Makefile, gitignore, SQL, GraphQL, diff, Vue, and Vim script.

Run the automated checks:

```sh
python3 ~/.config/vim/tests/check.py
node --test ~/.config/vim/tests/cspell.test.mjs
python3 ~/.config/vim/tests/check-cspell-ui.py
```

To include the original problem file read-only:

```sh
python3 ~/.config/vim/tests/check.py --file ~/App/IULD8/composer.json
```

Syntax checks verify detection, loaded syntax groups, native-spell defaults,
truecolor, spelling colors after a theme reload, and identical foreground and
background colors. They do not prove every token is styled perfectly or replace
a visual review in Kitty. Plain text is intentionally allowed to have no syntax.
CSpell behavior is tested separately so the syntax scan does not spawn a checker
for every fixture simultaneously. Reports go to `~/.local/state/vim/syntax-checks`.

## Theme comparison

The restored Vim theme is One Monokai. VS Code's configured theme is Baby Panda.
See [the comparison and Vim port](docs/themes.md). Kitty's palette was unchanged;
the red blocks came from Vim's spelling overlay.

SPF13's license is included as `LICENSE.spf13.txt`. Copied Drupal dictionaries
include their upstream license in `cspell/dictionaries/LICENSE.txt`.
