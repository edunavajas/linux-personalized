#!/bin/bash

# First set permission to the file chmod +x setup.sh

# Initialize progress variables
TOTAL_STEPS=30  # Total number of major steps in the script
CURRENT_STEP=0

# Function to update progress bar
update_progress() {
    ((CURRENT_STEP++))
    PERCENT=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
    echo -ne "Progress: ["
    for ((i=0; i< $PERCENT/2; i++)); do echo -n "#"; done
    for ((i=$PERCENT/2; i<50; i++)); do echo -n " "; done
    echo -ne "] $PERCENT% ($CURRENT_STEP/$TOTAL_STEPS)\r"
}

# Function to log and suppress command output
run_command() {
    echo -e "\n$1"
    eval "$2" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    fi
    update_progress
}

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

DEFAULT_USER=$(logname)
export DEFAULT_USER

echo "Default user detected: $DEFAULT_USER"

echo "Determining script directory..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
update_progress

SOURCE_LIST="/etc/apt/sources.list"

run_command "Backing up $SOURCE_LIST" "cp $SOURCE_LIST ${SOURCE_LIST}.backup"

run_command "Commenting out the first line of $SOURCE_LIST" "sed -i '1 s/^/#/' $SOURCE_LIST"

run_command "Updating package lists" "apt update -y"

if grep -qi "parrot" /etc/os-release; then
    run_command "Running parrot-upgrade" "parrot-upgrade"
else
    run_command "Upgrading packages" "apt upgrade -y"
fi

run_command "Installing build-essential and related packages" "apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev"

run_command "Installing more XCB development packages" "apt install -y libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev"

run_command "Installing additional XCB and related development packages" "apt install -y libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev"

run_command "Installing XCB image and rendering packages" "apt install -y libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev"

run_command "Installing development tools and applications" "apt install -y libxcb-xfixes0-dev meson ninja-build uthash-dev cmake polybar rofi zsh imagemagick feh zsh-autosuggestions"

run_command "Installing zsh syntax highlighting and other utilities" "apt install -y zsh-syntax-highlighting ranger xcb-proto libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util-dev"

run_command "Updating package lists again" "apt update -y"

echo "Changing to home directory..."
cd
update_progress

echo "Determining Downloads directory..."
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD)
if [ -d "$DOWNLOADS_DIR" ]; then
    echo "Changing directory to $DOWNLOADS_DIR..."
    cd "$DOWNLOADS_DIR" || exit
else
    echo "The directory $DOWNLOADS_DIR does not exist. Creating it now..."
    mkdir -p "$DOWNLOADS_DIR"
    echo "Directory created. Changing directory to $DOWNLOADS_DIR..."
    cd "$DOWNLOADS_DIR" || exit
fi
update_progress

run_command "Cloning bspwm repository" "git clone https://github.com/baskerville/bspwm.git"

echo "Building and installing bspwm..."
cd bspwm
make >/dev/null 2>&1
make install >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to build and install bspwm."
    exit 1
fi
cd ..
update_progress

run_command "Cloning sxhkd repository" "git clone https://github.com/baskerville/sxhkd.git"

echo "Building and installing sxhkd..."
cd sxhkd
make >/dev/null 2>&1
make install >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to build and install sxhkd."
    exit 1
fi
cd ..
update_progress

run_command "Creating configuration directories for bspwm and sxhkd" "mkdir -p /home/$DEFAULT_USER/.config/{bspwm,sxhkd}"

echo "Copying bspwmrc and sxhkdrc to $DEFAULT_USER's configuration directories..."
cd bspwm/examples
cp bspwmrc /home/$DEFAULT_USER/.config/bspwm/
cp sxhkdrc /home/$DEFAULT_USER/.config/sxhkd/
update_progress

run_command "Setting ownership of configuration files to $DEFAULT_USER" "chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config"

echo "Ensuring sxhkd configuration directory exists..."
mkdir -p "/home/$DEFAULT_USER/.config/sxhkd/"
update_progress

