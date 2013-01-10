export PATH=/Users/g/brew/share/python:$PATH

function pyclean {
    local root=.
    if [ $# '>' 0 ]; then
        root=$1; shift
    fi
    find "$root" -name '*.pyc' -exec rm -f '{}' ';'
}
