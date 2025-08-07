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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fonts.log"


# Installation of main components
printf "\n%s - Installing necessary ${SKY_BLUE}fonts${RESET}.... \n" "${NOTE}"

for PKG1 in "${fonts[@]}"; do
  install_package "$PKG1" "$LOG"
done

printf "\n%.0s" {1..2}

# jetbrains nerd font. Necessary for waybar
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
    echo "Download ${YELLOW}DOWNLOAD_URL${RESET} attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
    sleep 2
done

# Check if the JetBrainsMono directory exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"
# Extract the new files into the JetBrainsMono directory and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"

# clean up 
if [ -d "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz 2>&1 | tee -a "$LOG"
fi

# Set $wget to wget2 if it exists, otherwise use wget
if [ -x /usr/bin/wget2 ]; then
  wget="/usr/bin/wget2"
elif [ -x /usr/bin/wget ]; then
  wget="/usr/bin/wget"
else
  echo "[ERROR] Neither wget2 nor wget found in /usr/bin."
  exit 1
fi

# Fantasque Mono Nerd Font
if $wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FantasqueSansMono.zip; then
    mkdir -p "$HOME/.local/share/fonts/FantasqueSansMonoNerd" && unzip -o -q "FantasqueSansMono.zip" -d "$HOME/.local/share/fonts/FantasqueSansMono" && echo "FantasqueSansMono installed successfully" | tee -a "$LOG"
else
    echo -e "\n${ERROR} Failed to download ${YELLOW}Fantasque Sans Mono Nerd Font${RESET} Please check your connection\n" | tee -a "$LOG"
fi

# Victor Mono-Font
if $wget -q https://rubjo.github.io/victor-mono/VictorMonoAll.zip; then
    mkdir -p "$HOME/.local/share/fonts/VictorMono" && unzip -o -q "VictorMonoAll.zip" -d "$HOME/.local/share/fonts/VictorMono" && echo "Victor Font installed successfully" | tee -a "$LOG"
else
    echo -e "\n${ERROR} Failed to download ${YELLOW}Victor Mono Font${RESET} Please check your connection\n" | tee -a "$LOG"
fi

# Iosevka Nerd Font
if $wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip; then
    mkdir -p "$HOME/.local/share/fonts/Iosevka" && unzip -o -q "Iosevka.zip" -d "$HOME/.local/share/fonts/Iosevka" && echo "Iosevka Font installed successfully" | tee -a "$LOG"
else
    echo -e "\n${ERROR} Failed to download ${YELLOW}Iosevka Mono Font${RESET} Please check your connection\n" | tee -a "$LOG"
fi


# Update font cache and log the output
fc-cache -v 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
