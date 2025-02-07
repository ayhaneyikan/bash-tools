# general
alias ..='cd ..'
alias b='cd -'

# grep colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# podman aliases
alias pi='podman images --sort repository'
alias pp='podman ps -a'

# ls aliases
alias l='ls --color=auto -CF1'
alias ls='ls --color=auto'
alias ls='ls --color=auto -CF'
alias la='ls --color=auto -aCF'
alias ll='ls --color=auto -lhF'
alias lla='ls --color=auto -alhF'

# git aliases
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias grs='git restore --staged'
alias gsl='git stash list'
alias gsp='git stash push'
alias gsa='git stash apply'
