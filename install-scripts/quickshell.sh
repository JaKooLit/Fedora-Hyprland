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

# shellcheck source=./Global_functions.sh disable=SC1091
if ! source "$(dirname "$(readlink -f "$0")")\Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_qshell.log"

# Function to get Fedora version
get_fedora_version() {
    if [ -f /etc/fedora-release ]; then
        grep -oP '\d+' /etc/fedora-release | head -1
    else
        echo "unknown"
    fi
}

# Get Fedora version for logging
FEDORA_VERSION=$(get_fedora_version)
printf "\n%s - Detecting system: ${SKY_BLUE}Fedora ${FEDORA_VERSION}${RESET} \n" "${NOTE}"
echo "${INFO} Fedora version detected: ${FEDORA_VERSION}" | tee -a "$LOG"

# Enable quickshell COPR Repositories
printf "\n%s - Adding ${SKY_BLUE}Quickshell COPR repo${RESET} \n" "${NOTE}"

for repo in $COPR_QUICK; do
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG" || { printf "%s - Failed to enable quickshell copr repo\n" "${ERROR}"; exit 1; }
done

printf "\n%.0s" {1..1}

# Installation of main components
printf "\n%s - Installing ${SKY_BLUE}Quickshell for Desktop Overview${RESET} \n" "${NOTE}"

# Check if quickshell is available in the COPR repo
printf "\n%s - Checking ${SKY_BLUE}Quickshell availability${RESET} in COPR... \n" "${NOTE}"
if ! sudo dnf list --available "quickshell" 2>&1 | grep -q "quickshell"; then
    printf "\n%s - ${YELLOW}Quickshell not found${RESET} in COPR for Fedora ${FEDORA_VERSION}\n" "${WARN}"
    printf "\n%s - This is ${YELLOW}known to occur${RESET} on Fedora Rawhide when the package hasn't been rebuilt\n" "${NOTE}"
    printf "\n%s - ${SKY_BLUE}Fallback option available${RESET}: AGS (Aylur's GTK Shell) will be used instead\n" "${INFO}"
    printf "\n%s - The ${SKY_BLUE}Hyprland-Dots OverviewToggle.sh${RESET} script will automatically detect and use AGS\n" "${INFO}"
    printf "\n%s - You can install Quickshell manually later if it becomes available for your Fedora version\n" "${NOTE}"
    echo "${WARN} Quickshell unavailable for Fedora ${FEDORA_VERSION}. AGS fallback will be used." | tee -a "$LOG"
    printf "\n%.0s" {1..1}
else
    # Install quickshell
    echo -e "\n${NOTE} - Installing ${SKY_BLUE}Quickshell for Desktop Overview${RESET}"
    for pkg in "${quick[@]}"; do
        install_package "$pkg" "$LOG"
    done
    
    # Verify installation
    if rpm -q quickshell &>/dev/null; then
        echo -e "\n${OK} ${SKY_BLUE}Quickshell${RESET} installed successfully for Fedora ${FEDORA_VERSION}"
        echo "${OK} Quickshell successfully installed." | tee -a "$LOG"
    else
        printf "\n%s - ${YELLOW}Quickshell installation failed${RESET} unexpectedly\n" "${WARN}"
        printf "\n%s - ${SKY_BLUE}Fallback option available${RESET}: AGS (Aylur's GTK Shell) will be used instead\n" "${INFO}"
        printf "\n%s - The ${SKY_BLUE}Hyprland-Dots OverviewToggle.sh${RESET} script will automatically detect and use AGS\n" "${INFO}"
        echo "${WARN} Quickshell installation failed. AGS fallback will be used." | tee -a "$LOG"
    fi
fi

# NOTE: AGS is no longer removed to allow both AGS and Quickshell to coexist
# The Hyprland-Dots OverviewToggle.sh script handles fallback between them

printf "\n%.0s" {1..1}
