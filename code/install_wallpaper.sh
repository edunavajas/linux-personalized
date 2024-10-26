#!/bin/bash

echo "Downloading and setting wallpaper..."
cd "$DOWNLOADS_DIR"
wget "https://tcgmania.es/cdn/shop/files/banner-pokemon.jpg" -O fondo.jpg >/dev/null 2>&1
feh --bg-fill fondo.jpg >/dev/null 2>&1
rm fondo.jpg
update_progress