echo "Writing sxhkd configuration..."
SXHKD_CONFIG="/home/$DEFAULT_USER/.config/sxhkd/sxhkdrc"
envsubst < "$SCRIPT_DIR/.config/sxhkd/sxhkdrc" > "$SXHKD_CONFIG"
update_progress

echo "Creating scripts directory in bspwm configuration..."
mkdir -p /home/$DEFAULT_USER/.config/bspwm/scripts
update_progress

echo "Generating bspwmrc configuration..."
envsubst < "$SCRIPT_DIR/.config/bspwm/bspwmrc" > /home/$DEFAULT_USER/.config/bspwm/bspwmrc
update_progress

echo "Copying bspwm_resize script..."
cp "$SCRIPT_DIR/scripts/bspwm_resize" /home/$DEFAULT_USER/.config/bspwm/scripts/
chmod +x /home/$DEFAULT_USER/.config/bspwm/scripts/bspwm_resize
update_progress

run_command "Setting ownership of bspwm configuration to $DEFAULT_USER" "chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/bspwm"

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

echo "Changing to fonts directory..."
cd /usr/local/share/fonts
update_progress

echo "Fetching latest release of Nerd Fonts Hack..."
latest_release=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "tag_name" | cut -d '"' -f 4)
update_progress

echo "Downloading Hack Nerd Font..."
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$latest_release/Hack.zip >/dev/null 2>&1
update_progress

echo "Extracting Hack.zip..."
7z x Hack.zip >/dev/null 2>&1
rm Hack.zip LICENSE.md README.md >/dev/null 2>&1
update_progress

echo "Generating bspwmrc configuration..."
envsubst < "$SCRIPT_DIR/.config/bspwm/bspwmrc" > /home/$DEFAULT_USER/.config/bspwm/bspwmrc
chown $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/bspwm/bspwmrc
update_progress

echo "Downloading latest release of kitty terminal..."
# latest_release=$(curl -s https://api.github.com/repos/kovidgoyal/kitty/releases/latest | grep "tag_name" | cut -d '"' -f 4)
# wget https://github.com/kovidgoyal/kitty/releases/download/$latest_release/kitty-$latest_release-x86_64.txz >/dev/null 2>&1
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    installer=nightly >/dev/null 2>&1
update_progress

## echo "Moving kitty package to /opt and extracting..."
## mv kitty-$latest_release-x86_64.txz /opt/
## cd /opt/
## 7z x kitty-$latest_release-x86_64.txz >/dev/null 2>&1
## rm kitty-$latest_release-x86_64.txz
## mkdir kitty
## mv kitty-$latest_release-x86_64.tar kitty/
## cd kitty/
## tar -xf kitty-$latest_release-x86_64.tar >/dev/null 2>&1
## rm kitty-$latest_release-x86_64.tar
## update_progress

echo "Setting up kitty configuration for user $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/kitty
envsubst < "$SCRIPT_DIR/.config/kitty/kitty.conf" > /home/$DEFAULT_USER/.config/kitty/kitty.conf
envsubst < "$SCRIPT_DIR/.config/kitty/color.ini" > /home/$DEFAULT_USER/.config/kitty/color.ini
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/kitty
update_progress

echo "Downloading and setting wallpaper..."
cd "$DOWNLOADS_DIR"
wget "https://tcgmania.es/cdn/shop/files/banner-pokemon.jpg" -O fondo.jpg >/dev/null 2>&1
sudo -u $DEFAULT_USER feh --bg-fill fondo.jpg >/dev/null 2>&1
rm fondo.jpg
update_progress

