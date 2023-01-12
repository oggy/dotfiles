export PYTHONSTARTUP=~/.pythonrc

alias cdpy='cd `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`'

pyclean() {
    local root=.
    if [ $# '>' 0 ]; then
        root=$1; shift
    fi
    find "$root" -name '*.pyc' -exec rm -f '{}' ';'
}

export PROMPT_COMMAND="venv-auto-activate; $PROMPT_COMMAND"
export VIRTUALENV_ROOT=

venv-auto-activate() {
    local root=`venv-find-root`
    if [ "$root" != "$VIRTUALENV_ROOT" ]; then
        if [ -n "$VIRTUALENV_ROOT" ]; then
            VIRTUALENV_ROOT=
            deactivate
        else
            VIRTUALENV_ROOT="$root"
            if [ -e "$root/venv/bin/activate" ]; then
                source "$root/venv/bin/activate"
            fi
        fi
    fi
}

venv-find-root() {
    local dir=`pwd`
    while [ -n "$dir" ]; do
        if [ -e "$dir/venv/bin/activate" ]; then
            echo -n "$dir"
            return 0
        fi
        dir=${dir%/*}
    done
    return 1
}
