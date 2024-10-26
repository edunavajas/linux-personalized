#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;

source "$SCRIPT_DIR/code/common.sh"

# Check if the script is being run as root
check_sudo

source "$SCRIPT_DIR/code/install_update_dependencies.sh"

#echo "Changing to home directory..."
#cd

source "$SCRIPT_DIR/code/install_sxhkdrc.sh"

source "$SCRIPT_DIR/code/install_bspwm.sh"

source "$SCRIPT_DIR/code/install_picom.sh"

source "$SCRIPT_DIR/code/install_fonts.sh"

echo "Setting up fonts..."

source "$SCRIPT_DIR/code/install_kitty.sh"

source "$SCRIPT_DIR/code/install_wallpaper.sh"

source "$SCRIPT_DIR/code/install_polybar.sh"

source "$SCRIPT_DIR/code/zsh_configs.sh"

source "$SCRIPT_DIR/code/fix_burpsuite.sh"

source "$SCRIPT_DIR/code/install_fzf.sh"

source "$SCRIPT_DIR/code/install_nvm.sh"

echo -ne "\nScript completed successfully.\n"

#sudo kill -9 -1

