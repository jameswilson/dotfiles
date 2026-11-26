# Baby Panda for Vim

This is a fresh classic Vim port of the installed VS Code **Baby Panda 0.0.1**
theme by Gustavo Gualbano. The older Panda Vim port was reviewed as reference;
its generated theme code was not copied. Baby Panda itself is based on Panda Syntax.

Sources:

- https://github.com/gsgualbano/baby-panda-vscode
- https://github.com/PandaTheme/panda-syntax-vscode
- Reference reviewed: https://github.com/markvincze/panda-vim

The source file used was the installed extension's
`themes/Baby Panda-color-theme.json`, SHA-256
`ced1ccc4e28def85422dc99916c41d1f2ea22ebd052088a72ae507cde277eadc`.

## Palette and mappings

| Role | Source color | Vim role |
| --- | --- | --- |
| Editor background | `#292a2b` | Normal background |
| Editor foreground | `#e6e6e6` | Normal foreground, identifiers |
| Comments | `#676b79` | Comment, documentation text |
| Strings | `#19f9d8` | String |
| Control keywords | `#ff75b5` | Keyword, Statement |
| Constants and storage keywords | `#ffb86c` | Constant, StorageClass |
| Property names and primitive type support | `#ffcc95` | JSON/YAML/TOML/INI keys, primitive type groups |
| Named types | `#b084eb` | Type, class/interface/type names |
| Functions and regex strings | `#6fc1ff` | Function |
| Escape sequences | `#45a9f9` | SpecialChar |
| Tags | `#ff2c6d` | HTML/XML/JSX tag names |
| Object/context references | `#ff9ac1` | Selected object and context groups |

Editor selection, search, and diff backgrounds use the source theme's alpha
colors composited over `#292a2b`, since Vim highlight colors do not accept alpha.
The 256-color fallback uses indices 16–255, avoiding dependence on Kitty's custom
first 16 ANSI colors. The colorscheme does not change Kitty configuration.

Comments intentionally retain the source theme's subdued color. Matching the
source palette does not imply identical TextMate and Vim parsing: VS Code has
contextual scopes and semantic tokens that classic Vim may not distinguish.

Python documentation has one intentional refinement: standalone triple-quoted
blocks are gray, while ordinary strings and assigned multiline values remain
mint. The original VS Code theme colors docstrings as strings.

TOML and INI keys share the property-name color. Value colors follow their
syntax groups: TOML `true` is a boolean (orange), while the generic INI syntax
treats `true` as string text (mint). INI dialect-specific type parsing is unchanged.

The cross-language audit uses peach for recognized primitive types and purple
for named types, blue for functions, and white for ordinary variables and
property references. Classic Vim cannot distinguish every declaration or call:
unclassified tokens retain the foreground color. For example, the bundled C/C++
and Java parsers leave some user-defined function and type names unclassified.
The TypeScript parser also shares one member group between properties and
methods; that group stays white instead of coloring every property as a function.

Spelling and diagnostic highlights are undercurls with no foreground/background
override. They preserve the color of the underlying token. The matching Airline
theme uses the same surfaces and accents for normal, insert, visual, replace,
terminal, modified, and inactive states.

## Syntax integration

The recovered setup contained a few overrides that prevented faithful coloring:

- Rainbow masked HTML/Twig/Vue/PHP syntax regions and attributes, TypeScript
  control keywords, and SCSS/LESS property contexts. It is disabled for those
  filetypes in `vimrc.local`, and retains Panda accents in compatible syntaxes.
- PIV supplied a PHP 5.3-era syntax definition. `syntax/php.vim` now selects the
  maintained PHP parser bundled with Vim while retaining PIV's other features.
- The bundled PHP syntax leaves user-defined declaration names unclassified.
  `after/syntax/php.vim` adds narrow matches for function and class names. It also
  treats NULL as a value and removes PIV's SQL highlighting from arbitrary PHP
  strings. SQL-named heredocs retain embedded SQL highlighting.
- Vim's `javascriptreact.vim` is a placeholder without JSX rules.
  `syntax/javascriptreact.vim` uses the bundled TSX grammar, which also parses
  plain JSX, while preserving the JSX filetype.
- `after/syntax/python.vim` separates standalone triple-quoted documentation from
  ordinary string values, and distinguishes declaration keywords, builtin types,
  constants, and class names. Builtin-named attributes retain normal text colors.
- `syntax/less.vim` selects the bundled LESS parser. The recovered parser mixed
  property and value groups, incorrectly coloring `color:` as a font value.
- The bundled Go parser's existing type, function, and call highlighting options
  are enabled in `vimrc.local`.
- Explicit mappings align SCSS/LESS selectors and variables, SQL keywords and
  values, XML entities, Markdown headings/links/list markers, shell variables,
  Vim function names, and TypeScript expression regions with their token roles.
- One Monokai's operator callback used to repaint operators after a theme switch.
  It is now scoped to that theme, and its reported name matches its filename.

## Use and verification

Baby Panda and its Airline palette are the configured defaults. Start a fresh
Vim session to apply the parser changes and discard callbacks loaded by the old
theme. In sessions using the updated configuration, the palette can be loaded with:

```vim
:colorscheme baby-panda
:AirlineTheme baby_panda
```

To temporarily restore the old
colors, use `:colorscheme one-monokai` and `:AirlineTheme solarized`.

```sh
python3 ~/.config/vim/tests/check.py --theme baby-panda --file ~/App/IULD8/composer.json
python3 ~/.config/vim/tests/check-baby-panda.py
python3 ~/.config/vim/tests/check-cspell-ui.py --theme baby-panda
vim -S ~/.config/vim/tests/review.vim
```

The checks cover 41 file fixtures plus the original composer.json, 188 exact token
colors, switching/reloading, spelling overlays, 256-color fallbacks, Airline,
and CSpell interaction. Every fixture has exact-color assertions, including the
intentionally unhighlighted plain-text sample. The exact-color test opens folds and draws each sample
before querying its syntax groups, matching visible buffer rendering.

A sample preview was exported directly using Vim's `:TOhtml` and inspected in a
browser. Computer-use access to Kitty was blocked, so this is a syntax export,
not a native Kitty screenshot. Classic Vim parser differences and terminal font
rendering can still produce differences from VS Code.
