#!/bin/bash

source ./common.sh

run_command "Cloning picom repository" "git clone https://github.com/yshui/picom"
echo "Building and installing picom..."
cd picom
meson setup --buildtype=release build >/dev/null 2>&1
ninja -C build >/dev/null 2>&1
ninja -C build install >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to build and install picom."
    exit 1
fi
cd ..
update_progress

echo "Setting up picom configuration for $DEFAULT_USER..."
mkdir ~/.config/picom
touch /home/$DEFAULT_USER/.config/picom/picom.conf
envsubst < "$SCRIPT_DIR/.config/picom/picom.conf" > /home/$DEFAULT_USER/.config/picom/picom.conf
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/picom

update_progress