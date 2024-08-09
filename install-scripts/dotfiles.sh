#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Hyprland-Dots to download from Releases #

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Check if Hyprland-Dots exists
printf "${NOTE} Downloading Hyprland dots from main for the Hyprland v0.42.0 update...\n"

if [ -d Hyprland-Dots ]; then
  cd Hyprland-Dots
  git stash
  git pull
  git stash apply
  chmod +x copy.sh
  ./copy.sh 2>&1 | tee -a "$LOG"
else
  if git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots; then
    cd Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 2>&1 | tee -a "$LOG"
  else
    echo -e "${ERROR} Can't download Hyprland-Dots" 2>&1 | tee -a "$LOG"
  fi
fi

clear
