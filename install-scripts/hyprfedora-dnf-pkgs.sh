#!/bin/bash
# HyprFedora packages

# packages neeeded
hyprfedora_package=(
  nfs-utils
  gnome-software
  libreoffice
  chromium
  brave-browser
  cups
  hplip
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hyprfedora-dnf-pkgs.log"

printf "\n%.0s" {1..1}

# Ensure dnf-plugins-core is installed 
if ! rpm -q dnf-plugins-core &>/dev/null; then
  echo "Installing required package: dnf-plugins-core"
  install_package dnf-plugins-core "$LOG" || {
    echo "Failed to install dnf-plugins-core. Cannot proceed with repo configuration."
    exit 1
  }
fi

# Check and add Brave browser repo if missing
brave_repo="/etc/yum.repos.d/brave-browser.repo"

if [[ -f "$brave_repo" ]]; then
  echo "Brave repo already exists: $brave_repo"
else
  echo "Brave repo not found. Adding..."
  sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
    && echo "Brave repo added successfully." \
    || echo "Failed to add Brave repo."
fi

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}HyprFedora necessary packages${RESET} .... \n" "${NOTE}"

for PKG1 in "${hyprfedora_package[@]}" "${copr_packages[@]}"; do
  install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}
