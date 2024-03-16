# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export BLUEHOME=/blue/gerber/cdevaneprugh
export CIMETESTING=/blue/gerber/cdevaneprugh/my_cesm_sandbox/cime/scripts/tests
export CIMEROOT=/blue/gerber/cdevaneprugh/my_cesm_sandbox/cime
