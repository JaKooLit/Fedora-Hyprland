#!/bin/bash
# Install and configure Plymouth Spinner Theme

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change working directory to project root
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$SCRIPT_DIR/Global_functions.sh"; then
  echo "[ERROR] Failed to source Global_functions.sh"
  exit 1
fi

# Set log file
LOG="Install-Logs/install-$(date +%d-%H%M%S)_plymouth.log"

echo -e "${NOTE} Installing ${MAGENTA}Plymouth and Spinner Theme${RESET}..."

# Install required packages
install_package plymouth "$LOG"
install_package plymouth-theme-spinner "$LOG"

# Set default theme to spinner
echo -e "${NOTE} Setting ${YELLOW}spinner${RESET} as the default Plymouth theme..."
if sudo plymouth-set-default-theme -R spinner >> "$LOG" 2>&1; then
  echo -e "${OK} Plymouth theme set to ${YELLOW}spinner${RESET} and initramfs rebuilt."
else
  echo -e "${ERROR} Failed to set Plymouth theme. Check ${LOG} for details."
fi

echo -e "${OK} Plymouth spinner setup complete!"

