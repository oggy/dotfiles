export RI='-f ansi'
export RUBY_GC_HEAP_INIT_SLOTS=600000
export RUBY_GC_MALLOC_LIMIT=59000000
export RUBY_HEAP_FREE_MIN=100000

export LOOKSEE_EDITOR="atom %f:%l"

alias gemls='gem list -rd --no-update-sources | less'
alias gemup='gem sources -u'
alias gemr='rake gem && gemu && gemi'
alias cdrl="cd \`ruby -rrbconfig -e 'puts (defined?(RbConfig) ? RbConfig : Config)::CONFIG[\"rubylibdir\"]'\`"
alias be='bundle exec'

brake() {
    if [ -e bin/rake ]; then
        bin/rake "$@"
    else
        bundle exec rake "$@"
    fi
}

cdrg() {
    if [ $# -eq 0 ]; then
        cd `gem env gemdir`/gems
    elif gem fuzzy --exactly-one $@ > /dev/null; then
        local dir=`gem fuzzy -f '%path' $@`
        if [ -d $dir/lib ]; then
            cd $dir/lib
        else
            cd $dir
        fi
    fi
}

cdbg() {
    if [ $# -eq 1 ]; then
        local dir=`bundle show $1`
        if [ "$?" -eq 0 ]; then
          cd `bundle show $1`
        else
          echo "$dir" >&2
        fi
    else
        echo "USAGE: $FUNCNAME GEM" >&2
        return 1
    fi
}

default-ruby-version() {
    cd
    rbenv version-name
    cd - > /dev/null
}

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
which -s rbenv && eval "$(rbenv init -)"
