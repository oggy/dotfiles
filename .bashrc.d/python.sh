export PATH=~/brew/share/python:$PATH
export PYTHONSTARTUP=~/.pythonrc

alias cdpy='cd `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`'

function pyclean {
    local root=.
    if [ $# '>' 0 ]; then
        root=$1; shift
    fi
    find "$root" -name '*.pyc' -exec rm -f '{}' ';'
}
