this is the contents of my personal ~/  folder on my development machine

It is customized for my development preferences:

* Mac OS X.
* Homebrew.
* iTerm with Snazzy colors and Meslo Nerd Font.
* vim, with spf13-vim distro.
* zsh shell with oh-my-zsh and powerlevel10k theme.

## Installation

https://wiki.archlinux.org/title/Dotfiles

1) Clone the repository.

        $ cd $HOME
        $ git clone --bare <git-repo-url> $HOME/.dotfiles
        $ alias dotfiles='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
        $ dotfiles checkout
        $ dotfiles config --local status.showUntrackedFiles no

2) Customize .gitconfig.local

Copy .gitconfig.local.dist to .gitconfig.local and customize accordingly.

4.  Install Homebrew.

        ~/.local/bin/brew.sh
