#!/usr/bin/env bash
# ~/.bash_profile: executed by bash for interactive login shells.

# Tell my fortune
if type fortune >/dev/null 2>&1; then
  fortune -s
fi

source ~/.profile
source ~/.bashrc
