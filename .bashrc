# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    # debian_chroot=$(cat /etc/debian_chroot)
# fi

# enable programmable completion features 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# History settings
export HISTSIZE=30000
export HISTFILESIZE=30000
export HISTCONTROL=ignorespace #lines starting with space in the history.
export HISTIGNORE='&:ls:pwd:exit:clear:bash:sh:dash:fg:bg:sync:ls -ltr:ls -l:ls -t'
shopt -s histappend # append to the history file, don't overwrite it
# hack for sharing history between terminals
export PROMPT_COMMAND="history -a && cat ~/.bash_history | nl | sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8- > /tmp/.bash_history$$ && history -c && mv /tmp/.bash_history$$ ~/.bash_history && history -r"

# bash specific options
shopt -s autocd       # cd without "cd", just directory
shopt -s cdable_vars				# set the bash option so that no '$' is required (disallow write access to terminal)
shopt -s cdspell				# this will correct minor spelling errors in a cd command
shopt -s checkjobs              # second "exit" needed if running any jobs
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cmdhist          			# save multi-line commands in history as single line
shopt -s dirspell     # correct mistakes in dir name
shopt -s dotglob       # include dot files during filename expansions
shopt -s extglob      
shopt -s globstar       # ** for include subdirs
shopt -s histverify
shopt -s nocaseglob        # case-insensitive pathname expansion
shopt -s mailwarn				# keep an eye on the mail file (access time)

# posix shell options
set -o notify					# notify when jobs running in background terminate

PS1='\[\e[35;1m\]$PWD \[\e[32;1m\]\h \u \[\e[35;1m\]\j ${?##0:} \[\e[0m\]\t\n\[\e[32;1m\]\\$ \[\e[0m\]'

###################
# ALIASES
###################

alias r='sudo '
alias ru='su -c '
alias s='sed'
alias a='awk'
alias g='grep'
alias l='less'
alias v='vim'
alias gv='gvim'
alias w='wget'
alias f='find'
alias t='tar'
alias j='jobs'
alias p='ping'
alias m='man'
alias ma='man -a'
alias mk='man -k'
alias mkk='man -K'
alias br="$BROWSER"
alias cu='curl'
alias ki='kill'
alias pk='pkill'
alias ka='killall'
alias cm='chmod'
alias ec='echo'
alias tr='traceroute'
alias co='chown'
alias st='stat'
alias xa='xargs'
alias vr='virsh'
alias vrl='virsh list --all'
alias he='head'
alias ta='tail'
alias se='service'
alias vc='vcsh'
alias md='mkdir'
alias wh='which'
alias pa='ps aux'
alias ls='ls -X --color=auto'
alias ll='ls -X -hl --time-style=iso --color=auto'
alias lt='ls -X -hl -tr --time-style=iso --color=auto'
# alias le='LC_ALL=C '

alias d='dpkg'

alias af='apt-file'

alias ac='apt-cache'
alias acs='apt-cache search'
alias ach='apt-cache show'

alias ag='apt-get'
alias agi='apt-get install'
alias agr='apt-get remove'
alias agp='apt-get purge'
alias agu='apt-get update'
alias agg='apt-get upgrade'
