# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# base PATH
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games"

# golang
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# needed for .XCompose to be read
export GTK_IM_MODULE=xim

# $PAGER needed for some programs
export PAGER="less"
export TERM_EXEC="alacritty"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export GUI_EDITOR="gnvim"
export WEB_BROWSER="firefox"
export FILE_MANAGER="ranger"
export GUI_FILE_MANAGER="$TERM_EXEC -e $FILE_MANAGER"

# nodejs
PATH="$HOME/node_modules/.bin:$PATH"

# ruby
PATH="$(find ~/.gem/ruby/ -maxdepth 2 -mindepth 2 -name bin -type d 2>/dev/null | tac | xargs printf '%s:')$PATH"

# chef
PATH="$(find ~/.chefdk/gem/ruby/ -maxdepth 2 -mindepth 2 -name bin -type d 2>/dev/null | tac | xargs printf '%s:')$PATH"

# rust
PATH="$HOME/.cargo/bin:$PATH"

# custom
PATH="$HOME/git/linux-utils:$PATH"
PATH="vendor/bin:$PATH"
export PATH

# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

export ANSIBLE_VAULT_PASSWORD_FILE="$HOME/.vault_pass"

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

export LESS="-MRQFX"
export LESS_TERMCAP_md=$(printf "${lessBoldColor}") # bold, commands and options in mans
export LESS_TERMCAP_us=$(printf "${lessUnderlineColor}") # underline (maybe italic), misc options in mans
export LESS_TERMCAP_me=$(printf "$R") # turn off bold, blink, underline
export LESS_TERMCAP_ue=$(printf "$R") # stop underline
export GREP_COLORS='ms=7:mc=7:sl=:cx=:fn=31:ln=31:bn=31:se=31'

if [ -x /usr/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors.ansi-universal && eval "$(dircolors -b ~/.dircolors.ansi-universal)" || eval "$(dircolors -b)"
fi

##############################################
# END COLORS
##############################################

# if running bash include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
# Ubuntu make installation of Ubuntu Make binary symlink
PATH=/home/user1/.local/share/umake/bin:$PATH

