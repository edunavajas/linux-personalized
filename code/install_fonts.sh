#!/bin/bash

echo "Changing to fonts directory..."
cd /usr/local/share/fonts

echo "Fetching latest release of Nerd Fonts Hack..."
latest_release=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "tag_name" | cut -d '"' -f 4)

echo "Downloading Hack Nerd Font..."
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$latest_release/Hack.zip >/dev/null 2>&1

echo "Extracting Hack.zip..."
7z x Hack.zip >/dev/null 2>&1
rm Hack.zip LICENSE.md README.md >/dev/null 2>&1


cp fonts/* /usr/share/fonts/truetype/ >/dev/null 2>&1
cp -rf $SCRIPT_DIR/usr/share/fonts/truetype/* /usr/share/fonts/truetype/
fc-cache -v >/dev/null 2>&1
usermod --shell /usr/bin/zsh root
usermod --shell /usr/bin/zsh $(logname)
# chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/polybar