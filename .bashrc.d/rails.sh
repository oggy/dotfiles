#
# Directory to edge rails source.
#
RAILS_SRC=~/src/rails

#
# Print the $RAILS_ENV or 'development' if it's undefined.
#
function rails_env {
    if [ -n "$RAILS_ENV" ]; then
        echo -n $RAILS_ENV
    else
        echo -n 'development'
    fi
}

#
# Successful iff the snailgun socket is available for the current
# environment.
#
function rails_snailgun_available {
    local snailgun_socket=tmp/sockets/snailgun/`rails_env`
    test -S "$snailgun_socket"
}

#
# Run the appropriate rake command with the given arguments.
#
# Uses snailgun if available.
#
function rails_rake {
    if rails_snailgun_available; then
        frake $*
    else
        rake $*
    fi
}

#
# Run the appropriate ruby command with the given arguments.
#
# Uses snailgun if available.
#
function rails_ruby {
    if rails_snailgun_available; then
        fruby $*
    else
        ruby $*
    fi
}

#
# Start the rails server.
#
# Uses Snailgun and/or thin if available.
#
function rails_server {
    local server
    if which -s thin > /dev/null; then
        server=thin
    fi
    rails_ruby script/server $server $*
}

#
# Run the rails console.
#
# Uses Snailgun if available.
#
function rails_console {
    if rails_snailgun_available; then
        fconsole $*
    else
        script/console $*
    fi
}

alias rrn='snailgun -v --rails development'
alias rrx='rails_server'
alias rrc='rails_console'
alias rrdb='rails_ruby script/dbconsole'
alias rrcs='rails_console --sandbox'
alias rrr='rails_ruby script/runner'
alias rrg='rails_ruby script/generate'
alias rrd='rails_ruby script/destroy'
alias rrp='rails_ruby script/plugin'
alias rrl='tail -f log/`rails_env`.log'

#
# Open the Rails API documentation.
#
# Generates it first if necessary.
#
function rrdoc {
    local START_PAGE='doc/api/index.html'
    if [ ! -f "$START_PAGE" ]; then
        rails_rake doc:rails
    fi
    open "$START_PAGE"
}

alias rrtf='rails_rake test:functionals'
alias rrti='rails_rake test:integration'
alias rrtp='rails_rake test:plugins'

#
# Freeze edge Rails into this application.
#
function freeze-edge-rails {
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
function edgerails {
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
function rrm {
    ruby -e 'Integer(ARGV[0])' -- "$1" 2> /dev/null
    local is_integer=$?

    if [ "$is_integer" = "0" ]; then
        rails_rake db:migrate "VERSION=$1"
    else
        if [ -d `pwd`/db/migrate ]; then
            echo "db/migrate found -- performing standard migration"
            rails_rake db:migrate $@
        elif [ -d `pwd`/vendor/plugins/auto_migrations ]; then
            echo "auto_migrations plugin found -- performing automigration"
            rails_rake db:auto:migrate $@
        else
            echo "no migrations found" >&2
        fi
    fi
}

#
# Run the db:migrate:redo task on given migration version.
#
# Defaults to the latest migration.
#
function rrmr {
    local version=$1
    shift
    if [ -n "$version" ]; then
        rails_rake db:migrate:redo VERSION=`_rails_migration_version $version` $*
    else
        rails_rake db:migrate:redo $*
    fi
}

#
# Run the db:migrate:down task on given migration version.
#
# Defaults to the latest migration.
#
function rrmd {
    local version=$1
    shift
    if [ -n "$version" ]; then
        rails_rake db:migrate:down VERSION=`_rails_migration_version $version` $*
    else
        rails_rake db:migrate:down $*
    fi
}

#
# Run the db:migrate:up task on given migration version.
#
# Defaults to the latest migration.
#
function rrmu {
    local version=$1
    shift
    if [ -n "$version" ]; then
        rails_rake db:migrate:up VERSION=`_rails_migration_version $version` $*
    else
        rails_rake db:migrate:up $*
    fi
}

function _rails_migration_version {
    if [ -n "$1" ]; then
        echo $1
    else
        ls -1 db/migrate | grep '\.rb$' | cut -d_ -f1 | sort -n | tail -1
    fi
}
