#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;

source ./code/common.sh
run_as_root "source ./code/common.sh"

# Check if the script is being run as root
check_sudo

source "$SCRIPT_DIR/code/install_update_dependencies.sh"

source "$SCRIPT_DIR/code/install_sxhkdrc.sh"

source "$SCRIPT_DIR/code/install_bspwm.sh"

source "$SCRIPT_DIR/code/install_picom.sh"

echo "Setting up fonts..."

run_as_user "source $SCRIPT_DIR/code/install_wallpaper.sh"

run_as_user "source $SCRIPT_DIR/code/install_polybar.sh"

run_as_user "source $SCRIPT_DIR/code/install_fzf.sh"

run_as_user "source $SCRIPT_DIR/code/install_nvm.sh"

run_as_user "source $SCRIPT_DIR/code/install_kitty.sh"

run_as_user "source $SCRIPT_DIR/code/fix_burpsuite.sh"

run_as_root "source $SCRIPT_DIR/code/install_fonts.sh"
update_progress

run_as_root "source $SCRIPT_DIR/code/zsh_configs.sh"

run_as_root "source $SCRIPT_DIR/code/install_fzf.sh"


zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

echo -ne "\nScript completed successfully.\n"

#sudo kill -9 -1

