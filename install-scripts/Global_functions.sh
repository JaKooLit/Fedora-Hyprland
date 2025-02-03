#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Global Functions for Scripts #

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Log file
LOG="Install-Logs/install.log"

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Function for installing packages
install_package() {
  local package="$1"

  # Checking if package is already installed
  if rpm -q "$package" &>/dev/null; then
    echo -e "${OK} $package is already installed. Skipping..." 2>&1 | tee -a "$LOG"
    return 0
  else
    # Package not installed
    echo -e "${NOTE} Installing $package ..."
    if sudo dnf install -y "$package" 2>&1 | tee -a "$LOG"; then
      # Making sure package is installed
      echo -e "\e[1A\e[K${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
      return 0
    else
      # Package installation did not succeed
      echo -e "\e[1A\e[K${ERROR} $package failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :(" 2>&1 | tee -a "$LOG"
      return 1
    fi
  fi
}

# Function for uninstalling packages
uninstall_package() {
  local package="$1"

  # Checking if package is installed
  if rpm -q "$package" &>/dev/null; then
    # Package is installed
    echo -e "${NOTE} Uninstalling $package ..."
    if sudo dnf remove -y "$package" 2>&1 | tee -a "$LOG"; then
      # Making sure package is uninstalled
      if ! rpm -q "$package" &>/dev/null; then
        echo -e "\e[1A\e[K${OK} $package was uninstalled."
        return 0
      else
        # Uninstallation did not succeed
        echo -e "\e[1A\e[K${ERROR} $package failed to uninstall. Please check the uninstall.log."
        return 1
      fi
    else
      # Uninstallation command itself failed
      echo -e "${ERROR} An error occurred while trying to uninstall $package. Please check the uninstall.log for details."
      return 1
    fi
  else
    echo -e "${WARN} $package is not installed. Skipping uninstallation." 2>&1 | tee -a "$LOG"
    return 0
  fi
}