alias gga='git add'
alias ggai='git add --interactive'
alias ggap='git add --patch'
alias ggau='git add -u'
alias ggaN='git add -N'
alias ggb='git branch'
alias ggba='git branch -a'
alias ggbd='git branch -d'
alias ggbD='git branch -D'
alias ggc='git checkout'
alias ggd='git diff -b'
alias ggdc='git diff -b --cached'
alias ggf='git fetch'
alias ggh='git help'
alias ggl='git log'
alias gglp='git log -p'
alias ggm='git merge'
alias ggmv='git mv'
alias ggo='git clone'
alias ggp='git pull'
alias ggpr='git pull --rebase'
alias ggP='git push'
alias ggrb='git rebase'
alias ggrbc='git rebase --continue'
alias ggrbi='git rebase --interactive'
alias ggrh='git reset HEAD'
alias ggrm='git rm'
alias ggs='git --no-pager status'
alias ggsh='git show'
alias ggt='git remote'
alias gguncommit='git reset --soft HEAD^'
alias ggx='git commit'
alias ggxa='git commit --amend'
alias ggzl='git stash list'

ggz() {
    if [ $# -eq 0 ]; then
        echo "Message please!" >&2
        return 1
    fi
    git stash save $*
}

ggzki() {
    if [ $# -eq 0 ]; then
        echo "Message please!" >&2
        return 1
    fi
    git stash save --keep-index $*
}

ggzsh() {
    if [ $# -eq 0 ]; then
        git show stash@{0}
    elif [ $# -eq 1 ]; then
        git show stash@{$1}
    else
        echo "USAGE: ggzsh STASH-NUMBER" >&2
        return 1
    fi
}

ggzp() {
    local ref
    if [ $# -eq 0 ]; then
        ref=
    elif [ $# -eq 1 ]; then
        ref=stash@{$1}
    else
        echo "USAGE: ggzp [STASH-NUMBER]" >&2
        return 1
    fi
    git --no-pager stash pop $ref
}

ggzd() {
    if [ $# -ne 1 ]; then
        echo "USAGE: ggzd STASH-NUMBER" >&2
        return 1
    fi
    git stash drop stash@{$1}
}

#
# Output the contents of $2 in git branch $1
#
ggcat() {
    git cat-file blob "$1:$2" | $PAGER
}

#
# Print the git branch indicator to use in $PS1.
#
# Uses __git_ps1 if it exists.
#
#  * Mac: install the bash-completion port.
#  * Ubuntu: comes in the git-core package.
#
# If it doesn't exist, print '?' as a prompt to install it.
#
git-ps1() {
    if type __git_ps1 > /dev/null 2>&1; then
        __git_ps1 ' [%s] '
    else
        if [ -d .git ]; then
            echo -n ' [?] '
        fi
    fi
}
