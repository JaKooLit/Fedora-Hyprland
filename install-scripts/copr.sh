#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# COPR repo and tweaking of dnf #

# COPR Repos and packages needed from them
# solopasha/hyprland - most packages
# erikreider/SwayNotificationCenter swaync
# errornointernet/packages - wallust ONLY
# tofik/nwg-shell - nwg-look only

# List of COPR repositories to be added and enabled
COPR_REPOS=(
  solopasha/hyprland
  erikreider/SwayNotificationCenter
  errornointernet/packages
  tofik/nwg-shell 
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

# FEDORA COPRS need to only install a single package
# single packages to install are: wallust, nwg-look
# Define variables for the first COPR repo
yum_repo1="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:errornointernet:packages.repo"
line_to_add1="includepkgs=wallust"

# Define variables for the second COPR repo
yum_repo2="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:tofik:nwg-shell:packages.repo"
line_to_add2="includepkgs=nwg-look"

# Function to add a line to a repo file
add_line_to_repo() {
  local repo_file=$1
  local line_to_add=$2

  # Check if the file exists
  if [ ! -f "$repo_file" ]; then
    echo "File $repo_file does not exist." 2>&1 | tee -a "$LOG"
    return 2
  fi

  # Check if line_to_add already exists in the repo file
  if grep -q "^${line_to_add}$" "$repo_file"; then
    echo "Line '$line_to_add' already exists in $repo_file." 2>&1 | tee -a "$LOG"
  else
    echo "$line_to_add" | sudo tee -a "$repo_file" > /dev/null
    if [ $? -eq 0 ]; then
      echo "Line '$line_to_add' added to $repo_file." 2>&1 | tee -a "$LOG"
    else
      echo "Failed to add line '$line_to_add' to $repo_file." 2>&1 | tee -a "$LOG"
      return 3
    fi
  fi
}

# Update the first COPR repo
add_line_to_repo "$yum_repo1" "$line_to_add1"
# Update the second COPR repo
add_line_to_repo "$yum_repo2" "$line_to_add2"


# Update package cache and install packages from COPR Repos
sudo dnf update -y

clear
