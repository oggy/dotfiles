# enable color support of ls and also add handy aliases
if which dircolors 2>&1 > /dev/null; then
    eval `dircolors`
fi

if [ `uname` = 'Darwin' ]; then
    # Mac: gls is part of the coreutils port
    export LS='gls --color=auto '
else
    export LS='ls --color=auto '
fi
alias ls="$LS"

alias ll="$LS -l"
alias lld="$LS -ld"
alias lr="$LS -ltr"

# ls and less in one
function l {
    if [ $# -eq 0 ]; then
        $PAGER
    elif [ $# -eq 1 -a -f "$1" ]; then
        $PAGER "$1"
    else
        $LS -l --color=always $*
    fi
}
