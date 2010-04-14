#!/bin/bash
# Aliases
# #######

#echo "~/.bash_aliases"

# Interactive operation...
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
  alias md='mkdir -p'

# handy shortcuts
  alias untar='tar zxvf'
  alias ubbz2='tar jxvf'
  alias ff='find . -name $*'
  alias fff='sudo find / -name $*'
  alias wget='curl -O'

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
  alias hide="/Developer/Tools/SetFile -a V"
  alias show="/Developer/Tools/SetFile -a v"

# Default to human readable figures
  alias df='df -h'
  alias du='du -h'

# Misc :)
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
# Webdev
  alias h='sudo vim /etc/hosts'
  alias hosts='sudo $EDITOR /etc/hosts'

# Apache 
  alias vh='sudo vim /etc/apache2/extra/httpd-vhosts.conf && sudo apachectl restart'
  alias vhosts='sudo $EDITOR /etc/apache2/extra/httpd-vhosts.conf'
  alias astart='sudo arch -i386 /usr/local/php5/bin/apachectl start'
  alias astop='sudo apachectl stop'
  alias ares='sudo arch -i386 /usr/local/php5/bin/apachectl restart'

# MySQL
  alias mstart='sudo /usr/local/mysql/support-files/mysql.server start'
  alias mstop='sudo /usr/local/mysql/support-files/mysql.server stop'
  alias mres='sudo /usr/local/mysql/support-files/mysql.server restart'
  alias mstat='sudo /usr/local/mysql/support-files/mysql.server status'
  alias mload='sudo /usr/local/mysql/support-files/mysql.server reload'

# subversion shortcuts
  alias .c='svn ci -m'
  alias .u='svn update'
  alias .s='svn status'
  alias .l='svn log'
  alias .a='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
  alias .d='svn status | grep "^\!" | awk "{print \$2}" | xargs svn delete'

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
  alias dhead='cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal checkout drupal'
  alias d6='cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal co -r DRUPAL-6 drupal'
  alias d69='cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal co -r DRUPAL-6-9 drupal'

