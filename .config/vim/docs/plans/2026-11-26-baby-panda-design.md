# Baby Panda Vim port

Approved approach: a fresh port based on the installed Baby Panda VS Code theme,
activated after verification. The earlier Panda Vim port is reference material;
its generated colors, missing groups, and older mappings will not be copied.

Use Baby Panda 0.0.1's palette and token roles: charcoal background, light text,
mint strings, pink control keywords, orange constants, purple types, and blue
functions. Translate TextMate scopes into core Vim and installed syntax-plugin
groups, with special attention to PHP/Drupal, JSON/YAML, JS/JSX, TS/TSX, and Twig.
Vim's different syntax parser means the port cannot promise identical token
boundaries to VS Code.

The standalone colors file supports truecolor and explicit 256-color fallbacks.
Alpha colors are composited over the editor background. Spelling and diagnostic
underlines preserve syntax foregrounds and backgrounds. Include an Airline theme
for the current status bar. Keep One Monokai available as a fallback.

Validate all 41 fixtures and the IULD8 composer.json, representative token-color
assertions, theme reload/switching, fallback colors, and the CSpell interaction
checks. Inspect a native Kitty preview. Activate the new default only after the
checks pass. Keep the resulting changes reviewable in the home repository.
