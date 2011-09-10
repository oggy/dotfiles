#!/bin/sh

function paths() {
    ls -1 $* 2> /dev/null | tr '\n' ':' | sed -e "s/\([][{}()'\"|~\\\`!@#$%^&*]\)/\\\1/g"
}

export PATH=~/bin:`paths -d ~/local/*/bin``paths -d /usr/local/*/bin`/opt/local/bin:$PATH
export GREP_OPTIONS='-I --exclude .svn --color'
export PAGER='less -R'
export RI='-f ansi'

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
    PS1_RUBY_COLOR='\[[1;31m\]'
    if [ "$MRXVT_TABTITLE" ]; then
        export PS1="\[]61;\W$PS1_COLOR\]\u@\h:\w\$ $DEFAULT_COLOR"
    else
        export PS1="$PS1_RUBY_COLOR\`ruby-ps1\`$PS1_COLOR\u@\h:\w$PS1_GIT_COLOR\`git-ps1\`$PS1_COLOR\$ $DEFAULT_COLOR"
    fi
fi
