export LESS='-f -R -P%f, lines %lt-%lb of %L$'

which -s source-highlight-esc.sh &&
  export LESSOPEN="| $(which source-highlight-esc.sh) %s"

if which lessfile a > /dev/null 2>&1; then
  eval "$(lessfile)"
fi
