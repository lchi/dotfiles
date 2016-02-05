export EDITOR=vim

alias l='ls'
alias ll='ls -l'
alias la='ls -la'

GIT_PROMPT=~/.git-prompt.sh
GIT_COMPLETION=~/.git-completion.bash

if [ ! -f ~/.git-prompt.sh ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > $GIT_PROMPT
fi
if [ ! -f ~/.git-completion.bash ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > $GIT_COMPLETION
fi

source $GIT_COMPLETION

source $GIT_PROMPT
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\] \w $(__git_ps1 "[%s] ")$ \[\033[00m\]'
