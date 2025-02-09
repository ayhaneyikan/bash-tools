##########################################
# command line prompt
##########################################

# parses current conda env if available
function _parse_conda_env() {
  if [[ -z $CONDA_DEFAULT_ENV ]]; then
    echo ''
  else
    echo "[$CONDA_DEFAULT_ENV] "
  fi
}

# parse git branch for use in commandline prompt
function _parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\(\1\) /p'
}

# function to output desired color code
function _color() {
  case $1 in
    GREY) echo -e "\[\033[38;5;8m\]" ;;
    GREEN) echo -e "\[\033[38;5;2m\]" ;;
    YELLOW) echo -e "\[\033[38;5;3m\]" ;;
    L_BLUE) echo -e "\[\033[38;5;6m\]" ;;
    L_PURPLE) echo -e "\[\033[38;5;13m\]" ;;
    RESET) echo -e "\[\033[0m\]" ;;
  esac
}

#
# prompt options

# prompt option: timestamp, hostname, ws, git, newline
function _multi_line_prompt() {
  # if root user, add indicator string to command line
  [ $(id -u) = 0 ] && root_user="$(color YELLOW)root " || root_user=""

  echo -e "\\n$(_color GREY)\D{%H:%M:%S} $(_color GREEN)\h $root_user$(_color L_PURPLE)\w $(_color L_BLUE)\$(_parse_git_branch)$(_color GREY)\\n\$$(_color RESET) "
}

# simple prompt: conda, ws, git
function _simple_prompt() {
  echo -e "\[\033[91m\]\$(_parse_conda_env)\[\033[96m\]\w\[\033[92m\] \$(_parse_git_branch)\[\033[37m\]> "
}


# set command line string
export PS1=$(_simple_prompt)
