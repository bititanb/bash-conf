#!/bin/zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

################################################################################
# ALIASES
################################################################################

alias git='hub'

# Decode strings: `strace -f echo asdf | format-strace`
alias format-strace='grep --line-buffered -o '\''".\+[^"]"'\'' | grep --line-buffered -o '\''[^"]*[^"]'\'' | while read -r line; do printf "%b" $line; done | tr "\r\n" "\275\276" | tr -d "[:cntrl:]" | tr "\275\276" "\r\n"'
alias pip2upgrade='pip2 freeze --user | cut -d'=' -f1 | xargs pip2 install --user -U'
alias pip3upgrade='pip3 freeze --user | cut -d'=' -f1 | xargs pip3 install --user -U'

################################################################################
# FUNCTIONS (non-interactive usage)
################################################################################

# gitignore.io
gi() { curl -L -s https://www.gitignore.io/api/$@ ; }

# use like `sleep 10 && nt` to show notification that the task is done
nt() {
  cur_desktop="$(wmctrl -d | grep ' \* ' | cut -d' ' -f1)"
  notify-send -i /usr/share/icons/breeze/emotes/22/face-smile.svg \
    "Command DONE on desktop ${cur_desktop}."
}

################################################################################
# OTHER CUSTOM CONFIGURATION
################################################################################

# Bigger history file
SAVEHIST=50000

typeset -A ZSH_HIGHLIGHT_STYLES
# Change path highlightning
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# Disable autojump to menu on tab
unsetopt automenu
unsetopt autocd
unsetopt autopushd

# Overwrite/disable function that invokes ls on cd in Garrett prompt
function prompt_garrett_chpwd {}
