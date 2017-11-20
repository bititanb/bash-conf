#!/bin/bash

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
  PS1="\[${pathColor}\]$PWD$eR \[${jobsColor}\]\j$eR \[${hostNameColor}\]\h$eR \[${userNameColor}\]\u$eR \[${exitCodeColor}\]\[${exitCode}\]$eR \[${timeColor}\]\t\n\[${commandStringColor}\]"

  # don't execute on first prompt (when shell starts)
  if [ -n "$FIRST_PROMPT" ]; then
    unset FIRST_PROMPT
    return
  fi

  tput sgr0

  # hack for sharing history between terminals
  # HISTCONTROL=ignoredups not tested with this, better turn it off, duplicates
  # removing already implemented here
  hist_file="$HOME/.bash_history"
  temp_file="/tmp/.bash_history$$"
  history -a && \
    if [ -n "$HISTTIMEFORMAT" ]; then
      # this works if HISTTIMEFORMAT is enabled (though will delete all strings without timestamps)
      cat $hist_file |
        awk \
        'BEGIN { timestamp = "#[0-9]{10}$" } \
        $0 ~ timestamp { line_time = $0; getline line_cmd; \
          while (line_cmd ~ timestamp) { line_time = line_cmd; getline line_cmd }; \
          array[++c] = line_time " " line_cmd } \
        END { for (line in array) { print array[line] } }' |
        sort -k2 -k1r | uniq -f1 | sort | awk '{ sub(" ", "\n") ; print }' \
        > $temp_file || failed=1
      total_entries="$(($(wc -l $hist_file | cut -d' ' -f1) / 2))"
    else
      # this works only if HISTTIMEFORMAT is disabled
      cat $hist_file | nl | sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8- > $temp_file || failed=1
      total_entries="$(wc -l $hist_file | cut -d' ' -f1)"
    fi

  # make backups of last X .bash_histories (triggered on every Y new
  # history entries) in case something goes wrong
  if [ "$failed" != 1 ]; then
    backups_total=20
    backup_every=100
    filename="bash_hist"

    if [ $(( total_entries % backup_every )) = 0 ]; then
      cd /var/tmp || return 1

      for (( i=backups_total; i>=0; i-- )); do
        if [ -f "${filename}.${i}" ]; then
          mv -f "${filename}.${i}" "${filename}.$((++i))"
        fi
      done

      cp -f "$hist_file" "${filename}.0"
    fi

    history -c && \
    mv -f $temp_file $hist_file  && \
    if [ "$EUID" = "0" ] && [ "$HOME" != "/root" ]; then
      who am i | cut -d\  -f1 | xargs -I{} chown {}:{} $hist_file
    fi
    history -r
  fi
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
HISTCONTROL=ignorespace,ignoredups #lines starting with space in the history.
HISTIGNORE='zsh:reset:cd ~:cd -:git status:top:ps aux:%:%1:%2:%3:&:ls:pwd:exit:clear:bash:sh:dash:fg:bg:sync:ls -ltr:ls -l:ls -t'
# better keep history dates disabled - it breaks shared history hack
HISTTIMEFORMAT="%d/%m/%y %T "
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
    hostNameColor="$aFgYellowI"
    userNameColor="$aFgCyanI"
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
