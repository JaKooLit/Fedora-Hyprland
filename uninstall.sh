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

# Function to print centered text
print_centered() {
    local text="$1"
    local color="$2"
    local width=$(tput cols)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%b%*s%s%*s%b\n" "$color" $padding "" "$text" $padding "" "$CLEAR"
}

# Function to safely remove packages
safe_remove() {
    for package in "$@"; do
        if rpm -q "$package" &> /dev/null; then
            sudo dnf remove -y "$package"
        else
            print_color $YELLOW "Package $package is not installed, skipping."
        fi
    done
}

# Function to safely remove COPR repositories
safe_remove_copr() {
    for repo in "$@"; do
        if sudo dnf copr list | grep -q "$repo"; then
            sudo dnf copr remove -y "$repo"
        else
            print_color $YELLOW "COPR repository $repo is not enabled, skipping."
        fi
    done
}

# Function to safely remove directories and files
safe_remove_item() {
    local item="$1"
    if [ -e "$item" ]; then
        rm -rf "$item"
        print_color $GREEN "Removed: $item"
    else
        print_color $YELLOW "Item $item does not exist, skipping."
    fi
}

# Function to ask user before removing an item
ask_before_remove() {
    local item="$1"
    read -p "Do you want to remove $item? (y/n): " choice
    case "$choice" in 
        y|Y ) safe_remove_item "$item";;
        n|N ) print_color $YELLOW "Keeping $item";;
        * ) print_color $YELLOW "Invalid input. Keeping $item";;
    esac
}

# Print banner
print_color $MAGENTA "UNINSTALL HYPRLAND"

print_centered "Made with ♥ by vdcds" $CYAN

# Warning message
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
safe_remove hyprland hyprcursor waybar kvantum polkit-gnome swappy SwayNotificationCenter wlogout kitty rofi-wayland aylurs-gtk-shell cliphist hypridle hyprlock pamixer pyprland swww

# Remove COPR repositories
print_color $YELLOW "Removing COPR repositories..."
safe_remove_copr solopasha/hyprland erikreider/SwayNotificationCenter

# Remove additional components
print_color $YELLOW "Removing additional components..."
safe_remove blueman thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman sddm xdg-desktop-portal-hyprland

# Ask before removing zsh and related packages
ask_before_remove zsh
ask_before_remove util-linux-user
ask_before_remove pokemon-colorscripts-git

# Remove ROG-related packages
safe_remove asusctl supergfxctl

# Remove fonts
print_color $YELLOW "Removing fonts..."
safe_remove 'jetbrains-mono-fonts*' 'fira-code-fonts*'

# Remove configuration files
print_color $YELLOW "Removing configuration files..."
config_items=(
    ~/.config/ags
    ~/.config/hypr
    ~/.config/waybar
    ~/.config/wofi
    ~/.config/dunst
    ~/.config/swappy
    ~/.config/wlogout
    ~/.config/kitty
    ~/.config/rofi
    ~/.config/gtk-3.0
    ~/.config/gtk-4.0
    ~/.config/xdg-desktop-portal-hyprland
    ~/.config/btop
    ~/.config/cava
    ~/.config/Thunar
    ~/.config/xfce4
    ~/.config/wallust
    ~/.zshrc
    ~/.p10k.zsh
    /etc/environment.d/hyprland.conf
)

for item in "${config_items[@]}"; do
    ask_before_remove "$item"
done

# Ask about wallpaper collection
ask_before_remove ~/Pictures/wallpapers

# Remove Fedora-Hyprland directory
ask_before_remove ~/Fedora-Hyprland

# Remove nwg-look (installed from source)
print_color $YELLOW "Removing nwg-look..."
if [ -d ~/nwg-look ]; then
    cd ~/nwg-look
    if [ -f Makefile ]; then
        sudo make uninstall
    fi
    cd ~
    safe_remove_item ~/nwg-look
    
    # Remove binary if it exists
    if [ -f /usr/local/bin/nwg-look ]; then
        sudo rm /usr/local/bin/nwg-look
    fi
    
    print_color $GREEN "Removed nwg-look."
else
    print_color $YELLOW "nwg-look directory not found, skipping."
fi

# Ask before removing Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    ask_before_remove ~/.oh-my-zsh
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

THANK YOU FOR USING THIS AMAZING HYPRLAND CONFIG IN FIRST PLACE!  


"

print_centered "Made by vdcds" $CYAN