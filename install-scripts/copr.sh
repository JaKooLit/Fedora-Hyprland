#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# COPR repo and tweaking of dnf #

# COPR Repos and packages needed from them
# solopasha/hyprland - most packages
# erikreider/SwayNotificationCenter swaync
# errornointernet/packages - wallust ONLY

# List of COPR repositories to be added and enabled
COPR_REPOS=(
  solopasha/hyprland
  erikreider/SwayNotificationCenter
  errornointernet/packages
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Source external functions
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_copr.log"

# Function to add dnf config if not present in a file
add_config_if_not_present() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" > /dev/null
}

# Check and add configuration settings to /etc/dnf/dnf.conf
add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=5"
add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirror=True"
add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True"

# enabling 3rd party repo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &&


# Enable COPR Repositories 
for repo in "${COPR_REPOS[@]}";do 
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG" || { printf "%s - Failed to enable necessary copr repos\n" "${ERROR}"; exit 1; }
done

# Add 'wallust' package to the specific COPR repo
yum_repo="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:errornointernet:packages.repo"
line_to_add="includepkgs=wallust"

# Check if the file exists
if [ ! -f "$yum_repo" ]; then
  echo "File $yum_repo does not exist." 2>&1 | tee -a "$LOG"
  exit 2
fi

# Check if includepkgs=wallust exists in yum repo
if grep -q "^${line_to_add}$" "$yum_repo"; then
  echo "Line '$line_to_add' already exists in $yum_repo." 2>&1 | tee -a "$LOG"
else
  echo "$line_to_add" | sudo tee -a "$yum_repo" > /dev/null
  if [ $? -eq 0 ]; then
    echo "Line '$line_to_add' added to $yum_repo." 2>&1 | tee -a "$LOG"
  else
    echo "Failed to add line '$line_to_add' to $yum_repo." 2>&1 | tee -a "$LOG"
    exit 3
  fi
fi

# Update package cache and install packages from COPR Repos
sudo dnf update -y

clear
