#!/bin/bash

#tweak dnf
# Function to add config if not present in a file
add_config_if_not_present() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" > /dev/null
}

# Check and add configuration settings to /etc/dnf/dnf.conf
add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=5"
add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirror=True"
add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True"


# COPR Repos and packages needed from them
# solopasha/hyprland - most packages
# en4aew/desktop-tools cliphist
# notahat/pamixer pamixer
# trs-sod/swaylock-effects swaylock-effects
#  alebastr/sway-extras swww

# enabling 3rd party repo

sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &&

# List of COPR repositories to be added and enabled
COPR_REPOS=(
solopasha/hyprland
en4aew/desktop-tools
notahat/pamixer
trs-sod/swaylock-effects
alebastr/sway-extras  
)

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_copr.log"


# Enable COPR Repositories 

for repo in "${COPR_REPOS[@]}";do 
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG" || { printf "%s - Failed to enable necessary copr repos\n" "${ERROR}"; exit 1; }
done

# Update package cache and install packages from COPR Repos
sudo dnf update -y

clear
