#!/bin/bash

# Fast Travel
# fast travels to a key repository based on the provided dir name / shortcut
# if provided a number, jumps out that many dirs
function ft() {
    local jump=${1:-1}
    local cmd="cd "

    if [ $# -eq 0 ] || _check_help "$@"; then
        echo "Fast-Travel Help Menu:"
        echo "-----------"
        echo "-----------"
        return 0
    fi

    # if letter(s), fast travel to specified dir
    if [[ "$jump" =~ ^[a-zA-Z]+$ ]]; then
        case $jump in
            [Dd])
                cmd+="build/debug/bin"
                ;;
            [Rr]|[Rr][Ee][Ll][Ee][Aa][Ss][Ee])
                cmd+="build/release/bin"
                ;;
            *)
                cmd+="$jump"
                echo $cmd
                ;;
        esac
    # if number, back out that many dirs
    elif [[ "$jump" =~ ^[0-9]+$ ]]; then
        for ((i = 1; i <= jump; i++)); do
            cmd+="../"
        done
    fi

    $cmd
}

# Fast Travel Code
# opens a vscode window of the provided repository name / shortcut
function ftc() {
    local original_loc=$(pwd)
    ft $@
    # if fast-travel was unsuccessful, exit early
    if [ $? -ne 0 ]; then
        return 1
    fi
    code . && cd $original_loc
}
