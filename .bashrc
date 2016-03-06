# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" 

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

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

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

# # export TMOUT=600				# auto logout after n seconds of inactivity
# export LESSCHARSET='latin1'
# export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \'
# # export LESSOPEN="|lesspipe.sh %s"; export LESSOPEN
# export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'	# use this if lesspipe.sh exists
# # export LESS="-QR"				# tell less not to beep and also display colours
# # export LESS='-R'
# # export LESS_TERMCAP_mb=$'\E[01;31m'      	# less colors for Man pages # begin blinking
# # export LESS_TERMCAP_md=$'\E[01;38;5;74m'  	# less colors for Man pages # begin bold
# # export LESS_TERMCAP_me=$'\E[0m'           	# less colors for Man pages # end mode
# # export LESS_TERMCAP_se=$'\E[0m'           	# less colors for Man pages # end standout-mode
# # export LESS_TERMCAP_so=$'\E[38;5;246m'    	# less colors for Man pages # begin standout-mode - info box
# # export LESS_TERMCAP_ue=$'\E[0m'           	# less colors for Man pages # end underline
# # export LESS_TERMCAP_us=$'\E[04;38;5;146m' 	# less colors for Man pages # begin underline

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias g='grep --color=auto -i'
alias l='less'
alias s='sudo '
alias v='vim'
alias f='find'
alias ls='ls -hX --color=auto'
alias ll='ls -hlX --time-style=iso --color=auto'
alias ac='apt-cache'
alias acs='apt-cache show'
alias aci='apt-cache search'
alias ag='apt-get'
alias agi='apt-get install'
alias agr='apt-get remove'
alias agupd='apt-get update'
alias agupg='apt-get upgrade'
alias dp='dpkg'
alias dpgs='dpkg --get-selections'
alias ki='kill'
alias pk='pkill'
alias ka='killall'
alias he='head'
alias ta='tail'
alias se='service'

cl() {
    cd "$@" && ls;
}

# add export PATH
export EDITOR='vim'
export VISUAL='vim'
export BROWSER='palemoonf'
export LESS="-iMR"
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

###################
# ALIASES
###################

# suffix aliases like
# alias -s tex=vim

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g HE='|& head'
alias -g TA='|& tail'
alias -g L='|& less'
alias -g G='|& grep --color=auto -i'
alias -g EI='/etc/init.d/'
alias -g H=' --help'

alias s='sudo '
alias le='LC_ALL=C '

alias m='man'
alias l='less'
alias v='vim'
alias f='find'
#alias ls='ls -hX --color=auto'
#alias ll='ls -hlX --time-style=iso --color=auto'
alias ls='ls -hX'
alias ll='ls -hlX'
alias lm='ls -hlX -tr'
alias ac='apt-cache'
alias ag='apt-get'
alias af='apt-file'
alias ki='kill'
alias ka='killall'
alias dp='dpkg'
alias se='service'

alias agi='apt-get install'
alias agr='apt-get remove'
alias ags='apt-get search'
alias agd='apt-get update'
alias agg='apt-get upgrade'
alias pa='ps aux'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
