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
alias e=~/.emacs.d/bin/open
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
