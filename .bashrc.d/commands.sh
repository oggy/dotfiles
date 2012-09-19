alias gv='gv --spartan'
alias apg8='apg -m 8 -x 8 -M NCL -n 20'
alias mp='ps -ef | grep'
alias MP='sudo mp'
alias format-json='python -mjson.tool'
alias mp='ps -ef | grep -i'
alias MP='sudo ps -ef | grep -i'

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

function make-ssl-cert {
    local domain="$1"; shift
    if [ -z "$domain" ]; then
        echo "USAGE: $FUNCNAME DOMAIN" >&2
        return 1
    fi
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$domain".key -out "$domain".crt
}