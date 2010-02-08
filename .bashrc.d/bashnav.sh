######################################################################
#
# Browser-like navigation commands for bash.
#
# Commands:
#   * b: go back one directory
#   * f: go forward one directory
#   * u: go to the parent directory
#   * s: show the current history and future
#
# If BASHNAV_AUTOSHOW is set to 1, the current state is shown on each
# directory change.
#
######################################################################

declare -a BASHNAV_HISTORY
declare -a BASHNAV_FUTURE

#
# Like `cd', but update bashnav's history and future.
#
function bashnav_go {
    # TODO: support -L and -P options to cd.
    local dir=$1
    if [ -z "$dir" ]; then
        dir=~
    fi
    if [ -d "$dir" ]; then
        _bashnav_history_push $PWD
        BASHNAV_FUTURE=()
    fi
    cd "$@"
    _bashnav_autoshow
}

#
# Go back one directory.
#
# If an argument `n' is given, go back n directories instead.
#
function bashnav_back {
    for i in `_bashnav_times $1`; do
        local history_length=${#BASHNAV_HISTORY[*]}
        if [ $history_length -eq 0 ]; then
          return 1
        fi
        local dir=${BASHNAV_HISTORY[history_length-1]}
        _bashnav_future_push $PWD
        _bashnav_history_pop
        cd "$dir"
    done
    _bashnav_autoshow
}

#
# Go forward one directory.
#
# If an argument `n' is given, go forward n directories instead.
#
function bashnav_forward {
    for i in `_bashnav_times $1`; do
        local future_length=${#BASHNAV_FUTURE[*]}
        if [ $future_length -eq 0 ]; then
            return 1
        fi
        local dir=${BASHNAV_FUTURE[future_length-1]}
        _bashnav_history_push $PWD
        _bashnav_future_pop
        cd "$dir"
    done
    _bashnav_autoshow
}

#
# Go up one directory.
#
# If an argument `n' is given, go up n directories instead.
#
function bashnav_up {
    local dir
    for i in `_bashnav_times $1`; do
        if [ -z "$dir" ]; then
            dir=..
        else
            dir=$dir/..
        fi
    done
    bashnav_go "$dir"
}

#
# Print the current state of bashnav.
#
function bashnav_show {
    for entry in ${BASHNAV_HISTORY[*]}; do
        echo "  $entry"
    done
    echo "* $PWD"
    local future_length=${#BASHNAV_FUTURE[*]}
    for i in `_bashnav_times $future_length descending`; do
        echo "  ${BASHNAV_FUTURE[i]}"
    done
}

function _bashnav_history_push {
    BASHNAV_HISTORY[${#BASHNAV_HISTORY[*]}]=$1
}

function _bashnav_future_push {
    BASHNAV_FUTURE[${#BASHNAV_FUTURE[*]}]=$1
}

function _bashnav_history_pop {
    unset BASHNAV_HISTORY[${#BASHNAV_HISTORY[*]}-1]
}

function _bashnav_future_pop {
    unset BASHNAV_FUTURE[${#BASHNAV_FUTURE[*]}-1]
}

function _bashnav_times {
    local n=$1
    local descending=$2

    if [ -z "$n" ]; then
        n=1
    elif [ "$n" -eq 0 ]; then
        return 0
    fi

    # GNU/Linux has seq, Mac/BSD has jot.
    if which seq 2>&1 > /dev/null; then
        if [ "$descending" ]; then
            seq $((n-1)) -1 0
        else
            seq 1 $n
        fi
    else
        if [ "$descending" ]; then
            jot $n $((n-1)) 0
        else
            jot $n
        fi
    fi
}

function _bashnav_autoshow {
    if [ "$BASHNAV_AUTOSHOW" = 1 ]; then
        bashnav_show
    fi
}

alias cd=bashnav_go
alias b=bashnav_back
alias f=bashnav_forward
alias u=bashnav_up
alias s=bashnav_show
