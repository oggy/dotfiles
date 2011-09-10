alias gv='gv --spartan'
alias apg8='apg -m 8 -x 8 -M NCL -n 20'

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
