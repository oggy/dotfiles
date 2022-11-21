#
# Directory to edge rails source.
#
RAILS_SRC=~/src/rails

rails_framework() {
    if [ -e bin/rails ]; then
        echo bin/rails
    elif [ -e config/apps.rb ]; then
        echo -n padrino
    else
        echo -n rails
    fi
}

#
# Print the $RAILS_ENV or 'development' if it's undefined.
#
rails_env() {
    if [ -n "$RAILS_ENV" ]; then
        echo -n $RAILS_ENV
    else
        echo -n 'development'
    fi
}

#
# Run the appropriate rake command with the given arguments.
#
rails_rake() {
    if [ -e bin/rake ]; then
        bin/rake --trace "$@"
    else
        bundle exec rake --trace "$@"
    fi
}

#
# Start the rails server.
#
rails_server() {
    local framework=$(rails_framework)
    local options
    local handler

    if grep -q 'thin\b' Gemfile.lock; then
        echo "Using thin." >&2
        handler=thin
    fi

    if [ "$framework" = padrino ]; then
        if [ -n "$handler" ]; then
            options=--server="$handler"
        fi
        $(rails_framework) start $options $*
    else
        $(rails_framework) server $server $*
    fi
}

#
# Run the rails console.
#
rails_console() {
    # if [ -f Gemfile ] && bundle show pry > /dev/null; then
    #     bundle exec pry -I. -rconfig/environment
    # else
        $(rails_framework) console $*
    # fi
}

rails_test_reset() {
  RAILS_ENV=test $(rails_framework) db:drop db:create db:schema:load
}

alias rrx='rails_server'
alias rrc='rails_console'
alias rrdb='$(rails_framework) dbconsole'
alias rrcs='rails_console --sandbox'
alias rrr='$(rails_framework) runner'
alias rrg='$(rails_framework) generate'
alias rrd='$(rails_framework) destroy'
alias rrp='$(rails_framework) plugin'
alias rrl='tail -f log/`rails_env`.log'
alias rry='pry -r ./config/environment'
alias rrdbt='rails_rake db:test:prepare'
alias rrtr='rails_test_reset'

#
# Run migrations.
#
# If an integer argument is given, migrate to that version.  Otherwise
# run the db:migrate task with the given arguments.
#
rrm() {
    ruby -e 'Integer(ARGV[0])' -- "$1" 2> /dev/null
    local is_integer=$?

    if [ "$is_integer" = "0" ]; then
        rails_rake db:migrate "VERSION=$1"
    else
        rails_rake db:migrate $@
    fi
}

#
# Run the db:migrate:redo task on given migration version.
#
# Defaults to the latest migration.
#
rrmr() {
    local version=$1; shift
    rails_rake db:migrate:redo VERSION=`_rails_migration_version $version` $*
}

#
# Run the db:migrate:down task on given migration version.
#
# Defaults to the latest migration.
#
rrmd() {
    local version=$1; shift
    rails_rake db:migrate:down VERSION=`_rails_migration_version $version` $*
}

#
# Run the db:migrate:up task on given migration version.
#
# Defaults to the latest migration.
#
rrmu() {
    local version=$1; shift
    rails_rake db:migrate:up VERSION=`_rails_migration_version $version` $*
}

_rails_migration_version() {
    if [ -n "$1" ]; then
        echo $1
    else
        ls -1 db/migrate | grep '\.rb$' | cut -d_ -f1 | sort -n | tail -1
    fi
}
