#!/bin/bash

source .$SCRIPT_DIR/code/common.sh 

run_command "Creating configuration directories for bspwm and sxhkd" "mkdir -p /home/$DEFAULT_USER/.config/{bspwm,sxhkd}"

run_command "Setting ownership of configuration files to $DEFAULT_USER" "chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config"

echo "Ensuring sxhkd configuration directory exists..."
mkdir -p "/home/$DEFAULT_USER/.config/sxhkd/"
update_progress

echo "Generating sxhkd configuration..."
SXHKD_CONFIG="/home/$DEFAULT_USER/.config/sxhkd/sxhkdrc"
touch "$SXHKD_CONFIG"
envsubst < "$SCRIPT_DIR/.config/sxhkd/sxhkdrc" > "$SXHKD_CONFIG"
chmod +x "$SXHKD_CONFIG"
update_progress
