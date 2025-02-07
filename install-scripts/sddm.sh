#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM #

sddm=(
	sddm
  qt6-qt5compat 
  qt6-qtdeclarative 
  qt6-qtsvg
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm.log"


# Installation of additional sddm stuff
printf "\n%s - Installing ${SKY_BLUE}SDDM and dependencies${RESET} .... \n" "${NOTE}"
for PKG2 in "${sddm[@]}"; do
  install_package "$PKG2" "$LOG"
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm3 gdm lxdm xdm lxdm-gtk3; do
  if sudo dnf list installed "$login_manager" > /dev/null; then
    echo "disabling $login_manager..."
    sudo systemctl disable "$login_manager.service" 2>&1 | tee -a "$LOG"
    echo "$login_manager disabled."
  fi
done

printf " Activating sddm service........\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$LOG"
sudo systemctl enable sddm.service 2>&1 | tee -a "$LOG"

wayland_sessions_dir=/usr/share/wayland-sessions
[ ! -d "$wayland_sessions_dir" ] && { printf "$CAT - $wayland_sessions_dir not found, creating...\n"; sudo mkdir -p "$wayland_sessions_dir" 2>&1 | tee -a "$LOG"; }
sudo cp assets/hyprland.desktop "$wayland_sessions_dir/" 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