echo "Copying kitty configuration to root's .config directory..."
mkdir -p /root/.config/kitty
cp /home/$DEFAULT_USER/.config/kitty/* /root/.config/kitty/
update_progress

run_command "Deploying polybar" "git clone https://github.com/VaughnValle/blue-sky.git"

echo "Copying polybar configuration..."
cd blue-sky/polybar
mkdir -p /home/$DEFAULT_USER/.config/polybar
cp -r * /home/$DEFAULT_USER/.config/polybar/ >/dev/null 2>&1
echo '/home/'$DEFAULT_USER'/.config/polybar/launch.sh' >> /home/$DEFAULT_USER/.config/bspwm/bspwmrc
cp fonts/* /usr/share/fonts/truetype/ >/dev/null 2>&1
fc-cache -v >/dev/null 2>&1
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/polybar
update_progress

echo "Changing default shell to zsh for root and $DEFAULT_USER..."
chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh $DEFAULT_USER
update_progress

echo "Setting up picom configuration for $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/picom
envsubst < "$SCRIPT_DIR/.config/picom/picom.conf" > /home/$DEFAULT_USER/.config/picom/picom.conf
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/picom
update_progress

echo "Cloning powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$DEFAULT_USER/powerlevel10k >/dev/null 2>&1
update_progress

echo "Setting up zsh configuration for $DEFAULT_USER..."
envsubst < "$SCRIPT_DIR/~/.zshrc" > /home/$DEFAULT_USER/.zshrc
envsubst < "$SCRIPT_DIR/~/.p10k.zsh" > /home/$DEFAULT_USER/.p10k.zsh
ln -s -f /home/$DEFAULT_USER/.zshrc /root/.zshrc
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

echo "Downloading and installing Java JDK 21..."
wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz >/dev/null 2>&1
tar xvf openjdk-21.0.2_linux-x64_bin.tar.gz >/dev/null 2>&1
mv jdk-21.0.2/ /usr/lib/jvm/jdk-21
update_progress

echo "Creating burpsuite launcher script..."
cd /usr/bin
touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher
update_progress

echo "Configuring Polybar for $DEFAULT_USER..."
envsubst < "$SCRIPT_DIR/.config/polybar/launch.sh" > /home/$DEFAULT_USER/.config/polybar/launch.sh
envsubst < "$SCRIPT_DIR/.config/polybar/workspace.ini" > /home/$DEFAULT_USER/.config/polybar/workspace.ini
envsubst < "$SCRIPT_DIR/.config/polybar/current.ini" > /home/$DEFAULT_USER/.config/polybar/current.ini
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/polybar
update_progress

echo "Setting up bspwm scripts for $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/bspwm/scripts
cd /home/$DEFAULT_USER/.config/bspwm/scripts
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status.sh" > ethernet_status.sh
chmod +x ethernet_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status_copy.sh" > ethernet_status_copy.sh
chmod +x ethernet_status_copy.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/vpn_status.sh" > vpn_status.sh
chmod +x vpn_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/victim_to_hack.sh" > victim_to_hack.sh
chmod +x victim_to_hack.sh
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/bspwm/scripts
update_progress

echo "Cloning fzf for $DEFAULT_USER..."
sudo -u $DEFAULT_USER git clone --depth 1 https://github.com/junegunn/fzf.git /home/$DEFAULT_USER/.fzf >/dev/null 2>&1
sudo -u $DEFAULT_USER /home/$DEFAULT_USER/.fzf/install --all >/dev/null 2>&1
update_progress

echo "Cloning fzf for root..."
git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf >/dev/null 2>&1
/root/.fzf/install --all >/dev/null 2>&1
update_progress

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
envsubst < "$SCRIPT_DIR/nvim-plugins/init.lua" > /home/$DEFAULT_USER/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/init.lua
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.local/share/nvim
update_progress

rofi-theme-selector

echo -ne "\nScript completed successfully.\n"


Neovim plugins for test...(60/30)
XDG_DATA_DIRS needs to be set for this script to function correctly.
Using dirs from $PATH: /usr/local/share:/usr/share
Checking themes in: /usr/share/rofi/themes
/usr/bin/sed: no se puede leer /root/.config/rofi/config.rasi: No existe el fichero o el directorio

