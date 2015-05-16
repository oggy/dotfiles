export RI='-f ansi'
export RUBY_GC_HEAP_INIT_SLOTS=600000
export RUBY_GC_MALLOC_LIMIT=59000000
export RUBY_HEAP_FREE_MIN=100000

export LOOKSEE_EDITOR="$EDITOR +%l %f"
export SNAILGUN_SHELL_OPTS="-l"

alias gemls='gem list -rd --no-update-sources | less'
alias gemup='gem sources -u'
alias gemr='rake gem && gemu && gemi'
alias brake='bundle exec rake'
alias cdrl="cd \`ruby -rrbconfig -e 'puts (defined?(RbConfig) ? RbConfig : Config)::CONFIG[\"rubylibdir\"]'\`"
alias be='bundle exec'

cdrg() {
    if [ $# -eq 0 ]; then
        cd `gem env gemdir`/gems
    elif gem info --exactly-one $@ > /dev/null; then
        local dir=`gem info -f '%path' $@`
        if [ -d $dir/lib ]; then
            cd $dir/lib
        else
            cd $dir
        fi
    fi
}

cdbg() {
    if [ $# -eq 1 ]; then
        cd `bundle list $1`
    else
        echo "USAGE: $FUNCNAME GEM" >&2
        return 1
    fi
}

in_snailgun_shell() {
    local ppid=`ps -p $$ -o ppid=`
    ps -o command= -p "$ppid" | grep snailgun > /dev/null
}

ruby-ps1() {
    if in_snailgun_shell; then
        echo -n "[@] "
    fi
    local prompt=`rvm-prompt`
    if [ -n "$prompt" ]; then
        echo -n "[$prompt] "
    fi
}

ruby-rvm-prompt() {
    if [ -z "$RUBY_RVM_PROMPT" ]; then
        export RUBY_RVM_PROMPT=1
        PS1_RUBY_COLOR='\[[1;31m\]'
        export PS1="$PS1_RUBY_COLOR\`ruby-ps1\`$PS1"
    fi
}

# RVM
if [ -s ~/.rvm/scripts/rvm ]; then
  . ~/.rvm/scripts/rvm
fi
