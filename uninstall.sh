#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
CLEAR='\033[0m'

# Function to print colorful text
print_color() {
    printf "%b%s%b\n" "$1" "$2" "$CLEAR"
}

# Function to print right-aligned text
print_right_aligned() {
    local text="$1"
    local color="$2"
    local width=$(tput cols)
    printf "%b%*s%b\n" "$color" $width "$text" "$CLEAR"
}

# Function to safely remove packages
safe_remove() {
    for package in "$@"; do
        if rpm -q "$package" &> /dev/null; then
            sudo dnf remove -y "$package"
        else
            echo "Package $package is not installed, skipping."
        fi
    done
}

# Function to safely remove COPR repositories
safe_remove_copr() {
    for repo in "$@"; do
        if sudo dnf copr list | grep -q "$repo"; then
            sudo dnf copr remove -y "$repo"
        else
            echo "COPR repository $repo is not enabled, skipping."
        fi
    done
}

# Function to safely remove directories
safe_remove_dir() {
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            echo "Removed directory: $dir"
        else
            echo "Directory $dir does not exist, skipping."
        fi
    done
}

# Function to ask user before removing a package
ask_before_remove() {
    read -p "Do you want to remove $1? (y/n): " choice
    case "$choice" in 
        y|Y ) safe_remove "$1";;
        n|N ) echo "Skipping removal of $1";;
        * ) echo "Invalid input. Skipping removal of $1";;
    esac
}


print_color $MAGENTA "
 _   _                  _                 _   _   _         _           _        _ _
| | | |_   _ _ __  _ __| | __ _ _ __   __| | | | | |_ __  (_)_ __  ___| |_ __ _| | | ___ _ __
| |_| | | | | '_ \| '__| |/ _\` | '_ \ / _\` | | | | | '_ \ | | '_ \/ __| __/ _\` | | |/ _ \ '__|
|  _  | |_| | |_) | |  | | (_| | | | | (_| | | |_| | | | || | | | \__ \ || (_| | | |  __/ |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|  \___/|_| |_|/ |_| |_|___/\__\__,_|_|_|\___|_|
       |___/|_|                                         |__/
"

# Signature
print_right_aligned "Made by vdcds" $CYAN


# Enhanced Warning message
print_color $RED "
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█                                                      █
█               ╔═╗╔╦╗╔═╗╔═╗  ┬                        █
█               ╚═╗ ║ ║ ║╠═╝  │                        █
█               ╚═╝ ╩ ╚═╝╩    o                        █
█                                                      █
█               ╔═╗╔╗╔╔╦╗  ╦═╗╔═╗╔═╗╔╦╗                █
█               ╠═╣║║║ ║║  ╠╦╝║╣ ╠═╣ ║║                █
█               ╩ ╩╝╚╝═╩╝  ╩╚═╚═╝╩ ╩═╩╝                █
█                                                      █
█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

                  !!! IMPORTANT WARNING !!!

This script will UNINSTALL Hyprland and related components.

  • All Hyprland configurations will be DELETED
  • Related packages will be REMOVED
  • This action is IRREVERSIBLE

BEFORE PROCEEDING:
  1. Ensure you have a BACKUP of any important configurations
  2. Close all running applications
  3. Be prepared for potential system changes

If you're unsure about any aspect of this process, 
please STOP now and seek additional information.
"

# Confirmation to proceed
print_color $YELLOW "Are you ABSOLUTELY SURE you want to proceed with the uninstallation?"
read -p "Type 'yes' to continue or any other key to cancel: " confirm
if [[ $confirm != "yes" ]]; then
    print_color $GREEN "Uninstallation cancelled. No changes were made to your system."
    exit 1
fi

# Main uninstallation process
print_color $BLUE "Starting Hyprland uninstallation process..."

# Uninstall Hyprland and related packages
print_color $YELLOW "Removing Hyprland and related packages..."
safe_remove hyprland waybar wofi dunst polkit-gnome swappy swaylock-effects wlogout

# Ask before removing Kitty terminal
ask_before_remove kitty

# Remove COPR repositories
print_color $YELLOW "Removing COPR repositories..."
safe_remove_copr solopasha/hyprland alebastr/sway-extras

# Remove GTK themes, Bluetooth, Thunar, SDDM, XDG-desktop-portal-hyprland
print_color $YELLOW "Removing additional components..."
safe_remove adw-gtk3-theme blueman thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman sddm xdg-desktop-portal-hyprland

# Ask before removing zsh and related packages
ask_before_remove zsh
ask_before_remove util-linux-user
ask_before_remove pokemon-colorscripts-git

# Remove nwg-look and ROG-related packages
safe_remove nwg-look asusctl supergfxctl

# Remove fonts
print_color $YELLOW "Removing fonts..."
safe_remove 'jetbrains-mono-fonts*' 'fira-code-fonts*'

# Remove configuration files and wallpapers
print_color $YELLOW "Removing configuration files and wallpapers..."
safe_remove_dir ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/dunst ~/.config/swappy ~/.config/wlogout ~/Pictures/wallpapers ~/Fedora-Hyprland

# Ask before removing Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    read -p "Do you want to remove Oh My Zsh? (y/n): " choice
    case "$choice" in 
        y|Y ) rm -rf ~/.oh-my-zsh; print_color $GREEN "Removed Oh My Zsh.";;
        n|N ) print_color $YELLOW "Keeping Oh My Zsh.";;
        * ) print_color $YELLOW "Invalid input. Keeping Oh My Zsh.";;
    esac
fi

# Clean up any leftover dependencies
print_color $YELLOW "Cleaning up leftover dependencies..."
sudo dnf autoremove -y

print_color $GREEN "Hyprland and related components have been uninstalled."
print_color $YELLOW "It's recommended to reboot your system now."
print_color $CYAN "To reset to the default Fedora desktop environment, run:"
print_color $CYAN "sudo dnf group install @workstation-product-environment"

# Final ASCII Art
print_color $MAGENTA "
 _____ _                 _     __   __          _
|_   _| |__   __ _ _ __ | | __ \ \ / /__  _   _| |
  | | | '_ \ / _\` | '_ \| |/ /  \ V / _ \| | | | |
  | | | | | | (_| | | | |   <    | | (_) | |_| |_|
  |_| |_| |_|\__,_|_| |_|_|\_\   |_|\___/ \__,_(_)
"

# Signature at the end
print_right_aligned "Made by vdcds" $CYAN