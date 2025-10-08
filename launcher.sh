#!/bin/bash
# Fedora-Hyprland Script Launcher
# Interactive menu for running installation scripts

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$PWD/install-scripts"

# Banner
clear
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                                                          ║${NC}"
echo -e "${PURPLE}║        ${CYAN}KooL's Fedora-Hyprland Script Launcher${PURPLE}         ║${NC}"
echo -e "${PURPLE}║                                                          ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "install-scripts" ]; then
    echo -e "${RED}Error: install-scripts directory not found!${NC}"
    echo -e "${YELLOW}Please run this script from the Fedora-Hyprland root directory.${NC}"
    exit 1
fi

# Function to display menu
show_menu() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Main Installation Scripts:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo " 1)  Run Full Install (./install.sh)"
    echo " 2)  Run Preset Install (./preset.sh)"
    echo ""
    echo -e "${GREEN}Core Components:${NC}"
    echo " 3)  Hyprland Packages (00-hypr-pkgs.sh)"
    echo " 4)  COPR Repositories (copr.sh)"
    echo " 5)  Nvidia Drivers (nvidia.sh)"
    echo " 6)  SDDM Login Manager (sddm.sh)"
    echo ""
    echo -e "${GREEN}Themes & Appearance:${NC}"
    echo " 7)  GTK Themes (gtk-themes.sh)"
    echo " 8)  Fonts Installation (fonts.sh)"
    echo " 9)  Cursor Themes (cursor.sh)"
    echo ""
    echo -e "${GREEN}Shells & Terminal:${NC}"
    echo " 10) ZSH & Oh-My-ZSH (zsh.sh)"
    echo " 11) Nerd Fonts (nerd-fonts.sh)"
    echo ""
    echo -e "${GREEN}System Monitors (Optional):${NC}"
    echo " 12) Battery Monitor (battery-monitor.sh)"
    echo " 13) Disk Monitor (disk-monitor.sh)"
    echo " 14) Temperature Monitor (temp-monitor.sh)"
    echo ""
    echo -e "${GREEN}Additional Tools:${NC}"
    echo " 15) QuickShell (quickshell.sh)"
    echo " 16) Flatpak Apps (flatpak.sh)"
    echo " 17) Thunar File Manager (thunar.sh)"
    echo " 18) XDG Portals (xdg.sh)"
    echo ""
    echo -e "${RED}Maintenance:${NC}"
    echo " 19) Uninstall Script (../uninstall.sh)"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo " 0)  Exit"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to run script
run_script() {
    local script=$1
    echo ""
    echo -e "${YELLOW}Running: ${script}${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    
    if [ -f "$script" ]; then
        chmod +x "$script"
        bash "$script"
        local exit_code=$?
        echo ""
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}✓ Script completed successfully!${NC}"
        else
            echo -e "${RED}✗ Script exited with code: $exit_code${NC}"
        fi
    else
        echo -e "${RED}Error: Script not found: $script${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║        ${CYAN}KooL's Fedora-Hyprland Script Launcher${PURPLE}         ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    show_menu
    
    read -p "Enter your choice [0-19]: " choice
    
    case $choice in
        1)
            run_script "./install.sh"
            ;;
        2)
            run_script "./preset.sh"
            ;;
        3)
            run_script "./install-scripts/00-hypr-pkgs.sh"
            ;;
        4)
            run_script "./install-scripts/copr.sh"
            ;;
        5)
            run_script "./install-scripts/nvidia.sh"
            ;;
        6)
            run_script "./install-scripts/sddm.sh"
            ;;
        7)
            run_script "./install-scripts/gtk-themes.sh"
            ;;
        8)
            run_script "./install-scripts/fonts.sh"
            ;;
        9)
            run_script "./install-scripts/cursor.sh"
            ;;
        10)
            run_script "./install-scripts/zsh.sh"
            ;;
        11)
            run_script "./install-scripts/nerd-fonts.sh"
            ;;
        12)
            run_script "./install-scripts/battery-monitor.sh"
            ;;
        13)
            run_script "./install-scripts/disk-monitor.sh"
            ;;
        14)
            run_script "./install-scripts/temp-monitor.sh"
            ;;
        15)
            run_script "./install-scripts/quickshell.sh"
            ;;
        16)
            run_script "./install-scripts/flatpak.sh"
            ;;
        17)
            run_script "./install-scripts/thunar.sh"
            ;;
        18)
            run_script "./install-scripts/xdg.sh"
            ;;
        19)
            echo ""
            echo -e "${RED}⚠️  WARNING: This will run the uninstall script!${NC}"
            read -p "Are you sure? (yes/no): " confirm
            if [ "$confirm" = "yes" ]; then
                run_script "./uninstall.sh"
            fi
            ;;
        0)
            echo ""
            echo -e "${GREEN}Thanks for using KooL's Fedora-Hyprland Launcher!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac
done
