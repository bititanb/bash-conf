#!/bin/bash

###################
# ALIASES
###################

alias awshb='aws --endpoint-url http://hb.bizmrg.com'

###################
# FUNCTIONS (non-interactive usage)
###################

# gitignore.io
gi() { curl -L -s https://www.gitignore.io/api/$@ ; }

nt() {
  cur_desktop="$(wmctrl -d | grep ' \* ' | cut -d' ' -f1)"
  notify-send -i /usr/share/icons/breeze/emotes/22/face-smile.svg \
    "Command DONE on desktop ${cur_desktop}."
}


###################
# FUNCTIONS (interactive usage)
###################

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -e /usr/share/git/completion/git-prompt.sh ]; then
  source /usr/share/git/completion/git-prompt.sh
fi

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
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM='auto'

  # generate prompt
  PS1="\$ \[${userNameColor}\]\u$eR \[${hostNameColor}\]\h$eR \[${pathColor}\]\w$eR \[${jobsColor}\]j\j$eR \[${exitCodeColor}\]e\[${exitCode}\]$eR \[${timeColor}\]\t$eR\[${branchColor}\]\$(__git_ps1 \" (%s)\")$eR\n\[${commandStringColor}\]"

  # don't execute on first prompt (when shell starts)
  if [ -n "$FIRST_PROMPT" ]; then
    unset FIRST_PROMPT
    return
  fi

  tput sgr0

  # sync history between terminals
  history -a
  history -c
  history -r
}

###################
# SETTINGS
###################

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
HISTSIZE=20000
HISTFILESIZE=20000
HISTCONTROL=ignorespace,ignoredups,erasedups #lines starting with space in the history.
HISTIGNORE='zsh:reset:cd ~:cd -:git status:top:ps aux:%:%1:%2:%3:&:ls:pwd:exit:clear:bash:sh:dash:fg:bg:sync:ls -ltr:ls -l:ls -t'
# better keep history dates disabled - it breaks shared history hack
# HISTTIMEFORMAT="%d/%m/%y %T "
shopt -s histappend # append to the history file, don't overwrite it

# bash specific options
shopt -s checkjobs              # second "exit" needed if running any jobs
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cmdhist          			# save multi-line commands in history as single line
#shopt -s histverify

# posix shell options
set -o notify					# notify when jobs running in background terminate

###################
# ALIASES
###################

alias grep='grep --color=auto'
alias ls='ls --color=auto'

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
    # # ansi colors for dark tty
    # # less colors
    # lessBoldColor="$aFgYellowI"
    # lessUnderlineColor="$aFgCyan"

    # prompt colors
    rightPromptColor=""
    pathColor="$aFgYellowI"
    jobsColor="$aFgGreenI"
    branchColor="$aFgYellowI"
    userNameColor="$aFgYellowI"
    hostNameColor="$aFgCyanI"
    exitCodeColor="$aFgMagentaI"
    timeColor="$aFgGreenI"
    commandStringColor="$aFgCyanI"
    ;;
  *)
    # # ansi colors for light (primarily) or dark pts
    # # less colors
    # lessBoldColor="$aFgRedI"
    # lessUnderlineColor="$sUnderline"

    # prompt colors
    rightPromptColor=""
    pathColor="$aFgRedI"
    jobsColor="$aFgBlueI"
    hostNameColor="$aFgGreen"
    branchColor="$aFgGreen"
    userNameColor="$aFgMagentaI"
    exitCodeColor="$aFgCyan"
    commandStringColor="$aFgCyan"
    ;;
esac

# export LESS="-MRQ"

# export LESS_TERMCAP_md=$(printf "${lessBoldColor}") # bold, commands and options in mans
# export LESS_TERMCAP_us=$(printf "${lessUnderlineColor}") # underline (maybe italic), misc options in mans
# export LESS_TERMCAP_me=$(printf "$R") # turn off bold, blink, underline
# export LESS_TERMCAP_ue=$(printf "$R") # stop underline
# export GREP_COLORS='ms=7:mc=7:sl=:cx=:fn=31:ln=31:bn=31:se=31'

# # workaround for bug in ranger filemanager
# export PAGER="less"

# if [ -x /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
#   export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
# fi

# if [ -x /usr/bin/dircolors ]; then
#   test -r ~/.dircolors.ansi-universal && eval "$(dircolors -b ~/.dircolors.ansi-universal)" || eval "$(dircolors -b)"
# fi


# needed for vim-gnupg
export GPG_TTY='tty'

# for phpbrew
source "$HOME/.phpbrew/bashrc"

