#!/bin/bash

source ./common.sh

echo "Cloning fzf for $DEFAULT_USER..."
cd
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo su 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
exit
update_progress