#!/bin/bash

# First set permission to the file chmod +x setup.sh


# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE_LIST="/etc/apt/sources.list"

cp $SOURCE_LIST "${SOURCE_LIST}.backup"

sed -i '1 s/^/#/' $SOURCE_LIST

apt update -y

if grep -qi "parrot" /etc/os-release; then
    parrot-upgrade
else
    apt upgrade -y
fi

apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev \
 libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
 libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev \
 libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
 libxcb-xfixes0-dev meson ninja-build uthash-dev cmake polybar rofi zsh imagemagick feh sh-autocomplete zsh-autosuggestions \
 zsh-syntax-highlighting ranger xcb-proto libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util-dev

wait

apt update -y

cd

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


git clone https://github.com/baskerville/bspwm.git

cd bspwm
make
sudo make install
wait
cd ..

git clone https://github.com/baskerville/sxhkd.git

cd sxhkd
make
sudo make install
wait
cd ..

mkdir ~/.config/{bspwm,sxhkd}

cd bspwm/examples

if [ "$EUID" -eq 0 ]; then

    DEFAULT_USER=$(logname)
    
    echo "Currently running as root. Switching to user: $DEFAULT_USER..."
    
    su -l "$DEFAULT_USER"
else
    echo "Already running as a normal user."
fi

cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/


# Define the target sxhkd configuration file path
SXHKD_CONFIG="/home/$DEFAULT_USER/.config/sxhkd/sxhkdrc"

mkdir -p "/home/$DEFAULT_USER/.config/sxhkd/"

cat "$SCRIPT_DIR/.config/sxhkd/sxhkdrc" > "$SXHKD_CONFIG"

echo "sxhkd configuration has been written to $SXHKD_CONFIG"

cd "/home/$DEFAULT_USER/.config/bspwm"

mkdir -p scripts

envsubst < "$SCRIPT_DIR/scripts/bspwm_resize" > ~/.config/bspwm/bspwmrc

chmod +x scripts/bspwm_resize

echo "The bspwm_resize script has been created and made executable in /home/$DEFAULT_USER/.config/bspwm/scripts/"

git clone https://github.com/yshui/picom

cd picom
meson setup --buildtype=release build
ninja -C build
ninja -C build install


echo "Script completed successfully."

# Change fonts
sudo su
cd /usr/local/share/fonts

latest_release=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "tag_name" | cut -d '"' -f 4)

wget https://github.com/ryanoasis/nerd-fonts/releases/download/$latest_release/Hack.zip

mv Hack.zip /usr/local/share/fonts/

7z x Hack.zip

rm Hack.zip LICENSE.md README.md

exit

envsubst < "$SCRIPT_DIR/.config/bspwm/bspwmrc" > ~/.config/bspwm/bspwmrc

# Get kitty last version
sudo su

