# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# export KDEWM="awesome"
# export TMOUT=600				# auto logout after n seconds of inactivity
# export CDPATH=".:~"
# export HOSTFILE="~/.hostsexample"
# export MANOPT=''
# export TERM='xterm'
export PATH="$HOME/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/games:/usr/local/games"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export MAILCHECK=15

if (command -v vim 2>- 1>-); then
    export EDITOR='vim'
    export VISUAL='vim'
elif (command -v vim.tiny 2>- 1>-); then
    export EDITOR='vim.tiny'
    export VISUAL='vim.tiny'
elif (command -v vi 2>- 1>-); then
    export EDITOR='vi'
    export VISUAL='vi'
fi

if (command -v less 2>- 1>-); then
    export PAGER='less'
fi

# if (command -v qutebrowser 2>- 1>-); then
    # export BROWSER='qutebrowser'
# elif (command -v firefox 2>- 1>-); then
    # export BROWSER='firefox'
# elif (command -v iceweasel 2>- 1>-); then
    # export BROWSER='iceweasel'
# elif (command -v chromium 2>- 1>-); then
    # export BROWSER='chromium'
# elif (command -v lynx 2>- 1>-); then
    # export BROWSER='lynx'
# fi

# if running bash include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
