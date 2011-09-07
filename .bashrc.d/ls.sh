# enable color support of ls and also add handy aliases
if which dircolors 2>&1 > /dev/null; then
    eval `dircolors`
fi

export LS=ls
export CLICOLOR=1

alias ll="$LS -l"
alias lld="$LS -ld"
alias lr="$LS -ltr"

# ls and less in one
l() {
    if [ $# -eq 0 ]; then
        $PAGER
    elif [ $# -eq 1 -a -f "$1" ]; then
        $PAGER "$1"
    else
        $LS -l --color=always $*
    fi
}
