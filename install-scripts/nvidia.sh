#!/bin/bash

nvidia_pkg=(
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  libva
  libva-nvidia-driver
)

############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

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
LOG="install-$(date +%d-%H%M%S)_nvidia.log"

set -e

# Function for installing packages with --allowerasing
install_package() {
  # Checking if package is already installed
  if sudo dnf list installed "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    sudo dnf install -y --allowerasing "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if sudo dnf list installed "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}


# Install Hprland Nvidia git
printf "${YELLOW} Installing Hyprland-git...\n"
  for NvHYPR in hyprland-git; do
    install_package "$NvHYPR" 2>&1 | tee -a "$LOG"
  done

# Install additional Nvidia packages
printf "${YELLOW} Installing Nvidia packages...\n"
  for NVIDIA in "${nvidia_pkg[@]}"; do
    install_package "$NVIDIA" 2>&1 | tee -a "$LOG"
  done


printf "${YELLOW} nvidia-stuff to /etc/default/grub..."

  # Additional options to add to GRUB_CMDLINE_LINUX
  additional_options="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"

  # Check if additional options are already present in GRUB_CMDLINE_LINUX
  if grep -q "GRUB_CMDLINE_LINUX.*$additional_options" /etc/default/grub; then
    echo "GRUB_CMDLINE_LINUX already contains the additional options"
  else
    # Append the additional options to GRUB_CMDLINE_LINUX
    sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$additional_options /" /etc/default/grub
    echo "Added the additional options to GRUB_CMDLINE_LINUX"
  fi

  # Update GRUB configuration
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg

  echo "Nvidia DRM modeset and additional options have been added to /etc/default/grub. Please reboot for changes to take effect."

clear
