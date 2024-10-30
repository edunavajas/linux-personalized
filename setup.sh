#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;

source ./code/common.sh
run_as_root "source ./code/common.sh"
update_progress

# Check if the script is being run as root
check_sudo

source "$SCRIPT_DIR/code/install_update_dependencies.sh"
update_progress

source "$SCRIPT_DIR/code/install_sxhkdrc.sh"
update_progress

source "$SCRIPT_DIR/code/install_bspwm.sh"
update_progress

source "$SCRIPT_DIR/code/install_picom.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/install_wallpaper.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/install_polybar.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/install_fzf.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/install_nvm.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/install_kitty.sh"
update_progress

run_as_user "source $SCRIPT_DIR/code/fix_burpsuite.sh"
update_progress

run_as_root "source $SCRIPT_DIR/code/install_fonts.sh"
update_progress

run_as_root "source $SCRIPT_DIR/code/zsh_configs.sh"
update_progress

run_as_root "source $SCRIPT_DIR/code/install_fzf.sh"
update_progress


echo -ne "\nScript completed successfully.\n"
read -p "Do you want to log out to apply the changes? (y/n): " response

if [[ "$response" =~ ^[yY]$ ]]; then
    echo "Logging out..."
    sudo kill -9 -1
else
    echo "Logout skipped. Changes applied but require a manual restart to take effect."
fi
