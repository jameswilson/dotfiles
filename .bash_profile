#!/bin/bash
# ~/.bash_profile: executed by bash for login shells.

#echo "~/.bash_profile"

[ -r "${HOME}/.bashrc" ]            && . "${HOME}/.bashrc";
[ -r "${HOME}/.bash_aliases" ]      && . "${HOME}/.bash_aliases";
[ -r "${HOME}/.bash_environment" ]  && . "${HOME}/.bash_environment";
[ -r "${HOME}/.drush_bashrc" ]      && . "${HOME}/.drush_bashrc";
[ -d "${HOME}/bin" ]   && PATH=${HOME}/bin:${PATH}
[ -d "${HOME}/man" ]   && MANPATH=${HOME}/man:${MANPATH}
[ -d "${HOME}/info" ]  && INFOPATH=${HOME}/info:${INFOPATH}

fortune -s

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# Initialization for FDK command line tools.Fri Jan  2 10:02:53 2015
FDK_EXE="$HOME/bin/FDK/Tools/osx"
PATH=${PATH}:"$HOME/bin/FDK/Tools/osx"
export PATH
export FDK_EXE

# The next line updates PATH for the Google Cloud SDK.
source "$HOME/google-cloud-sdk/path.bash.inc"

# The next line enables bash completion for gcloud.
source "$HOME/google-cloud-sdk/completion.bash.inc"
