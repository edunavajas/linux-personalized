#!/bin/bash

source .$SCRIPT_DIR/code/common.sh 

run_command "Backing up $SOURCE_LIST" "cp $SOURCE_LIST ${SOURCE_LIST}.backup"

run_command "Commenting out the first line of $SOURCE_LIST" "sed -i '1 s/^/#/' $SOURCE_LIST"

run_command "Updating package lists" "apt update -y"

if grep -qi "parrot" /etc/os-release; then
    run_command "Running parrot-upgrade" "parrot-upgrade"
else
    run_command "Upgrading packages" "apt upgrade -y"
fi