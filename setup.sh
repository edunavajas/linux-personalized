#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;

source ./code/common.sh

# Check if the script is being run as root
check_sudo

source ./code/install_update_dependencies.sh

echo "Changing to home directory..."
cd

source ./code/install_sxhkdrc.sh

source ./code/install_bspwm.sh

source ./code/install_picom.sh

source ./code/install_fonts.sh

source ./code/install_kitty.sh

source ./code/install_wallpaper.sh

source ./code/install_polybar.sh

source ./code/zsh_configs.sh

source ./code/fix_burpsuite.sh

source ./code/install_fzf.sh

source ./code/install_nvm.sh

echo -ne "\nScript completed successfully.\n"

sudo kill -9 -1

