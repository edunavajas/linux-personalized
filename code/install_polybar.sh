#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

run_command "Deploying polybar" "git clone https://github.com/VaughnValle/blue-sky.git"

echo "Copying polybar configuration..."

cd blue-sky/polybar
cp -r * ~/.config/polybar/

# cd blue-sky/polybar
# mkdir -p /home/$DEFAULT_USER/.config/polybar
# cp -r * /home/$DEFAULT_USER/.config/polybar/ >/dev/null 2>&1
# echo '/home/'$DEFAULT_USER'/.config/polybar/launch.sh' >> /home/$DEFAULT_USER/.config/bspwm/bspwmrc

echo "Configuring Polybar for $DEFAULT_USER..."
#cp -rf $SCRIPT_DIR/.config/polybar /home/$DEFAULT_USER/.config/polybar
touch /home/$DEFAULT_USER/.config/polybar/launch.sh
envsubst < "$SCRIPT_DIR/.config/polybar/launch.sh" > /home/$DEFAULT_USER/.config/polybar/launch.sh
touch /home/$DEFAULT_USER/.config/polybar/workspace.ini
envsubst < "$SCRIPT_DIR/.config/polybar/workspace.ini" > /home/$DEFAULT_USER/.config/polybar/workspace.ini
touch /home/$DEFAULT_USER/.config/polybar/current.ini
envsubst < "$SCRIPT_DIR/.config/polybar/current.ini" > /home/$DEFAULT_USER/.config/polybar/current.ini
touch /home/$DEFAULT_USER/.config/polybar/colors.ini
envsubst < "$SCRIPT_DIR/.config/polybar/colors.ini" > /home/$DEFAULT_USER/.config/polybar/colors.ini
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/polybar
chmod +x /home/$DEFAULT_USER/.config/polybar/launch.sh
update_progress