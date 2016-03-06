# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# # set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
    # xterm-color|*-256color|*rxvt*) color_prompt=yes;;
# esac

# # uncomment for a colored prompt, if the terminal has the capability; turned
# # off by default to not distract the user: the focus in a terminal window
# # should be on the output of commands, not on the prompt
# force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
    # if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# # We have color support; assume it's compliant with Ecma-48
	# # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# # a case would tend to support setf rather than setaf.)
	# color_prompt=yes
    # else
	# color_prompt=
    # fi
# fi

# if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|*rxvt*)
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    # ;;
# *)
    # ;;
# esac


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
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

set -o notify					# notify when jobs running in background terminate

PS1='\[\e[35;1m\]$PWD \[\e[32;1m\]\h \u \[\e[35;1m\]\j ${?##0:} \[\e[0m\]\t\n\[\e[32;1m\]\\$ \[\e[0m\]'

###################
# ALIASES
###################

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
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
