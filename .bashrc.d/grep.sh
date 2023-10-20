#
# Smart "recursive grep".
#
# Pass the arguments to grep with flags "-nr" added.  If no files
# are specified, the current directory is assumed.
#
# Matches that are assumed uninteresting (e.g., files in .svn,
# .git, and TAGS files) are filtered out.
#
grg() {
    local extra_args
    if [ "$#" -eq 1 ]; then
        extra_args="."
    fi
    grep -nr --color=always "$@" $extra_args |                   \
        grep -v '^[^:]*\.svn/[^:]*:' |                           \
        grep -v '^[^:]*\.git/[^:]*:' |                           \
        grep -v '^\([^:]*/\)\?TAGS:' |                           \
        sed -e 's/\([^:]*\):\([^:]*\):/[33m\1 [0m[1m\2[0m:/'
}

# I keep mistyping this...
alias grpe=grep

export RIPGREP_CONFIG_PATH=~/.ripgreprc
