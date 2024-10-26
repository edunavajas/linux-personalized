#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;

source ./code/common.sh

# Check if the script is being run as root
check_sudo

source ./code/install_update_dependencies.sh

#echo "Changing to home directory..."
#cd

cd $SCRIPT_DIR
source ./code/install_sxhkdrc.sh

cd $SCRIPT_DIR
source ./code/install_bspwm.sh

cd $SCRIPT_DIR
source ./code/install_picom.sh

cd $SCRIPT_DIR
source ./code/install_fonts.sh

echo "Setting up fonts..."

cd $SCRIPT_DIR
source ./code/install_kitty.sh

cd $SCRIPT_DIR
source ./code/install_wallpaper.sh

cd $SCRIPT_DIR
source ./code/install_polybar.sh

cd $SCRIPT_DIR
source ./code/zsh_configs.sh

cd $SCRIPT_DIR
source ./code/fix_burpsuite.sh

cd $SCRIPT_DIR
source ./code/install_fzf.sh

cd $SCRIPT_DIR
source ./code/install_nvm.sh

echo -ne "\nScript completed successfully.\n"

#sudo kill -9 -1

