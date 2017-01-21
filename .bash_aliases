#!/usr/bin/env bash
# Aliases for Mac OS X
# #######

#echo "~/.bash_aliases"

# Interactive operation...
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
  alias md='mkdir -p'

# handy shortcuts
  alias untar='tar zxvf'
  alias unbz='tar jxvf'
  alias ff='find . -not -path "*/.svn" -name $*'
  alias fff='sudo -i find / -name $*'
  alias gf='find . -path "*/.svn/*" -o -path "*/.git/*" -o -name "*.sql" -o -name "*.mysql" -o -name "*.sublime-*" -o -name "*.min.*" -prune -o -type f -print0 | xargs -0 grep -I -n'
  alias ef='find . -path "*/.svn" -prune -o -type f -print0 | xargs -0 egrep -I -n --color'

# When wget is not installed...
#  alias wget='curl -O'

# Conversions

# General laziness
  alias f='ff'
  alias c='clear && pwd && ls'
  alias s='source'
  alias p='pwd'
  alias j='jobs'
  alias x='exit'
  alias ..='cd ..'
  alias ...='cd ../..'

# Trash & Cleanup
  alias trash="mv $1 ~/.Trash"
  alias r="trash"
  alias del="trash"
  alias rmds='find . -name *.DS_Store -type f -exec rm {} \;'

# Hide files from Finder
  alias hide="SetFile -a V"
  alias show="SetFile -a v"

# Default to human readable file system stats
  alias df='df -h'
  alias du='du -h'

# Find big files
  alias b="du -k -d 1 * | sort -nr | cut -f2 | xargs du -sh"
  alias bb="du -k * | sort -nr | cut -f2 | xargs du -sh"

# Misc :)
  alias diff='diff -u'                          # default to unified diff format
  alias less='less -r'                          # raw control characters
  alias whence='type -a'                        # where, of a sort
  alias grep='grep --color'                     # show differences in colour

# Processes
  alias tu='ps aux | sort -n +2 | tail -10'  # top 10 cpu processes
  alias tm='ps aux | sort -n +3 | tail -10'  # top 10 memory processes
  alias blocking='lsof +fg +D /Volumes/$1 | grep -v EVO' #whats blocking a volume from being ejected?

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

  
# Web Developer shortcuts
  alias h='sudo -i $EDITOR  /etc/hosts'
  alias hosts='sudo -i $EDITOR /etc/hosts'
  alias myip='curl ifconfig.me'

# subversion shortcuts
  alias .c='svn commit -m'
  alias .u='svn update --ignore-externals'
  alias .s='svn status --ignore-externals'
  alias .l='svn log'
  alias .a='svn status --ignore-externals | grep "^\?" | cut -c8- | while read f; do svn add "$f"; done'
  alias .r='svn status --ignore-externals | grep "^\!" | cut -c8- | while read f; do svn rm "$f"; done'
  alias .d='svn diff --diff-cmd diff -x -up'
  alias .dd='svn diff --diff-cmd diff -x -wup'

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

# Terra
  alias t='terra'
  alias ts='terra status'
  alias taa='terra app:add'
  alias tad='terra app:remove'
  alias tea='terra environment:add'
  alias ted='terra environment:remove'

# Solr
  alias solr='cd /usr/local/solr && java -jar start.jar; cd -'
# Text Editor shortcuts
  alias e='mate'
  alias et='mate . &'
  alias ett='mate app config lib db public spec test vendor/plugins Rakefile Capfile&'
  alias dtt='mate includes modules profiles scripts sites/default/settings.php sites/all .htaccess robots.txt'

# Ruby on Rails
  alias ss='./script/server'
  alias sc='./script/console'
  alias mr='rake db:migrate'

# Drupal
  #alias drush='drush7'
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

# Sublime Text 2
  alias slt='open -b com.sublimetext.2'

# ImageOptim
  alias opt='open -a ImageOptim'
  alias mangle='open -a "Name Mangler"'
  alias alf='open -a ImageAlpha'

# Vim
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
