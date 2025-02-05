##########################################
# source other functions
##########################################

source $BASH_TOOLS_DIR/fast_travel.sh


##########################################
# helper functions
##########################################

# Checks if provided arguments contains a common help argument string
function _check_help() {
  for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" || "$arg" == "-help" || "$arg" == "--h" ]]; then
      return 0  # indicate that help was requested
    fi
  done
  return 1  # indicate that help was not requested
}



##########################################
# personal additions
##########################################

# make directory and then cd into it
function mkcd() {
  local dirname=$1
  if [ -z "$dirname" ]; then
    echo "mkcd: missing name of directory to create and enter"
    return
  fi
  mkdir $dirname && cd $dirname
}
