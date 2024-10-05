#!/bin/bash

# First set permission to the file chmod +x setup.sh


# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

# Path to the sources.list file
SOURCE_LIST="/etc/apt/sources.list"

# Backup the sources.list file before modifying it
cp $SOURCE_LIST "${SOURCE_LIST}.backup"

# Comment out the first line in the sources.list file
sed -i '1 s/^/#/' $SOURCE_LIST

apt update

# Update the package list
if grep -qi "parrot" /etc/os-release; then
    parrot-upgrade
else
    apt upgrade -y
fi

apt install build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

cd

# Get the path to the Downloads directory in the user's language
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD)


# Check if the bspwm/examples directory exists in Downloads
if [ -d "$DOWNLOADS_DIR" ]; then
    echo "Changing directory to $DOWNLOADS_DIR..."
    cd "$DOWNLOADS_DIR" || exit
else
    echo "The directory $DOWNLOADS_DIR does not exist. Creating it now..."
    mkdir -p "$DOWNLOADS_DIR"
    echo "Directory created. Changing directory to $DOWNLOADS_DIR..."
    cd "$DOWNLOADS_DIR" || exit
fi


git clone https://github.com/baskerville/bspwm.git

cd bspwm
make
sudo make install
cd ..

git clone https://github.com/baskerville/sxhkd.git

cd sxhkd
make
sudo make install
cd ..

mkdir ~/.config/{bspwm,sxhkd}

cd bspwm/examples

# Check if the current user is root
if [ "$EUID" -eq 0 ]; then
    # Get the default user's name (replace 'username' with your normal user's name if necessary)
    DEFAULT_USER=$(logname)
    
    echo "Currently running as root. Switching to user: $DEFAULT_USER..."
    
    # Switch to the normal user
    su -l "$DEFAULT_USER"
else
    echo "Already running as a normal user."
fi

cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/


apt install kitty

# Define the target sxhkd configuration file path
SXHKD_CONFIG="/home/$DEFAULT_USER/.config/sxhkd/sxhkdrc"

# Create the directory if it doesn't exist
mkdir -p "/home/$DEFAULT_USER/.config/sxhkd/"

# Write the desired configuration to sxhkdrc, replacing 'eduknives' with the actual username
cat <<EOF > "$SXHKD_CONFIG"
#
# wm independent hotkeys
#

# terminal emulator
super + Return
	/usr/bin/kitty

# program launcher
super + @space
	dmenu_run

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#
# bspwm hotkeys
#

# quit/restart bspwm
super + shift + {q,r}
	bspc {quit,wm -r}

# close and kill
super + {_,shift + }q
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local

# swap the current node and the biggest window
super + g
	bspc node -s biggest.window

#
# state/flags
#

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

#
# focus/swap
#

# focus the node in the given direction
super + {_,shift + }{Left,Down,Up,Right}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous window in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local.!hidden.window

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \\
	bspc node {older,newer} -f; \\
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#
# preselect
#

# preselect the direction
super + ctrl + alt + {Left,Down,Up,Right}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + alt + space
	bspc node -p cancel

# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#
# move/resize
#

# move a floating window
super + shift + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}

# Custom Resize
super + alt + {Left,Down,Up,Right}
	/home/$DEFAULT_USER/.config/bspwm/scripts/bspwm_resize {west,south,north,east}
EOF

echo "sxhkd configuration has been written to $SXHKD_CONFIG"


# Navigate to the bspwm configuration directory
cd "/home/$DEFAULT_USER/.config/bspwm"

# Create the scripts directory if it does not exist
mkdir -p scripts

# Create and write the bspwm_resize script
cat <<'EOF' > scripts/bspwm_resize
#!/usr/bin/env dash

if bspc query -N -n focused.floating > /dev/null; then
    step=20
else
    step=100
fi

case "$1" in
    west) dir=right; falldir=left; x="-$step"; y=0;;
    east) dir=right; falldir=left; x="$step"; y=0;;
    north) dir=top; falldir=bottom; x=0; y="-$step";;
    south) dir=top; falldir=bottom; x=0; y="$step";;
esac

bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"
EOF

# Give execution permissions to the bspwm_resize script
chmod +x scripts/bspwm_resize

echo "The bspwm_resize script has been created and made executable in /home/$DEFAULT_USER/.config/bspwm/scripts/"



echo "Script completed successfully."
