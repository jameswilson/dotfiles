#!/usr/bin/env bash

# Install command-line tools using Homebrew.
if ! command -v brew 2>&1 >/dev/null
then
  echo "brew command could not be found; installing Homebrew..."
  echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install iTerm2
if [ ! -d /Applications/iTerm.app ]
then
  brew install iterm2
fi

# Install GNU core utilities (those that come with macOS are outdated).
# This requires `$(brew --prefix coreutils)/libexec/gnubin` in $PATH.
# @see ~/.environment
brew install coreutils
# Install some other useful utilities like `parallel`, `ts`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
# This requires `$(brew --prefix findutils)/libexec/gnubin` in $PATH.
# @see ~/.environment
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

# Install latest versions of some macOS tools.
brew install grep
brew install screen
brew install vim
brew install git

# Install programming language packs.
brew install python
brew install go
brew install nvm
brew install node

# Install Ruby for running Jekyll locally
# Following https://jekyllrb.com/docs/installation/macos/
# See also ~/.environment
brew install chruby ruby-install
source $(brew --prefix chruby)/share/chruby/chruby.sh
source $(brew --prefix chruby)/share/chruby/auto.sh
ruby-install ruby 3.4.1
chruby ruby-3.4.1
gem install jekyll

# Install other useful binaries.
brew install imagemagick
brew install wget
brew install tree
brew install direnv
brew install svgo
brew install zsh-syntax-highlighting
brew install awscli


# Install macOs Quick Look plugins.
# Try also `brew search --desc "Quick Look plugin"`
brew install qlcolorcode
brew install qlstephen
brew install qlmarkdown
brew install quicklook-json
brew install betterzip
brew install qlprettypatch
brew install webpquicklook
brew install suspicious-package
brew install syntax-highlight

# Install developer tools.
brew install ddev/ddev/ddev

# Remove outdated versions from the cellar.
brew cleanup
