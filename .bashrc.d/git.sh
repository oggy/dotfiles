alias Git='git --no-pager'
alias Gsh='git --no-pager show'
alias ga='git add'
alias gai='git add --interactive'
alias gap='git add --patch'
alias gau='git add -u'
alias gaN='git add -N'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbm='git branch -m'
alias gbM='git branch -M'
alias gbsu='git branch --set-upstream `git rev-parse --abbrev-ref HEAD` origin/`git rev-parse --abbrev-ref HEAD`'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gcpx='git cherry-pick -x'
alias gd='git diff -b'
alias gdc='git diff -b --cached'
alias gf='git fetch'
alias gh='git help'
alias gl='git log'
alias glp='git log -p'
alias gmf='git merge --ff-only'
alias gmv='git mv'
alias go='git clone'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gP='git push'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grh='git reset HEAD'
alias grm='git rm'
alias g='git --no-pager status'
alias gsh='git show'
alias gt='git remote'
alias guncommit='git reset --soft HEAD^'
alias gx='git commit'
alias gxa='git commit --amend'
alias gzl='git stash list'

gcbt() {
  if [ $# -eq 0 ]; then
      echo "USAGE: gcbt BRANCH GIT-OPTIONS ..." >&2
      return 1
  fi
  local branch=$1; shift
  git checkout -b "$branch" --track "origin/$branch" $*
}

gz() {
    if [ $# -eq 0 ]; then
        echo "Message please!" >&2
        return 1
    fi
    git stash save $*
}

gzki() {
    if [ $# -eq 0 ]; then
        echo "Message please!" >&2
        return 1
    fi
    git stash save --keep-index $*
}

gzsh() {
    if [ $# -eq 0 ]; then
        git show stash@{0}
    elif [ $# -eq 1 ]; then
        git show stash@{$1}
    else
        echo "USAGE: ggzsh STASH-NUMBER" >&2
        return 1
    fi
}

gzp() {
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

gzd() {
    if [ $# -ne 1 ]; then
        echo "USAGE: ggzd STASH-NUMBER" >&2
        return 1
    fi
    git stash drop stash@{$1}
}

#
# Output the contents of $2 in git branch $1
#
gcat() {
    git cat-file blob "$1:$2" | $PAGER
}

#
# Show who has the trophy.
#
git-glory() {
    git log --format='%an' --no-merges | sort | uniq -c | sort -nr
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
