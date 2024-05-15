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
export BLUE=/blue/gerber/cdevaneprugh
export CIMEOUTPUT=/blue/gerber/cdevaneprugh/earth_model_output/cime_output_root
export CESMCIME=/blue/gerber/earth_models/cesm215/cime
