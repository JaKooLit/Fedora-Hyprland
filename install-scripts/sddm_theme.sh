#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM themes #

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm_theme.log"
    
# SDDM-themes
printf "${INFO} Installing ${SKY_BLUE}Additional SDDM Theme${RESET}\n"

# Check if /usr/share/sddm/themes/sequoia_2 exists and remove if it does
if [ -d "/usr/share/sddm/themes/sequoia_2" ]; then
  sudo rm -rf "/usr/share/sddm/themes/sequoia_2"
  echo -e "\e[1A\e[K${OK} - Removed existing 'sequoia_2' directory." 2>&1 | tee -a "$LOG"
fi

# Check if sequoia_2 directory exists in the current directory and remove if it does
if [ -d "sequoia_2" ]; then
  rm -rf "sequoia_2"
  echo -e "\e[1A\e[K${OK} - Removed existing 'sequoia_2' directory from the current location." 2>&1 | tee -a "$LOG"
fi

if git clone --depth 1 https://codeberg.org/JaKooLit/sddm-sequoia sequoia_2; then
  # Wait for the clone to complete and 'sequoia_2' directory to be created
  if [ ! -d "sequoia_2" ]; then
    echo "${ERROR} Failed to clone the repository." | tee -a "$LOG"
  fi

  # Create themes directory if it doesn't exist
  if [ ! -d "/usr/share/sddm/themes" ]; then
    sudo mkdir -p /usr/share/sddm/themes
    echo "${OK} - Directory '/usr/share/sddm/themes' created." | tee -a "$LOG"
  fi

  # Move cloned theme to the themes directory
  sudo mv sequoia_2 /usr/share/sddm/themes/sequoia_2 2>&1 | tee -a "$LOG"

  # Configure theme settings
  echo -e "[Theme]\nCurrent=sequoia_2" | sudo tee "$sddm_conf_dir/theme.conf.user" >> "$LOG"

  # Replace current background from assets
  sudo cp -r assets/sddm.png /usr/share/sddm/themes/sequoia_2/backgrounds/default 2>&1 | tee -a "$LOG"
  sudo sed -i 's|^wallpaper=".*"|wallpaper="backgrounds/default"|' /usr/share/sddm/themes/sequoia_2/theme.conf 2>&1 | tee -a "$LOG"

  # Output success message
  echo "${OK} - ${MAGENTA}Additional SDDM Theme${RESET} successfully installed." | tee -a "$LOG"

else
  # Handle failure in cloning the repository
  echo "${ERROR} - Failed to clone the sddm theme repository. Please check your internet connection." | tee -a "$LOG" >&2
fi


printf "\n%.0s" {1..2}