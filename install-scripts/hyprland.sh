#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Main Hyprland Package #

hypr=(
  aquamarine
  hyprland
  hyprland-qtutils
  hyprcursor
  hypridle
  hyprlock
  pyprland
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"


# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hyprland.log"

# Hyprland
printf "${NOTE} Installing ${SKY_BLUE}Hyprland packages${RESET} .......\n"
for HYPR in "${hypr[@]}"; do
  install_package "$HYPR" "$LOG"
  [ $? -ne 0 ] && {
    exit 1
  }
done

printf "\n%.0s" {1..2}
