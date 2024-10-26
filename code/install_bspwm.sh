#!/bin/bash

source ./common.sh

echo "Creating scripts directory in bspwm configuration..."
mkdir -p /home/$DEFAULT_USER/.config/bspwm/scripts
update_progress

echo "Generating bspwmrc configuration..."
touch /home/$DEFAULT_USER/.config/bspwm/bspwmrc
envsubst < "$SCRIPT_DIR/.config/bspwm/bspwmrc" > /home/$DEFAULT_USER/.config/bspwm/bspwmrc
chmod +x /home/$DEFAULT_USER/.config/bspwm/bspwmrc
chmod +x /home/$DEFAULT_USER/.config/bspwm
update_progress

echo "Copying bspwm_resize script..."
cp "$SCRIPT_DIR/.config/bspwm/scripts/bspwm_resize" /home/$DEFAULT_USER/.config/bspwm/scripts/
chmod +x /home/$DEFAULT_USER/.config/bspwm/scripts/bspwm_resize
update_progress

run_command "Setting ownership of bspwm configuration to $DEFAULT_USER" "chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/bspwm"

echo "Setting up bspwm scripts for $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/bspwm/scripts
cd /home/$DEFAULT_USER/.config/bspwm/scripts
touch /home/$DEFAULT_USER/.config/bspwm/scripts/ethernet_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status.sh" > ethernet_status.sh
chmod +x ethernet_status.sh
touch /home/$DEFAULT_USER/.config/bspwm/scripts/ethernet_status_copy.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status_copy.sh" > ethernet_status_copy.sh
chmod +x ethernet_status_copy.sh
touch /home/$DEFAULT_USER/.config/bspwm/scripts/vpn_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/vpn_status.sh" > vpn_status.sh
chmod +x vpn_status.sh
touch /home/$DEFAULT_USER/.config/bspwm/scripts/vpn_status_copy.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/victim_to_hack.sh" > victim_to_hack.sh
chmod +x victim_to_hack.sh
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/bspwm/scripts
update_progress