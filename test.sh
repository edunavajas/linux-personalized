#!/bin/bash

EFAULT_USER=$(logname)
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD)

RELEASE_URL="https://api.github.com/repos/kovidgoyal/kitty/releases/latest"
LATEST_VERSION=$(curl -s $RELEASE_URL | grep "tag_name" | sed -E 's/.*"v([^"]+)".*/\1/')
DOWNLOAD_URL="https://github.com/kovidgoyal/kitty/releases/download/v$LATEST_VERSION/kitty-$LATEST_VERSION-x86_64.txz"
echo "Descargando Kitty versión $LATEST_VERSION..."
curl -L $DOWNLOAD_URL -o ~/$DOWNLOADS_DIR/kitty-$LATEST_VERSION-x86_64.txz
echo "Eliminando versión anterior de Kitty (si existe)..."
apt remove -y kitty
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