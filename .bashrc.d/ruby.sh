alias gemls='gem list -rd --no-update-sources | less'
alias gemup='gem sources -u'
alias gemr='rake gem && gemu && gemi'

export USE_ALLISON=''
function rdoc {
    if [ "$USE_ALLISON" ]; then
        allison $@
    else
        rdoc $@
    fi
}

function cdrg {
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

function in_snailgun_shell {
    local ppid=`ps -p $$ -o ppid=`
    ps -o command= -p "$ppid" | grep snailgun > /dev/null
}

function ruby-ps1 {
    if in_snailgun_shell; then
        echo -n "$PS1_RUBY_COLOR[@]$PS1_COLOR "
    fi
}
