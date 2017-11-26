# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/node_modules/.bin:$HOME/go/bin:$HOME/.gem/ruby/2.4.0/bin:$HOME/git/linux-utils:/opt/unreal-engine/Engine/Binaries/Linux:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# needed for .XCompose to be read
export GTK_IM_MODULE=xim

# linuxbrew
# export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
# export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
# export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

# $PAGER needed for some programs
export PAGER="less"
export TERM_EXEC="alacritty-t3"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export GUI_EDITOR="gnvim"
export WEB_BROWSER="firefox"
export FILE_MANAGER="ranger"
export GUI_FILE_MANAGER="$TERM_EXEC -e $FILE_MANAGER"

# export QT_QPA_PLATFORMTHEME="qt5ct"

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

export LESS="-MRQ"
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
