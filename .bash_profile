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

