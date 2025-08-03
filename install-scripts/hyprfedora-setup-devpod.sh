#!/bin/bash
# Install DevPod (https://www.devpod.sh) #

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source global functions
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_devpod.log"

printf "\n%.0s" {1..1}

echo -e "${NOTE} Installing ${SKY_BLUE}DevPod${RESET} ...\n"

(
  stdbuf -oL curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && \
  sudo install -c -m 0755 devpod /usr/local/bin && \
  rm -f devpod
) >> "$LOG" 2>&1 &
PID=$!
show_progress $PID "devpod"

# Verify install
if command -v devpod &>/dev/null; then
  echo -e "${OK} DevPod has been installed successfully!"
else
  echo -e "${ERROR} DevPod installation failed. Please check the log at $LOG"
fi

