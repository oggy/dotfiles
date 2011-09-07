if which xemacs > /dev/null; then
    export EDITOR="xemacs -nw"
elif which emacs > /dev/null; then
    export EDITOR="emacs -nw"
elif which vim > /dev/null; then
    export EDITOR="vim"
elif which vi > /dev/null; then
    export EDITOR="vi"
fi

if [ "$PS1" ]; then
    # Interactive
    alias e="$EDITOR"
    alias E="sudo $EDITOR"
fi

alias bashrc="$EDITOR ~/.bashrc"
alias bashrcs="$EDITOR ~/.bashrc-site"
