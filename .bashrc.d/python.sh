export PATH=~/brew/share/python:$PATH
export PYTHONSTARTUP=~/.pythonrc

alias cdpy='cd `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`'

pyclean() {
    local root=.
    if [ $# '>' 0 ]; then
        root=$1; shift
    fi
    find "$root" -name '*.pyc' -exec rm -f '{}' ';'
}

export PROMPT_COMMAND="virtualenv-auto-activate; $PROMPT_COMMAND"
export VIRTUALENV_ROOT=

virtualenv-auto-activate() {
    local root=`virtualenv-find-root`
    if [ "$root" != "$VIRTUALENV_ROOT" ]; then
        if [ -n "$VIRTUALENV_ROOT" ]; then
            VIRTUALENV_ROOT=
            deactivate
        else
            VIRTUALENV_ROOT="$root"
            source "$root/env/bin/activate"
        fi
    fi
}

virtualenv-find-root() {
    local dir=`pwd`
    while [ -n "$dir" ]; do
        if [ -e "$dir/env/bin/activate" ]; then
            echo -n "$dir"
            return 0
        fi
        dir=${dir%/*}
    done
    return 1
}