latest_release=$(curl -s https://api.github.com/repos/kovidgoyal/kitty/releases/latest | grep "tag_name" | cut -d '"' -f 4)

wget https://github.com/kovidgoyal/kitty/releases/download/$latest_release/kitty-$latest_release-x86_64.txz

# Mover el archivo descargado a /opt y extraerlo
sudo mv kitty-$latest_release-x86_64.txz /opt/
cd /opt/
sudo 7z x kitty-$latest_release-x86_64.txz
sudo rm kitty-$latest_release-x86_64.txz

sudo mkdir kitty
sudo mv kitty-$latest_release-x86_64.tar kitty/
cd kitty/
sudo tar -xf kitty-$latest_release-x86_64.tar
sudo rm kitty-$latest_release-x86_64.tar

envsubst < "$SCRIPT_DIR/.config/kitty/kitty.conf" > /home/$DEFAULT_USER/.config/kitty/kitty.conf
envsubst < "$SCRIPT_DIR/.config/kitty/color.ini" > /home/$DEFAULT_USER/.config/kitty/color.ini

# Wallpaper
wget "https://tcgmania.es/cdn/shop/files/banner-pokemon.jpg" -O fondo.jpg

feh --bg-fill fondo.jpg
rm fondo.jpg

sudo su
cd /root/.config/kitty
cp /home/$DEFAULT_USER/.config/kitty/* .

exit

# Deploy polybar
DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)

cd "$DOWNLOAD_DIR"

git clone https://github.com/VaughnValle/blue-sky.git

cd blue-sky/polybar
cp -r * ~/.config/polybar/
echo '~/.config/polybar/./launch.sh' >> ~/.config/bspwm/bspwmrc
sudo su
cp fonts/* /usr/share/fonts/truetype/

# Refrescar la caché de fuentes
fc-cache -v

usermod --shell /usr/bin/zsh root
usermod --shell /usr/bin/zsh $DEFAULT_USER

exit

mkdir ~/.config/picom
touch picom.conf
envsubst < "$SCRIPT_DIR/.config/picom/picom.conf" > /home/$DEFAULT_USER/.config/picom/picom.conf

sudo su
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

envsubst < "$SCRIPT_DIR/~/.zshrc" > ~/.zshrc
envsubst < "$SCRIPT_DIR/~/.p10k.zsh" > ~/.p10k.zsh

cd

ln -s -f /home/$DEFAULT_USER/.zshrc .zshrc 
cd /usr/share/zsh-autocomplete
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

cd /usr/share
mkdir zsh-sudo
cd zsh-sudo
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Install batcat and LSD

latest_bat=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep "tag_name" | cut -d '"' -f 4)

wget https://github.com/sharkdp/bat/releases/download/$latest_bat/bat_${latest_bat#v}_amd64.deb -O bat_latest_amd64.deb

latest_lsd=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep "tag_name" | cut -d '"' -f 4)

wget https://github.com/lsd-rs/lsd/releases/download/$latest_lsd/lsd_${latest_lsd#v}_amd64.deb -O lsd_latest_amd64.deb

cd ~/$DOWNLOAD_DIR
sudo dpkg -i ~/$DOWNLOAD_DIR/bat_latest_amd64.deb
sudo dpkg -i ~/$DOWNLOAD_DIR/lsd_latest_amd64.deb

rm ~/$DOWNLOAD_DIR/bat_latest_amd64.deb ~/Descargas/lsd_latest_amd64.deb


exit

cd /home/$DEFAULT_USER/Descargas
wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-21.0.2_linux-x64_bin.tar.gz
sudo mv jdk-21.0.2/ /usr/lib/jvm/jdk-21
sudo geany /usr/bin/burpsuite

cd /usr/bin
echo $PATH
sudo su
touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher
exit

# Configure Polybar
cd
envsubst < "$SCRIPT_DIR/.config/polybar/launch.sh" > .config/polybar/launch.sh
envsubst < "$SCRIPT_DIR/.config/polybar/workspace.ini" > .config/polybar/workspace.ini
envsubst < "$SCRIPT_DIR/.config/polybar/current.ini" > .config/polybar/current.ini

cd ~/.config/bspwm/scripts
touch ethernet_status.sh
chmod +x ethernet_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status.sh" > ethernet_status.sh

touch ethernet_status_copy.sh
chmod +x ethernet_status_copy.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/ethernet_status_copy.sh" > ethernet_status_copy.sh


touch vpn_status.sh
chmod +x vpn_status.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/vpn_status.sh" > vpn_status.sh


touch victim_to_hack.sh
chmod +x victim_to_hack.sh
envsubst < "$SCRIPT_DIR/.config/bspwm/scripts/victim_to_hack.sh" > victim_to_hack.sh


cd
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo su 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
exit

apt remove -y neovim
git clone https://github.com/NvChad/starter ~/.config/nvim


latest_nvim=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep "tag_name" | cut -d '"' -f 4)

wget https://github.com/neovim/neovim/releases/download/$latest_nvim/nvim-linux64.tar.gz -O nvim-linux64.tar.gz


sudo mkdir -p /opt/nvim

sudo mv nvim-linux64.tar.gz /opt/nvim/

cd /opt/nvim

sudo tar -xf nvim-linux64.tar.gz

sudo rm nvim-linux64.tar.gz

cd ~/.config/nvim

envsubst < "$SCRIPT_DIR/.config/nvim/init.lua" > init.lua

sudo apt install -y locate
sudo updatedb
umount /run/user/1000/gvfs
umount /run/user/1000/doc
sudo updatedb

cd ~/.config
mkdir rofi
cd rofi
mkdir themes
cd themes

cd /opt
sudo git clone https://github.com/newmanls/rofi-themes-collection
cd rofi-themes-collection/themes
sudo su
cp * /home/$DEFAULT_USER/.config/rofi/themes/
exit

apt install i3lock
cd /opt
git clone git clone https://github.com/meskarune/i3lock-fancy.git
sudo su
cd i3lock-fancy
make install
exit

envsubst < "$SCRIPT_DIR/nvim-plugins/init.lua" > ~/.local/share/nvim/lazy/NvChad/lua/nvchad/plugins/init.lua

sudo su
cd /root/.config/clipit
cp -r /home/$DEFAULT_USER/.config/nvim .
exit

rofi-theme-selector