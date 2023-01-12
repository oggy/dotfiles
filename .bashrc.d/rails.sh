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

rails_test_reset() {
  RAILS_ENV=test $(rails_framework) db:drop db:create db:schema:load
}

alias rrx='bin/rails server'
alias rrc='bin/rails console'
alias rrdb='bin/rails dbconsole'
alias rrdbt='RAILS_ENV=test bin/rails dbconsole'
alias rrcs='bin/rails console --sandbox'
alias rrr='bin/rails runner'
alias rrg='bin/rails generate'
alias rrl='tail -f log/`rails_env`.log'
alias rrtr='RAILS_ENV=test bin/rails db:drop db:create db:schema:load'

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
        bin/rails db:migrate "VERSION=$1"
    else
        bin/rails db:migrate $@
    fi
}

#
# Run the db:migrate:redo task on given migration version.
#
# Defaults to the latest migration.
#
rrmr() {
    local version=$1; shift
    bin/rails db:migrate:redo VERSION=`_rails_migration_version $version` $*
}

#
# Run the db:migrate:down task on given migration version.
#
# Defaults to the latest migration.
#
rrmd() {
    local version=$1; shift
    bin/rails db:migrate:down VERSION=`_rails_migration_version $version` $*
}

#
# Run the db:migrate:up task on given migration version.
#
# Defaults to the latest migration.
#
rrmu() {
    local version=$1; shift
    bin/rails db:migrate:up VERSION=`_rails_migration_version $version` $*
}

_rails_migration_version() {
    if [ -n "$1" ]; then
        echo $1
    else
        ls -1 db/migrate | grep '\.rb$' | cut -d_ -f1 | sort -n | tail -1
    fi
}
