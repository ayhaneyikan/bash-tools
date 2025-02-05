##########################################
# command line prompt
##########################################

# parse git branch for use in commandline prompt
_parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\(\1\)/p'
}
# function to output desired color code
_color() {
  case $1 in
    GREY) echo -e "\[\033[38;5;8m\]" ;;
    GREEN) echo -e "\[\033[38;5;2m\]" ;;
    YELLOW) echo -e "\[\033[38;5;3m\]" ;;
    L_BLUE) echo -e "\[\033[38;5;6m\]" ;;
    L_PURPLE) echo -e "\[\033[38;5;13m\]" ;;
    RESET) echo -e "\[\033[0m\]" ;;
  esac
}

# if root user, add indicator string to command line
[ $(id -u) = 0 ] && user="$(color YELLOW)root " || user=""
# set command line string
export PS1="\\n$(color GREY)\D{%H:%M:%S} $(color GREEN)\h $user$(color L_PURPLE)\w $(color L_BLUE)\$(parse_git_branch)$(color GREY)\\n\$$(color RESET) "



##########################################
# environment variables
##########################################

export DEV_HOME=$HOME/dev
export BASH_TOOLS_DIR=$(pwd $(cd $(dirname $BASH_SOURCE[0])))



##########################################
# other sources
##########################################

source $BASH_TOOLS_DIR/aliases.sh
source $BASH_TOOLS_DIR/functions.sh
