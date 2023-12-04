#!/bin/bash

# https://github.com/JaKooLit

# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in fedora repo

# add packages wanted here
Extra=(

)

# packages neeeded
hypr_package=( 
  curl
  dunst
  git
  grim
  gvfs
  gvfs-mtp
  ImageMagick
  jq
  kitty
  kvantum
  nano
  network-manager-applet
  openssl
  pavucontrol
  pipewire-alsa
  playerctl
  polkit-gnome
  python3-requests
  python3-pip
  qt5ct
  qt6-qtsvg
  rofi-wayland
  slurp
  swappy
  swayidle
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  brightnessctl
  btop
  cava
  eog
  gnome-system-monitor
  mousepad
  mpv
  nvtop
  vim-enhanced
  wlsunset
)

copr_packages=(
  cliphist
  pamixer
  swaylock-effects
  swww
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
LOG="install-$(date +%d-%H%M%S)_hypr-pkgs.log"

set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if sudo dnf list installed "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    sudo dnf install -y "$1" 2>&1 | tee -a "$LOG"
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

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${copr_packages[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the install.log"
    exit 1
  fi
done

## Installing pywal colors
printf "\n%s - Installing Pywal.... \n" "${NOTE}"

sudo pip3 install pywal 2>&1 | tee -a "$LOG"

clear
