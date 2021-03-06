alias gv='gv --spartan'
alias apg8='apg -m 8 -x 8 -M NCL -n 20'
alias iex='rlwrap --always-readline iex'
alias format-json='python -mjson.tool'
alias psg='ps -ef | grep -i'
alias PSG='sudo ps -ef | grep -i'

alias r='R --no-save'

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
    du -ks "$dir"/* "$dir"/.[^.]* | sort -nr | head -n "$num"
}

function make-ssl-cert {
    local domain="$1"; shift
    if [ -z "$domain" ]; then
        echo "USAGE: $FUNCNAME DOMAIN" >&2
        return 1
    fi
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$domain".key -out "$domain".crt
}

ssh-forget() {
    if [ $# -ne 1 ]; then
        echo "USAGE: $0 LINE-NUMBER" &2
    fi
    local target=~/.ssh/known_hosts
    sed -n "${1}!p" "$target" > "$target.tmp"
    mv "$target.tmp" "$target"
}
