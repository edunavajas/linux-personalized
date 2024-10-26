#!/bin/bash

source "$SCRIPT_DIR/code/common.sh" 

touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher
update_progress

