#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Global Functions for Scripts #

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

set -e

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if sudo dnf4 list installed "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    sudo dnf install -y "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if sudo dnf4 list installed "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

# Function for uninstalling packages
uninstall_package() {
  # Checking if package is installed
  if sudo dnf4 list installed "$1" &>> /dev/null ; then
    # Package is installed
    echo -e "${NOTE} Uninstalling $1 ..."
    sudo dnf remove -y "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is uninstalled
    if ! sudo dnf4 list installed "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was uninstalled."
    else
      # Something went wrong, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to uninstall. Please check the uninstall.log."
      exit 1
    fi
  fi
}
