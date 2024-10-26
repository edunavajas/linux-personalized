#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

cd "$DOWNLOADS_DIR"
echo "Downloading and installing Java JDK 21..."
wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz >/dev/null 2>&1
tar xvf openjdk-21.0.2_linux-x64_bin.tar.gz >/dev/null 2>&1
sudo mv jdk-21.0.2/ /usr/lib/jvm/jdk-21
sudo geany /usr/bin/burpsuite
update_progress

echo "Creating burpsuite launcher script..."
cd /usr/bin
echo $PATH
sudo su
touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher
update_progress
exit
