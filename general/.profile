# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# Locales
export LANG=en_US.utf8
export LC_MONETARY=fr_FR.utf8
export LC_MEASUREMENT=fr_FR.utf8
export LC_NUMERIC=en_US.utf8
export LC_PAPER=fr_FR.utf8
export LC_TELEPHONE=fr_FR.utf8
export LC_TIME=fr_FR.utf8


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
    if [ -f "$HOME/.zsh/zshrc" ]; then
	. "$HOME/.zsh/zshrc"
    fi
fi

# set PATH so it includes python
if [ -d "$HOME/.anaconda3/bin" ]; then
    PATH="$HOME/.anaconda3/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PYTHONPATH="$HOME/.anaconda3/pythonpath"

php "$HOME/.scripts/update_visible_earth.php" &

