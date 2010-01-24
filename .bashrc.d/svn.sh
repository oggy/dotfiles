alias sup='svn up'
alias sci='svn ci'
alias sco='svn co'
alias sd='svn diff'
alias sst='svn st'
alias sin='svn info'
function slog() { svn log $* | less; }
