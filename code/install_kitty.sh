#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

echo "Downloading latest release of kitty terminal..."
# latest_release=$(curl -s https://api.github.com/repos/kovidgoyal/kitty/releases/latest | grep "tag_name" | cut -d '"' -f 4)
# wget https://github.com/kovidgoyal/kitty/releases/download/$latest_release/kitty-$latest_release-x86_64.txz >/dev/null 2>&1
# curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
#     installer=nightly >/dev/null 2>&1
# run_command "Installing kitty" "apt install -y kitty"	
# update_progress

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

RELEASE_URL="https://api.github.com/repos/kovidgoyal/kitty/releases/latest"
LATEST_VERSION=$(curl -s $RELEASE_URL | grep "tag_name" | sed -E 's/.*"v([^"]+)".*/\1/')
DOWNLOAD_URL="https://github.com/kovidgoyal/kitty/releases/download/v$LATEST_VERSION/kitty-$LATEST_VERSION-x86_64.txz"
echo "Descargando Kitty versión $LATEST_VERSION..."
curl -L $DOWNLOAD_URL -o ~/$DOWNLOADS_DIR/kitty-$LATEST_VERSION-x86_64.txz
cd /opt
mv /home/$DEFAULT_USER/$DOWNLOADS_DIR/kitty-$LATEST_VERSION-x86_64.txz .
7z x kitty-$LATEST_VERSION-x86_64.txz
rm kitty-$LATEST_VERSION-x86_64.txz
mkdir -p kitty
mv kitty-$LATEST_VERSION-x86_64.tar kitty/
cd kitty/
tar -xf kitty-$LATEST_VERSION-x86_64.tar
rm kitty-$LATEST_VERSION-x86_64.tar

echo "Instalación de Kitty completada. Configuración abierta en nano."


echo "Setting up kitty configuration for user $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/kitty
touch /home/$DEFAULT_USER/.config/kitty/kitty.conf
envsubst < "$SCRIPT_DIR/.config/kitty/kitty.conf" > /home/$DEFAULT_USER/.config/kitty/kitty.conf
chmod +x /home/$DEFAULT_USER/.config/kitty/kitty.conf
touch /home/$DEFAULT_USER/.config/kitty/color.ini
envsubst < "$SCRIPT_DIR/.config/kitty/color.ini" > /home/$DEFAULT_USER/.config/kitty/color.ini
chmod +x /home/$DEFAULT_USER/.config/kitty/color.ini
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/kitty
update_progress

sudo su
echo "Copying kitty configuration to root's .config directory..."
mkdir -p /root/.config/kitty
cp /home/$DEFAULT_USER/.config/kitty/* /root/.config/kitty/
update_progress
exit