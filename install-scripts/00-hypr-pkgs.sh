#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Hyprland-Dots Packages #
# edit your packages desired here. 
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in fedora repo or add copr repo

# add packages wanted here
Extra=(

)

# packages neeeded
hypr_package=( 
  curl
  gawk
  git
  grim
  gvfs
  gvfs-mtp
  hyprpolkitagent
  ImageMagick
  inxi
  jq
  kitty
  kvantum
  nano
  network-manager-applet
  openssl
  pamixer
  pavucontrol
  pipewire-alsa
  pipewire-utils
  playerctl
  python3-requests
  python3-pip
  python3-pyquery
  qt5ct
  qt6ct
  qt6-qtsvg
  rofi-wayland
  slurp
  swappy
  waybar
  wget2
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils
  yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  brightnessctl
  btop
  cava
  eog
  fastfetch
  gnome-system-monitor
  mousepad
  mpv
  mpv-mpris
  nvtop
  qalculate-gtk
  vim-enhanced
)

copr_packages=(
  #aylurs-gtk-shell
  cliphist
  nwg-look
  SwayNotificationCenter
  pamixer
  swww
  wallust  
)

# List of packages to uninstall as it conflicts some packages
uninstall=(
  aylurs-gtk-shell
  dunst
  mako
  rofi
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"


# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

# Uninstalling conflicting packages
printf "\n%s - Removing Mako, Dunst and rofi as they conflict with swaync and rofi-wayland \n" "${NOTE}"

# Variable to track overall success
overall_success=true
for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG"
  if [ $? -ne 0 ]; then
    echo -e "${ERROR} - $PKG uninstallation failed. Check the uninstall log." 2>&1 | tee -a "$LOG"
    overall_success=false
  fi
done

# Handle the overall success or failure
if [ "$overall_success" = false ]; then
  echo -e "${ERROR} Some packages failed to uninstall. Please check the uninstall log."
else
  echo -e "${OK} All packages were uninstalled successfully."
fi


# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${copr_packages[@]}" "${Extra[@]}"; do
  install_package "$PKG1"
  if [ $? -ne 0 ]; then
    echo -e "${ERROR} - $PKG1 Installation failed. Check the install log." 2>&1 | tee -a "$LOG"
  fi
done

clear
