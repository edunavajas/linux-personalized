#!/bin/bash

source ./common.sh

sudo su
echo "Cloning powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$DEFAULT_USER/powerlevel10k >/dev/null 2>&1
update_progress

echo "Setting up zsh configuration for $DEFAULT_USER..."
touch /home/$DEFAULT_USER/.zshrc
envsubst < "$SCRIPT_DIR/system/.zshrc" > ~/.zshrc
touch /home/$DEFAULT_USER/.p10k.zsh
envsubst < "$SCRIPT_DIR/system/.p10k.zsh" > ~/.p10k.zsh
ln -s -f /home/$DEFAULT_USER/.zshrc .zshrc 
cd /usr/share/zsh-autocomplete
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
update_progress

echo "Installing zsh-sudo plugin..."
mkdir -p /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh >/dev/null 2>&1
update_progress

echo "Installing bat and lsd..."
cd "$DOWNLOADS_DIR"
latest_bat=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep "tag_name" | cut -d '"' -f 4)
wget https://github.com/sharkdp/bat/releases/download/$latest_bat/bat_${latest_bat#v}_amd64.deb -O bat_latest_amd64.deb >/dev/null 2>&1
latest_lsd=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep "tag_name" | cut -d '"' -f 4)
wget https://github.com/lsd-rs/lsd/releases/download/$latest_lsd/lsd_${latest_lsd#v}_amd64.deb -O lsd_latest_amd64.deb >/dev/null 2>&1

dpkg -i bat_latest_amd64.deb >/dev/null 2>&1
dpkg -i lsd_latest_amd64.deb >/dev/null 2>&1
rm bat_latest_amd64.deb lsd_latest_amd64.deb
update_progress

exit