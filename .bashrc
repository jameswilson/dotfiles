#!/usr/bin/env bash
# ~/.bashrc: executed by Interactive non-login shells.

# Execute bash helper scripts.
function src() { [ -r "$1" ] && . "$1"; }
src $HOME/.bash_environment
src $HOME/.bash_completion
src $HOME/.bash_aliases
src $HOME/.bash_prompt

# Setup drush.
src $HOME/.drush_bashrc

# Register rvm function as a command for cli.
src $HOME/.rvm/scripts/rvm

# Register nvm function as a command for cli
src $(brew --prefix nvm)/nvm.sh

# Update PATH for the Google Cloud SDK.
src $HOME/.google-cloud-sdk/path.bash.inc

# Enable bash completion for Google Cloud.
src $HOME/.google-cloud-sdk/completion.bash.inc

# Enable bash completion for Drupal Console.
src $HOME/.console/console.rc

# Git bash completion
src $HOME/.git-completion.sh

# RVM Bash Completions
src $rvm_path/scripts/completion

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Ignore typos when changing directories, for example:
# cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Prevent Mac OSX dot-underscore in tarfiles.
export COPYFILE_DISABLE=true

# Directory-specific environment variables!
# ENSURE THIS IS ALWAYS THE LAST TO EXECUTE IN THIS FILE
# http://direnv.net/
eval "$(direnv hook bash)"
