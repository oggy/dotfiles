if which vim > /dev/null; then
    export EDITOR="vim"
elif which vi > /dev/null; then
    export EDITOR="vi"
fi

if [ "$PS1" ]; then
    # Interactive
    alias ee="$EDITOR"
    alias EE="sudo $EDITOR"
fi

alias bashrc="$EDITOR ~/.bashrc"
alias bashrcs="$EDITOR ~/.bashrc-site"
