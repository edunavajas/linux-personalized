#!/bin/bash

# Variables compartidas
TOTAL_STEPS=30
CURRENT_STEP=0

DEFAULT_USER=$(logname)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_LIST="/etc/apt/sources.list"
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD)

export DEFAULT_USER
export SCRIPT_DIR
export SOURCE_LIST
export DOWNLOADS_DIR

update_progress() {
    ((CURRENT_STEP++))
    PERCENT=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
    echo -ne "Progress: ["
    for ((i=0; i< $PERCENT/2; i++)); do echo -n "#"; done
    for ((i=$PERCENT/2; i<50; i++)); do echo -n " "; done
    echo -ne "] $PERCENT% ($CURRENT_STEP/$TOTAL_STEPS)\r"
}

run_command() {
    echo -e "\n$1"
    eval "$2" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed."
        exit 1
    fi
    update_progress
}

check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root or using sudo."
        exit 1
    fi
}

function run_as_user() {
    bash -c "$1"
}

function run_as_root() {
    sudo bash -c "$1"
}


