# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export PATH="$HOME/.gem/ruby/2.4.0/bin:$HOME/.local/bin:$HOME/git/linux-utils:$HOME/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin:/usr/local/games:/usr/games"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export HISTTIMEFORMAT="%d/%m/%y %T "

export TERM_EXEC="alacritty"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export GUI_EDITOR="nvim-qt"
export WEB_BROWSER="chromium"
export FILE_MANAGER="ranger"
export GUI_FILE_MANAGER="$TERM_EXEC -e $FILE_MANAGER"

export QT_QPA_PLATFORMTHEME="qt5ct"

# if running bash include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
