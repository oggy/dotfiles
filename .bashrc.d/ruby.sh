export RUBY_HEAP_MIN_SLOTS=600000
export RUBY_GC_MALLOC_LIMIT=59000000
export RUBY_HEAP_FREE_MIN=100000

export SNAILGUN_SHELL_OPTS="-l"

alias gemls='gem list -rd --no-update-sources | less'
alias gemup='gem sources -u'
alias gemr='rake gem && gemu && gemi'

export USE_ALLISON=''
rdoc() {
    if [ "$USE_ALLISON" ]; then
        allison $@
    else
        rdoc $@
    fi
}

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

in_snailgun_shell() {
    local ppid=`ps -p $$ -o ppid=`
    ps -o command= -p "$ppid" | grep snailgun > /dev/null
}

ruby-ps1() {
    if in_snailgun_shell; then
        echo -n "[@] "
    fi
    local prompt=`rvm-prompt --no-default`
    if [ -n "$prompt" ]; then
        echo -n "[$prompt] "
    fi
}

# RVM
if [ -s ~/.rvm/scripts/rvm ]; then
  . ~/.rvm/scripts/rvm
fi
