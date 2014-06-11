#
# Directory to edge rails source.
#
RAILS_SRC=~/src/rails

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
    bundle exec rake --trace $*
}

#
# Start the rails server.
#
rails_server() {
    if grep -q 'thin\b' Gemfile.lock; then
        echo 'Using thin.' >&2
        rails server thin $*
    else
        echo 'Using webrick.' >&2
        rails server $*
    fi
}

#
# Run the rails console.
#
rails_console() {
    if [ -f Gemfile ] && bundle show pry > /dev/null; then
        bundle exec pry -I. -rconfig/environment
    else
        rails console $*
    fi
}

alias rrx='rails_server'
alias rrc='rails_console'
alias rrdb='rails dbconsole'
alias rrcs='rails_console --sandbox'
alias rrr='rails runner'
alias rrg='rails generate'
alias rrd='rails destroy'
alias rrp='rails plugin'
alias rrl='tail -f log/`rails_env`.log'
alias rry='pry -r ./config/environment'
alias rrdbt='rails_rake db:test:prepare'

#
# Open the Rails API documentation.
#
# Generates it first if necessary.
#
rrdoc() {
    local START_PAGE='doc/api/index.html'
    if [ ! -f "$START_PAGE" ]; then
        rails_rake doc:rails
    fi
    open "$START_PAGE"
}

#
# Freeze edge Rails into this application.
#
freeze-edge-rails() {
    local RAILS=~/src/rails
    local DST=$1
    if [ -z "$DST" ]; then
        DST=`pwd`
    elif [ ${DST:0:1} != '/' ]; then
        DST=`pwd`/$DST
    fi
    cd $RAILS
    git checkout-index -a --prefix="$DST"/vendor/rails/
    cd -
}

#
# Use edge Rails to generate a new Rails application.
#
edgerails() {
    local DST=$1
    if [ $# -ne 1 -o -z "$DST" ]; then
        echo "USAGE: edgerails DIR" >&2
        return 1
    elif [ ${DST:0:1} != '/' ]; then
        DST=`pwd`/$DST
    fi

    ruby $RAILS_SRC/railties/bin/rails $1
    cd $RAILS_SRC
    git checkout-index -a --prefix="$DST"/vendor/rails/
    cd -
}

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
