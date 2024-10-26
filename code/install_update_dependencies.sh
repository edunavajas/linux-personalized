#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

source "$SCRIPT_DIR/code/upgrade_system.sh"

run_command "Installing build-essential and related packages" "apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev"

run_command "Installing more XCB development packages" "apt install -y libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev"

run_command "Installing additional XCB and related development packages" "apt install -y libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev"

run_command "Installing XCB image and rendering packages" "apt install -y libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev"

run_command "Installing development tools and applications" "apt install -y libxcb-xfixes0-dev meson ninja-build uthash-dev cmake polybar rofi zsh imagemagick feh zsh-autosuggestions"

run_command "Installing zsh syntax highlighting and other utilities" "apt install -y zsh-syntax-highlighting ranger xcb-proto libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util-dev"

run_command "Installing bspwm and sxhkd" "apt install -y bspwm sxhkd cmake"

run_command "Updating package lists again" "apt update -y"