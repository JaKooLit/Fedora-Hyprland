#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #

COPR_QUICK="errornointernet/quickshell"

quick=(
	quickshell
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_qshell.log"

# Enable quickshell COPR Repositories
printf "\n%s - Adding ${SKY_BLUE}Quickshell COPR repo${RESET} \n" "${NOTE}"

for repo in "$COPR_QUICK"; do
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG" || { printf "%s - Failed to enable quickshell copr repo\n" "${ERROR}"; exit 1; }
done

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}Quickshell for Desktop Overview${RESET} \n" "${NOTE}"

# Install quickshell
echo -e "\n${NOTE} - Installing ${SKY_BLUE}Quickshell for Desktop Overview${RESET}"
for pkg in "${quick[@]}"; do
    install_package "$pkg" "$LOG"
done

# removal of ags
# Check if the file exists and remove it
printf "\n%s - removing ${SKY_BLUE}AGS${RESET}  \n" "${NOTE}"
if [ -f "/usr/local/bin/ags" ]; then
    sudo rm -r /usr/local/bin/ags
fi

if [ -d "/usr/local/share/com.github.Aylur.ags" ]; then
    sudo rm -rf /usr/local/share/com.github.Aylur.ags
fi

printf "\n%.0s" {1..1}