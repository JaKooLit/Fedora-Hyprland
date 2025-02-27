#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Nvidia Packages and other nvidia stuff #

nvidia_pkg=(
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  libva
  libva-nvidia-driver
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


# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_nvidia.log"


# Install additional Nvidia packages
printf "${YELLOW} Installing ${SKY_BLUE}Nvidia Packages${RESET}...\n"
  for NVIDIA in "${nvidia_pkg[@]}"; do
  install_package "$NVIDIA"
done

printf "${INFO} adding nvidia options to ${YELLOW}/etc/default/grub${RESET} ..."

# Additional options to add to GRUB_CMDLINE_LINUX
additional_options="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1 nvidia_drm.fbdev=1"

# Check if additional options are already present in GRUB_CMDLINE_LINUX
if grep -q "GRUB_CMDLINE_LINUX.*$additional_options" /etc/default/grub; then
	echo "GRUB_CMDLINE_LINUX already contains the additional options" 2>&1 | tee -a "$LOG"
else
	# Append the additional options to GRUB_CMDLINE_LINUX
	sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$additional_options /" /etc/default/grub
    echo "Added the additional options to GRUB_CMDLINE_LINUX" 2>&1 | tee -a "$LOG"
fi

# Update GRUB configuration
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "${NOTE} Nvidia DRM modeset and additional options have been added to /etc/default/grub. Please reboot for changes to take effect." 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
