#!/bin/bash

echo "Downloading and setting wallpaper..."
wget "https://tcgmania.es/cdn/shop/files/banner-pokemon.jpg" -O fondo.jpg >/dev/null 2>&1
feh --bg-fill fondo.jpg >/dev/null 2>&1
rm fondo.jpg