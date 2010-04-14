#!/usr/bin/sh
# Aliases
# #######

# Interactive operation...
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'
 alias md='mkdir -p'
 alias ff='find . -name $*'


# General laziness
 alias f='ff'
 alias c='clear && pwd && ls'
 alias s='source'
 alias p='pwd'
 alias j='jobs'
 alias x='exit'
 alias ..='cd ..'
 alias ...='cd ../..'

# Trash
 alias trash="mv $1 ~/.Trash"
 alias r="trash"
 alias del="trash"

# Hide files from Finder
 alias hide="/Developer/Tools/SetFile -a V"
 alias show="/Developer/Tools/SetFile -a v"


# Default to human readable figures
 alias df='df -h'
 alias du='du -h'

 alias untar='tar zxvf'
 alias ubbz2='tar jxvf'


# Misc :)
 alias less='less -r'                          # raw control characters
 alias whence='type -a'                        # where, of a sort
 alias grep='grep --color'                     # show differences in colour
 alias killds='find . -name *.DS_Store -type f -exec rm {} \;'



# Processes
 alias tu='ps aux | sort -n +2 | tail -10'  # top 10 cpu processes
 alias tm='ps aux | sort -n +3 | tail -10'  # top 10 memory processes
 alias blocking='lsof +fg +D /Volumes/$1 | grep -v EVO' #whats blocking a volume from being ejected?

# Some shortcuts for different directory listings
alias dir='ls -GF'
alias vdir='ls'
alias ls='ls -GFh'      # classify files in colour
alias l='ls -GFh'        #
alias ll='ls -Gl'       # long list
alias la='ls -GAl'      # all but . and ..
alias lla='ls -Gal'     #

alias hosts='sudo $EDITOR /etc/hosts'

# subversion shortcuts
alias .c='svn ci -m'
alias .u='svn update'
alias .s='svn status'
alias .l='svn log'
alias .all='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'

# Text Editor shortcuts
alias e='mate'
alias et='mate . &'
alias ett='mate app config lib db public spec test vendor/plugins Rakefile Capfile&'
alias dtt='mate includes modules profiles scripts sites/default/settings.php sites/all .htaccess robots.txt'

# Ruby on Rails
alias ss='./script/server'
alias sc='./script/console'
alias mr='rake db:migrate'

