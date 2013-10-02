export EDITOR=vim

alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias ws='cd ~/workspace'

# only necessary for macs?
source ~/.git-prompt.sh
export PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\] \w $(__git_ps1 "[%s]")$  \[\033[00m\]'
