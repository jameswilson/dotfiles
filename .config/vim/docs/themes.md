# VS Code and Vim theme comparison

VS Code's user settings select `Baby Panda` in `workbench.colorTheme`. No theme
override was found in IULD8's workspace settings or the inspected user profiles.
The installed extension is `gsgualbano.baby-panda` 0.0.1.

Baby Panda is based on Panda Syntax and adds TypeScript support:
https://github.com/gsgualbano/baby-panda-vscode

An existing classic Vim port is `markvincze/panda-vim`:
https://github.com/markvincze/panda-vim

It provides `colors/panda.vim` and supports `:colorscheme panda`. This is a Panda
Syntax port, not a verified exact port of Baby Panda's TypeScript-specific
changes. The repository's last push was in 2018 at the time of this review, so
it should be tested against the fixture gallery before replacing the current
scheme. Other older ports also exist, but no exact maintained Baby Panda port
was verified.

A fresh local Baby Panda port is now implemented and activated, rather than
adopting the older generated Panda theme. It includes a matching Airline palette,
explicit language mappings, 256-color fallbacks, and background-free spelling
marks. See [the port's source, mappings, and verification](baby-panda.md).

One Monokai remains available as a fallback. Kitty's configured palette is unchanged.
