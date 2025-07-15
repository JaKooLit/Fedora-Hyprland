#!/bin/bash
# HyprFedora packages

# packages neeeded
hyprfedora-package=(
  nfs-utils
  gnome-software
  libreoffice
  chromium
)

copr_packages=(
  ghostty
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hyprfedora-pkgs.log"

if [ $overall_failed -ne 0 ]; then
  echo -e "${ERROR} Some packages failed to uninstall. Please check the log."
fi

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}HyprFedora necessary packages${RESET} .... \n" "${NOTE}"

for PKG1 in "${hyprfedora-package[@]}" "${copr_packages[@]}"; do
  install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}
