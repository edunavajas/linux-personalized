#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

run_command "Removing any existing neovim installation" "apt remove -y neovim"

echo "Cloning NvChad starter into $DEFAULT_USER's Neovim configuration..."
sudo -u $DEFAULT_USER git clone https://github.com/NvChad/starter /home/$DEFAULT_USER/.config/nvim >/dev/null 2>&1
update_progress

echo "Downloading latest Neovim release..."
latest_nvim=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep "tag_name" | cut -d '"' -f 4)
wget https://github.com/neovim/neovim/releases/download/$latest_nvim/nvim-linux64.tar.gz -O nvim-linux64.tar.gz >/dev/null 2>&1
mkdir -p /opt/nvim
mv nvim-linux64.tar.gz /opt/nvim/
cd /opt/nvim
tar -xf nvim-linux64.tar.gz >/dev/null 2>&1
rm nvim-linux64.tar.gz
update_progress

echo "Setting up Neovim configuration for $DEFAULT_USER..."
top /home/$DEFAULT_USER/.config/nvim/init.lua
envsubst < "$SCRIPT_DIR/.config/nvim/init.lua" > /home/$DEFAULT_USER/.config/nvim/init.lua
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/nvim
update_progress

run_command "Installing locate and updating database" "apt install -y locate && updatedb"

echo "Unmounting gvfs and doc directories..."
umount /run/user/1000/gvfs >/dev/null 2>&1
umount /run/user/1000/doc >/dev/null 2>&1
updatedb >/dev/null 2>&1
update_progress

echo "Setting up rofi themes for $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/rofi/themes
cd /opt
git clone https://github.com/newmanls/rofi-themes-collection >/dev/null 2>&1
cp /opt/rofi-themes-collection/themes/* /home/$DEFAULT_USER/.config/rofi/themes/ >/dev/null 2>&1
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/rofi
update_progress

run_command "Installing i3lock and i3lock-fancy" "apt install -y i3lock && git clone https://github.com/meskarune/i3lock-fancy.git /opt/i3lock-fancy && cd /opt/i3lock-fancy && make install"

echo "Configuring Neovim plugins for $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/
touch /home/$DEFAULT_USER/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/init.lua
envsubst < "$SCRIPT_DIR/nvim-plugins/init.lua" > /home/$DEFAULT_USER/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/init.lua
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.local/share/nvim
update_progress

rofi-theme-selector