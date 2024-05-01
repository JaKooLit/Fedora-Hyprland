#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# FONTS #

fonts=(
adobe-source-code-pro-fonts
fira-code-fonts
fontawesome-fonts-all
google-droid-sans-fonts
google-noto-sans-cjk-fonts
google-noto-color-emoji-fonts
google-noto-emoji-fonts
jetbrains-mono-fonts
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fonts.log"

# Installation of main components
printf "\n%s - Installing necessary fonts.... \n" "${NOTE}"

for PKG1 in "${fonts[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

# jetbrains nerd font. Necessary for waybar
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
    echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"

# Update font cache and log the output
fc-cache -v 2>&1 | tee -a "$LOG"

# clean up 
if [ -d "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz 2>&1 | tee -a "$LOG"
fi

clear