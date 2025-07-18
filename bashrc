# ~/.bashrc: executed by bash(1) for non-login shells.

##########################################
# general setup
##########################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=5000

# set time format env var
export HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"



##########################################
# environment variables
##########################################

export DEV_HOME=$HOME/dev
export BASH_TOOLS_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")



##########################################
# other sources
##########################################

source $BASH_TOOLS_DIR/aliases.sh
source $BASH_TOOLS_DIR/functions.sh
source $BASH_TOOLS_DIR/command_line.sh
