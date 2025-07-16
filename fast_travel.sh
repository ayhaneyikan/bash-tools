#!/bin/bash

##########################################
# data structures
##########################################

# define system fast travel points
declare -A paths=(
    ["bash-tools"]="$BASH_TOOLS_DIR"
    ["development"]="$HOME/dev"
    ["todolist-cli"]="$HOME/dev/rust/todolist-cli"
)

# define shortcut aliases for each fast travel point
declare -A path_aliases=(
    ["bash-tools"]="bt bash-tools"
    ["development"]="d development"
    ["todolist-cli"]="todo todolist-cli"
)

# dynamically create map of aliases to fast travel points
declare -A location_map
function _build_location_map() {
    for path_key in "${!paths[@]}"; do
        local path="${paths[$path_key]}"
        # read the aliases into an array
        read -ra aliases <<< "${path_aliases[$path_key]}"
        # add each alias to the location map
        for alias in "${aliases[@]}"; do
            location_map[$alias]="$path"
        done
    done
}

# build the map when the script loads
_build_location_map



##########################################
# centralized help messaging
##########################################

# display available shortcuts to fast travel points
function _show_shortcuts() {
    printf "%-40s -> %s\n" "<number>" "cd up that many directories"
    for path_key in "${!paths[@]}"; do
        printf "%-40s -> %s\n" "${path_aliases[$path_key]}" "${paths[$path_key]}"
    done
}

# returns description for the given command
function _get_command_description() {
    local command=$1
    case $command in
        "ft")
            echo "Changes the current directory to the specified fast travel location."
            ;;
        "c")
            echo "Opens VSCode at the specified fast travel location."
            ;;
    esac
}

# centralized help message display
function _show_help() {
    local command=$1
    echo "Usage: $command <shortcut>"
    echo
    echo "$(_get_command_description "$command")"
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo
    _show_shortcuts
}

# centralized error handling for missing arguments
# $1: which command (i.e., `c` `ft`)
# $@: remaining args passed to the command
function _check_args() {
    local command=$1
    shift

    # check if help argument passed
    if _help_requested "$@"; then
        _show_help "$command"
        return 0
    fi

    # check if no arguments passed
    if [[ $# -eq 0 ]]; then
        echo "Error: No destination provided"
        echo "Usage: $command <shortcut>"
        echo
        _show_shortcuts
        return 1
    fi

    return 2  # indicates args are present and help not requested
}



##########################################
# fast travel implementation
##########################################

# get path from provided shortcut/alias
# returns empty string on failure
function _get_path() {
    local shortcut="$1"
    if [[ -n "${location_map[$shortcut]}" ]]; then
        echo "${location_map[$shortcut]}"
    else
        echo ""
    fi
}

# centralized path resolution and error handling
function _resolve_path() {
    local shortcut=$1

    # if the argument is a number, go back that many directories
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        local path=$(_create_cd_path "$1")
    else
        local path=$(_get_path "$shortcut")

        # exit early if invalid shortcut
        if [[ -z "$path" ]]; then
            echo "Error: Unknown location '$shortcut'"
            echo
            _show_shortcuts
            return 1
        fi
    fi

    echo "$path"
    return 0
}

# cd back the given number of dirs
function _create_cd_path() {
    local steps=$1
    local current_dir=$(pwd)

    # Check if steps is greater than 0 and handle moving backwards
    while [[ $steps -gt 0 && "$current_dir" != "/" ]]; do
        current_dir=$(dirname "$current_dir")
        ((steps--))
    done

    echo "$current_dir"
}


# fast travel to a location
function ft() {
    # check for help or insufficent args, returns 2 on success
    _check_args "ft" "$@"
    local check_result=$?

    if [[ $check_result -ne 2 ]]; then
        return $check_result
    fi

    # retrieve path associated with the given shortcut
    local path=$(_resolve_path "$1")
    if [[ $? -eq 0 ]]; then
        cd "$path"
    else
        return 1
    fi
}

# open VSCode at a location
function c() {
    # check for help or insufficent args, returns 2 on success
    _check_args "c" "$@"
    local check_result=$?

    if [[ $check_result -ne 2 ]]; then
        return $check_result
    fi

    # confirm `code` command exists
    if ! command -v code &> /dev/null; then
        echo "Error: VSCode (command 'code') not found"
        return 1
    fi

    # retrieve path associated with the given shortcut
    local path=$(_resolve_path "$1")
    if [[ $? -eq 0 ]]; then
        code "$path"
    else
        return 1
    fi
}



##########################################
# shortcut autocomplete
##########################################

# completion function for fast travel points
function _ft_c_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # extract available aliases from location_map
    local opts="$(printf "%s " "${!location_map[@]}")"

    # generate completions
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}

# register the completion function
complete -F _ft_c_completions ft
complete -F _ft_c_completions c
