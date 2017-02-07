#!/usr/bin/env bash
# Aliases for Mac OS X
# #######

#echo "~/.bash_aliases"

# Interactive operation...
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
  alias md='mkdir -p'

# Handy shortcuts
  alias untar='tar zxvf'
  alias unbz='tar jxvf'
  alias trash="mv $1 ~/.Trash"
  alias del="trash"
  alias whence='type -a'          # An improved `where`.
  alias hide="SetFile -a V"       # Hide files from Finder (Mac only)
  alias show="SetFile -a v"       # Unhide files from Finder (Mac only)

# Remove those crazy .DS_Store files recursively
  alias rmds='find . -name *.DS_Store -type f -exec rm {} \;'

# When `wget` is not installed...
#  alias wget='curl -O'

# Some shortcuts for different directory listings
  alias ls='ls -GFh'      # classify files in colour
  alias l='ls -GFh1'       #
  alias ll='ls -GlFh'       # long list
  alias lll='ls -GAlF'     # long list including hidden files
  alias la='lll'      # all but . and ..
  alias lla='lll'     #
  alias dir='lll'
  alias vdir='ls'
  alias list='l'

# Colorized and human readable defaults
  alias grep='grep --color'   # Highlight the found results.
  alias df='df -h'            # Human readable file system stats
  alias du='du -h'            #

# Improved recursive find with grep, exclude common big nasty files.
  alias gf='find . -path "*/.git/*" -o -name "*.sql" -o -name "*.mysql" -o -name "*.sublime-*" -o -name "*.min.*" -prune -o -type f -print0 | xargs -0 grep -I -n'

# Find big files
  alias b="du -k -d 1 * | sort -nr | cut -f2 | xargs du -sh"
  alias bb="du -k * | sort -nr | cut -f2 | xargs du -sh"

# Processes
  alias tu='ps aux | sort -n +2 | tail -10'  # top 10 cpu processes
  alias tm='ps aux | sort -n +3 | tail -10'  # top 10 memory processes

# What's blocking a volume from being ejected?
  alias blocking='lsof +fg +D /Volumes/$1 | grep -v EVO'

# Miscellaneous preferences
  alias diff='diff -u'                       # default to unified diff format
  alias less='less -r'                       # raw control characters

# Web Developer shortcuts
  alias hosts='sudo -i $EDITOR /etc/hosts'
  alias h='hosts'
  alias myip='curl ifconfig.me'

# git shortcuts
  alias g='git status .'
  alias gg='git status'
  alias gt='git tree'
  alias gd='git diff'
  alias gl='git log --graph --oneline --all --decorate'
  alias gk='git log --color --format="format:%C(auto)%h %Cred%<(8,trunc)%aN  %Cblue%<(12)%ar %Creset%s"'
  # Add all unstaged files in the current directory and below.
  alias .ga='git status -s . | grep "^??" | cut -c4- | while read f; do git add "$f"; done'
  # Delete any missing files from git.
  alias .gd='git status -s . | grep "^!!" | cut -c4- | while read f; do git delete "$f"; done'
  # Remove all unstaged files in the current directory and below (the inverse of .ga)
  alias .gr='git status -s . | grep "^??" | cut -c4- | while read f; do rm -f "$f"; done'
  # Undo mode changes (755 <-> 644).
  alias .gm="git diff --summary | grep --color 'mode change 100755 => 100644' | cut -d' ' -f7- | xargs chmod +x &&  git diff --summary | grep --color 'mode change 100644 => 100755' | cut -d' ' -f7- | xargs chmod -x"

# Docker
  alias dp='docker ps'
  alias dpa='docker ps -a'

# Solr
  alias solr='cd /usr/local/solr && java -jar start.jar; cd -'

# Drupal
  alias drush8='/usr/local/drush/drush8/vendor/bin/drush'
  alias drush7='/usr/local/drush/drush7/vendor/bin/drush'
  alias drush6='/usr/local/drush/drush6/vendor/bin/drush'
  alias drush5='/usr/local/drush/drush5/drush'
  alias dg='drush dl --package-handler=git_drupalorg'

  # Drupal 8 cache clear css-js only
  alias dcc='drush ev "\Drupal::service(\"asset.css.collection_optimizer\")->deleteAll(); \Drupal::service(\"asset.js.collection_optimizer\")->deleteAll(); _drupal_flush_css_js();"'

# Photoshop & Illustrator
  alias psp='open -b com.adobe.Photoshop'
  alias ai='open -b com.adobe.Illustrator'

# ImageOptim
  alias opt='open -a ImageOptim'
  alias mangle='open -a "Name Mangler"'
  alias alf='open -a ImageAlpha'

# Use macvim, if installed.
if [[ -r mvim ]]
then
   alias vim='mvim -v'
fi

# Platform.sh
  alias p='platform'

# Jilla (JIRA CLI)
  alias j="jilla describe"
  alias js="jilla ls"
  alias jpi="jilla ls | grep $1"
