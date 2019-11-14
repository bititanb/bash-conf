# Secure umask
umask 027

################################################################################
# CUSTOM VARIABLES
################################################################################

# $PAGER needed for some programs
export EDITOR="nvim"
export FILE_MANAGER="ranger"
export GUI_EDITOR="gnvim"
export GUI_FILE_MANAGER="$TERM_EXEC -e $FILE_MANAGER"
export PAGER="less"
export TERM_EXEC="alacritty"
export VISUAL="$EDITOR"
export WEB_BROWSER="firefox"

# password to access vaulted encrypted data
export ANSIBLE_VAULT_PASSWORD_FILE="$HOME/.vault_pass"
export GOPATH="$HOME/.go"
export PYENV_ROOT="$HOME/.pyenv"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export NPM_CONFIG_PREFIX="$HOME/.node_modules"

export DOTNET_CLI_TELEMETRY_OPTOUT=1
# needed for .XCompose to be read
export GTK_IM_MODULE=xim
# for vim-gnupg
export GPG_TTY='tty'

# export env variables from environment.d
env_dir="$HOME/.config/environment.d"
if [ -d "$env_dir" ] && [ -r "$env_dir" ] \
  && [ "$(ls -1 "$env_dir" | wc -l)" -gt 0 ]; then
  set -a
  for file in $env_dir/*.conf; do . "$file"; done
  set +a
fi

################################################################################
# UPDATING PATHS TO BINARIES AND CONFIGS
################################################################################

# base PATH
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games"

# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

# snap
export PATH="/snap/bin:$PATH"

# umake
export PATH="$HOME/.local/share/umake/bin:$PATH"

# golang
export PATH="$GOPATH/bin:$PATH"

# pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# nodejs
export PATH="$HOME/.node_modules/.bin:$PATH"

# ruby
export PATH="$(find ~/.gem/ruby/ -maxdepth 2 -mindepth 2 -name bin -type d 2>/dev/null | xargs printf '%s:')$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# chef
#export PATH="$(find ~/.chefdk/gem/ruby/ -maxdepth 2 -mindepth 2 -name bin -type d 2>/dev/null | tac | xargs printf '%s:')$PATH"

##############################################
# COLORS
##############################################

aFgRedI='\e[1;31m'
aFgCyan='\e[36m'
aFgYellowI='\e[1;33m'
sUnderline='\e[4m'

R='\e[0m'

case "$TERM" in
  linux*)
    lessBoldColor="$aFgYellowI"
    lessUnderlineColor="$aFgCyan"
    ;;
  *)
    lessBoldColor="$aFgRedI"
    lessUnderlineColor="$sUnderline"
    ;;
esac

export LESS="-MRQX"
export LESS_TERMCAP_md=$(printf "${lessBoldColor}") # bold, commands and options in mans
export LESS_TERMCAP_us=$(printf "${lessUnderlineColor}") # underline (maybe italic), misc options in mans
export LESS_TERMCAP_me=$(printf "$R") # turn off bold, blink, underline
export LESS_TERMCAP_ue=$(printf "$R") # stop underline
export GREP_COLORS='ms=7:mc=7:sl=:cx=:fn=31:ln=31:bn=31:se=31'

# source highlighting for `less`
if [ -x /usr/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

##############################################
# AFTER EVERYTHING ELSE
##############################################

# if running bash include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
