export LESS='-f -R -P%f, lines %lt-%lb of %L$'

if which lessfile a > /dev/null 2>&1; then
  eval "$(lessfile)"
fi
