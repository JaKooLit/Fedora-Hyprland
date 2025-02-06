#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Asus ROG Laptop stuff #

asusctl=(
  asusctl
  supergfxctl
  asusctl-rog-gui
  power-profiles-daemon
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_rog.log"

# Adding COPR for ASUS ROG
sudo dnf copr enable -y lukenukem/asus-linux
sudo dnf update


### Install software for Asus ROG laptops ###
printf " Installing ${SKY_BLUE}ASUS ROG packages${RESET}...\n"
  for ASUS in "${asusctl[@]}"; do
  install_package "$ASUS" "$LOG"
done

printf " Activating ROG services...\n"
sudo systemctl enable --now supergfxd 2>&1 | tee -a "$LOG"

printf " enabling power-profiles-daemon...\n"
sudo systemctl enable power-profiles-daemon 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
