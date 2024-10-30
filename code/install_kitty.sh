#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

echo "Downloading latest release of kitty terminal..."

DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

RELEASE_URL="https://api.github.com/repos/kovidgoyal/kitty/releases/latest"
LATEST_VERSION=$(curl -s $RELEASE_URL | grep "tag_name" | sed -E 's/.*"v([^"]+)".*/\1/')
DOWNLOAD_URL="https://github.com/kovidgoyal/kitty/releases/download/v$LATEST_VERSION/kitty-$LATEST_VERSION-x86_64.txz"
echo "Descargando Kitty versión $LATEST_VERSION..."
echo "Descargando Kitty desde $DOWNLOAD_URL..."
curl -L $DOWNLOAD_URL -o /home/$DEFAULT_USER/kitty-$LATEST_VERSION-x86_64.txz
echo "Instalando Kitty versión $LATEST_VERSION..."
cd /opt
mv /home/$DEFAULT_USER/kitty-$LATEST_VERSION-x86_64.txz .
echo "Descomprimiendo Kitty..."
7z x kitty-$LATEST_VERSION-x86_64.txz
echo "Borrando Kitty..."
rm kitty-$LATEST_VERSION-x86_64.txz
mkdir -p kitty
mv kitty-$LATEST_VERSION-x86_64.tar kitty/
cd kitty/
tar -xf kitty-$LATEST_VERSION-x86_64.tar
rm kitty-$LATEST_VERSION-x86_64.tar

echo "Instalación de Kitty completada. Configuración abierta en nano."
usermod --shell /usr/bin/zsh $(logname)

echo "Setting up kitty configuration for user $DEFAULT_USER..."
mkdir -p /home/$DEFAULT_USER/.config/kitty
touch /home/$DEFAULT_USER/.config/kitty/kitty.conf
envsubst < "$SCRIPT_DIR/.config/kitty/kitty.conf" > /home/$DEFAULT_USER/.config/kitty/kitty.conf
chmod +x /home/$DEFAULT_USER/.config/kitty/kitty.conf
touch /home/$DEFAULT_USER/.config/kitty/color.ini
envsubst < "$SCRIPT_DIR/.config/kitty/color.ini" > /home/$DEFAULT_USER/.config/kitty/color.ini
chmod +x /home/$DEFAULT_USER/.config/kitty/color.ini
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/.config/kitty

run_as_root "source $SCRIPT_DIR/code/copy_kitty.sh"