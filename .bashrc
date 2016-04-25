#!/bin/bash -exv
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

###################
# FUNCTIONS
###################

__rightPrompt() {
    date=$(date +%H:%M:%S)
    printf "%*s" $COLUMNS "${date}"
}

# before any command is executed
__preCommand() {
    if [ -z "$AT_PROMPT" ]; then
        return
    fi

    unset AT_PROMPT

    tput sgr0
}

# after any command is executed
__postCommand() {
    exitCode="$?"
    AT_PROMPT=1

    # generate prompt
    #PS1="\[${rightPromptColor}\]\[$(tput sc; __rightPrompt; tput rc)\]$eR\[${pathColor}\]$PWD$eR \[${jobsColor}\]\j$eR \[${hostNameColor}\]\h$eR \[${userNameColor}\]\u$eR \[${exitCodeColor}\]\[${exitCode}\]$eR\n\[${commandStringColor}\]"
    PS1="\[${pathColor}\]$PWD$eR \[${jobsColor}\]\j$eR \[${hostNameColor}\]\h$eR \[${userNameColor}\]\u$eR \[${exitCodeColor}\]\[${exitCode}\]$eR\n\[${commandStringColor}\]"

    # don't execute on first prompt (when shell starts)
    if [ -n "$FIRST_PROMPT" ]; then
        unset FIRST_PROMPT
        return
    fi

    tput sgr0

    # hack for sharing history between terminals
    history -a && \
    cat ~/.bash_history | nl | sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8- > /tmp/.bash_history$$ && \
    history -c && \
    mv -f /tmp/.bash_history$$ ~/.bash_history  && \
    if [ "$EUID" = "0" ] && [ "$HOME" != "/root" ]; then
        who am i | cut -d\  -f1 | xargs -I{} chown {}:{} ~/.bash_history
    fi
    history -r
}

cl() {
    cd "$@" && ls -Xh --time-style=iso --color=auto;

}

###################
# SETTINGS
###################

# environment variables
#export LC_ALL=C
#export LC_ALL=en_US.UTF-8

case $TERM in
    linux)
        ;;
    screen)
        ;;
    *-256color)
        ;;
    *)
        export TERM="$TERM-256color"
        ;;
esac

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

trap "__preCommand" DEBUG

FIRST_PROMPT=1
PROMPT_COMMAND="__postCommand"

# History settings
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignorespace #lines starting with space in the history.
HISTIGNORE='&:ls:pwd:exit:clear:bash:sh:dash:fg:bg:sync:ls -ltr:ls -l:ls -t'
shopt -s histappend # append to the history file, don't overwrite it

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

###################
# ALIASES
###################

alias grep='grep --color=auto'
alias ls='ls -Xh --time-style=iso --color=auto'

###################
# COLORS
###################

aFgBlack='\e[30m'
aFgRed='\e[31m'
aFgGreen='\e[32m'
aFgYellow='\e[33m'
aFgBlue='\e[34m'
aFgMagenta='\e[35m'
aFgCyan='\e[36m'
aFgWhite='\e[37m'

aBgBlack='\e[40m'
aBgRed='\e[41m'
aBgGreen='\e[42m'
aBgYellow='\e[43m'
aBgBlue='\e[44m'
aBgMagenta='\e[45m'
aBgCyan='\e[46m'
aBgWhite='\e[47m'

aFgBlackI='\e[1;30m'
aFgRedI='\e[1;31m'
aFgGreenI='\e[1;32m'
aFgYellowI='\e[1;33m'
aFgBlueI='\e[1;34m'
aFgMagentaI='\e[1;35m'
aFgCyanI='\e[1;36m'
aFgWhiteI='\e[1;37m'

R='\e[0m'
sInvert='\e[7m'
sBold='\e[1m'
sUnderline='\e[4m'

eR='\[\e[0m\]'

case "$TERM" in
    linux*)
        # ansi colors for dark tty
        # less colors
        lessBoldColor="$aFgYellowI"
        lessUnderlineColor="$aFgCyan"

        # prompt colors
        rightPromptColor=""
        pathColor="$aFgYellowI"
        jobsColor="$aFgGreenI"
        hostNameColor="$aFgYellowI"
        userNameColor="$aFgCyanI"
        exitCodeColor="$aFgMagentaI"
        commandStringColor="$aFgCyanI"
        ;;
    *)
        # ansi colors for light (primarily) or dark pts
        # less colors
        lessBoldColor="$aFgRedI"
        lessUnderlineColor="$sUnderline"

        # prompt colors
        rightPromptColor=""
        pathColor="$aFgRedI"
        jobsColor="$aFgBlueI"
        hostNameColor="$aFgGreen"
        userNameColor="$aFgMagentaI"
        exitCodeColor="$aFgCyan"
        commandStringColor="$aFgCyan"
        ;;
esac

export LESS="-iMRwMQ"

export LESS_TERMCAP_md=$(printf "${lessBoldColor}") # bold, commands and options in mans
export LESS_TERMCAP_us=$(printf "${lessUnderlineColor}") # underline (maybe italic), misc options in mans
export LESS_TERMCAP_me=$(printf "$R") # turn off bold, blink, underline
export LESS_TERMCAP_ue=$(printf "$R") # stop underline
export GREP_COLORS='ms=7:mc=7:sl=:cx=:fn=31:ln=31:bn=31:se=31'

if [ -x /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors.ansi-universal && eval "$(dircolors -b ~/.dircolors.ansi-universal)" || eval "$(dircolors -b)"
fi
