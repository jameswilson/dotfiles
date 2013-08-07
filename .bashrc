#!/bin/bash
# User dependent .bashrc file

#echo "~/.bashrc"

# Shell Options
# #############

# Make bash append rather than overwrite the history on disk
 shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
 shopt -s cdspell


# History Options
# ###############

# Don't put duplicate lines in the history.
 export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
 export HISTIGNORE="[   ]*:&:bg:fg:exit:ls:la:lla:l"

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"


# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }


# COMMAND PROMPT
################
# * \e[ - Indicates the beginning of color prompt
# * x;ym - Indicates color code. Use the color code values mentioned below.
# * \e[m - indicates the end of color prompt
# Black 0;30
# Blue 0;34
# Green 0;32
# Cyan 0;36
# Red 0;31
# Purple 0;35
# Brown 0;33

# * 0 - Black
# * 1 - Red
# * 2 - Green
# * 3 - Yellow
# * 4 - Blue
# * 5 - Magenta
# * 6 - Cyan
# * 7 - White


   # Foreground Colors
   FG_BLACK='\e[0;30m'
    FG_BLUE='\e[0;34m'
   FG_GREEN='\e[0;32m'
    FG_CYAN='\e[0;36m'
     FG_RED='\e[0;31m'
  FG_PURPLE='\e[0;35m'
   FG_BROWN='\e[0;33m'

     # Color Shorthand
     BLACK='\[\e[30m\]'
       RED='\[\e[31m\]'
     GREEN='\[\e[32m\]'
    YELLOW='\[\e[33m\]'
      BLUE='\[\e[34m\]'
    PURPLE='\[\e[35m\]'
      CYAN='\[\e[36m\]'
     WHITE='\[\e[37m\]'
      GRAY='\[\e[40m\]'
    LT_RED='\[\e[41m\]'
  LT_GREEN='\[\e[42m\]'
 LT_YELLOW='\[\e[43m\]'
   LT_BLUE='\[\e[44m\]'
 LT_PURPLE='\[\e[45m\]'
   LT_CYAN='\[\e[46m\]'
   LT_GRAY='\[\e[47m\]'


   FGCOLOR='\e[0;34m'
  ENDCOLOR='\e[m'
   BGCOLOR='\e[0m'
   # BGCOLOR='\e[41m'
   # BGCOLOR='\e[42m'
   # BGCOLOR='\e[43m'
   # BGCOLOR='\e[44m'
   # BGCOLOR='\e[45m'
   # BGCOLOR='\e[46m'
   # BGCOLOR='\e[47m'


# Show git unstaged items with a star and staged items with a plus in the prompt
GIT_PS1_SHOWDIRTYSTATE=1

# Show git upstream changes in the prompt; 'verbose' shows the number of commits.
# < means you are behind remote
# > means you are ahead of remote
# <> means you have diverged
# = means there is no difference
GIT_PS1_SHOWUPSTREAM=1

# Terminal window title (user@host ~/path)
TITLE="\[\e]0;\u@\h \w\a\]"

# Custom command prompt (based on Cygwin)
PS1="\n$FG_BLUE# \u@\h $YELLOW\w $FG_CYAN$(__git_ps1 "[%s]")\n$BLUE# $ENDCOLOR"

function pathmunge () {
if [ -d $1 ] && ! echo $PATH | /usr/bin/egrep -q "(^|:)$1($|:)"
then
        if [ "$2" = "after" ]
        then
                PATH=$PATH:$1
        else
                PATH=$1:$PATH
        fi
fi
}


pathmunge ${RUN}/bin

# Macports
pathmunge /opt/local/bin
pathmunge /opt/local/sbin

# Local 
pathmunge /usr/local/php5/bin

# Git dude repo monitoring service
# arg1: "stop" or "start"
function gd(){
    val="$1"

    if [ $val == "start" ]; then
        git dude ~/.git-dude &>/dev/null &
        printf "git-dude started\n"
    elif [ $val == "stop" ];    then
        ps aux | grep 'git[ -]dude' | awk '{print $2}' | xargs sudo kill -9
        printf "git-dude stopped\n"
    else
        printf "$val not valid. Use start/stop\n"
    fi
}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
