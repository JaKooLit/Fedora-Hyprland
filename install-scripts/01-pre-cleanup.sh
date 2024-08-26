#!/bin/bash

# This script is cleaning up previous manual installation files / directories

# 22 Aug 2024
# Removing previous manual installation of Wallust-dev
WAL_FILE="/usr/local/bin/wallust"

# Directories to check and delete
WAL_DIR1="/usr/local/share/man/man1"
WAL_DIR2="/usr/local/share/man/man5"

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_pre-clean-up.log"

# Check if the file exists and delete it
if [ -f "$WAL_FILE" ]; then
    sudo rm "$WAL_FILE"
    echo "[WALLUST-DEV] $WAL_FILE successfully deleted" 2>&1 | tee -a "$LOG"
fi

# Check if the first directory exists and delete it
if [ -d "$WAL_DIR1" ]; then
    sudo rm -r "$WAL_DIR1"
    echo "[WALLUST-DEV] $WAL_DIR1 successfully deleted" 2>&1 | tee -a "$LOG"
fi

# Check if the second directory exists and delete it
if [ -d "$WAL_DIR2" ]; then
    sudo rm -r "$WAL_DIR2"
    echo "[WALLUST-DEV] $WAL_DIR2 successfully deleted" 2>&1 | tee -a "$LOG"
fi
