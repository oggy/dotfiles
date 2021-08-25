#!/bin/bash

# On MacOS, Terminal.app defines this and sets it as the default for
# PROMPT_COMMAND. Subshells inherit PROMPT_COMMAND, but not the function, so
# define it as a noop if needed for these subshells.
type update_terminal_cwd > /dev/null 2>&1 || alias update_terminal_cwd=:

# add_path VALUE ENTRY
#
# Add ENTRY to a colon-separated list of paths VALUE (like a PATH variable) if
# it's not in there yet.
add_path() {
    value="$1"
    entry="$2"

    if [[ ":$value:" = *":$entry:"* ]]; then
        echo "$value"
    else
        echo "$entry:$value"
    fi
}

# On MacOS, Terminal.app reads standard paths from /etc/paths, but not iTerm.
# Fix that.
if [ -e /etc/paths ]; then
  for dir in $(tail -r /etc/paths); do
    PATH="$(add_path $PATH $dir)"
  done
fi

# Set up PATH.
[ "$(uname)" = Darwin ] &&
  export PATH=~/brew/bin:~/brew/sbin:~/brew/share/npm/bin:$PATH
export PATH=~/bin:~/opt/bin:/usr/local/texlive/2015/bin/x86_64-darwin:$PATH
export GREP_OPTIONS='-I --exclude .svn --color'
export PAGER='less -R'

# Dump core.
ulimit -c unlimited

# Include .bashrc.d/*.sh
RC_DIR=~/.bashrc.d
if [ -d $RC_DIR ]; then
    for f in $RC_DIR/*.sh; do
        . $f
    done
fi

SITERC=~/.bashrc-site
if [ -r "$SITERC" ]; then
  . "$SITERC"
fi

# Set prompt.
if [ "$PS1" ]; then
    # Interactive
    PS1_COLOR='\[[1;36m\]'
    DEFAULT_COLOR='\[[0m\]'
    PS1_GIT_COLOR='\[[1;32m\]'
    if [ "$MRXVT_TABTITLE" ]; then
        export PS1="\[]61;\W$PS1_COLOR\]\u@\h:\w\$ $DEFAULT_COLOR"
    else
        export PS1="$PS1_COLOR\u@\h:\w$PS1_GIT_COLOR\`git-ps1\`$PS1_COLOR\$ $DEFAULT_COLOR"
    fi
fi
