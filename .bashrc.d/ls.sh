# enable color support of ls and also add handy aliases
if which dircolors 2>&1 > /dev/null; then
    eval `dircolors`
fi

export LS=ls
export CLICOLOR=1

alias ll="$LS -alF"
alias lld="$LS -ald"
alias lr="$LS -alFtr"

# ls and less in one
l() {
    if [ $# -eq 0 ]; then
        $PAGER
    elif [ $# -eq 1 -a -f "$1" ]; then
        $PAGER -N "$1"
    else
        $LS -l $*
    fi
}
