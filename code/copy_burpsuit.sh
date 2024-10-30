#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BURP_DIR="/opt/burpsuite"
BURP_LAUNCHER="$BURP_DIR/burpsuite.jar"
BURP_DOWNLOAD_URL="https://portswigger-cdn.net/burp/releases/download"

if [ ! -f "$BURP_LAUNCHER" ]; then
    echo "Burp Suite is not installed. Installing Burp Suite..."
    
    sudo mkdir -p "$BURP_DIR"

    echo "Downloading Burp Suite from $BURP_DOWNLOAD_URL..."
    wget -O "$BURP_LAUNCHER" "$BURP_DOWNLOAD_URL"

    sudo chmod +x "$BURP_LAUNCHER"
    echo "Burp Suite installation completed."
else
    echo "Burp Suite is already installed."
fi

touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher


