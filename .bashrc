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

# If running interactively, then:
if [ "$PS1" ]; then
    # sdu [DIR] [NUM]
    #
    # List the NUM biggest files in DIR.
    #   * DIR defaults to .
    #   * NUM defaults to 25
    function sdu {
      local dir=$1
      local num=$2
      if [ -z "$dir" ]; then dir=. ; fi
      if [ -z "$num" ]; then num=25; fi
      du -ks "$dir"/* | sort -nr | head -n "$num"
    }

    function usd { cd "/usr/share/doc/$1"; }

    alias gv='gv --spartan'
    alias a='sudo aptitude'
    alias apg8='apg -m 8 -x 8 -M NCL -n 20'

    # give the sudo'ed user access to the current user's PATH.  This
    # does stuff up the sudo command in that options given go to su
    # rather than sudo, so this might prove sucky...
    if [ `uname` != 'Darwin' ]; then
        function sudo {
          `which sudo` su -p -l -c "$*"
        }
    fi
fi

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
