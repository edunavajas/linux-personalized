#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

touch burpsuite-launcher
chmod +x burpsuite-launcher
envsubst < "$SCRIPT_DIR/usr/bin/burpsuite-launcher" > burpsuite-launcher
update_progress

