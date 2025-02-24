#!/bin/bash
# https://github.com/JaKooLit

clear

# Enhanced Color Definitions
BG_BLUE="$(tput setab 4)"
BG_GREEN="$(tput setab 2)"
BG_RED="$(tput setab 1)"
FG_WHITE="$(tput setaf 7)"
BOLD="$(tput bold)"
RESET="$(tput sgr0)"

# UI Elements
SEPARATOR="${BOLD}${FG_WHITE}=======================================================${RESET}"
HEADER_BANNER="${BG_BLUE}${FG_WHITE}${BOLD}"
SECTION_HEADER="${BOLD}${FG_WHITE}❯❯❯ "
PROMPT_ICON="${BOLD}${FG_WHITE}▸ "
STATUS_OK="${BOLD}${FG_WHITE}[${BG_GREEN}  OK  ${RESET}${BOLD}${FG_WHITE}]"
STATUS_ERROR="${BOLD}${FG_WHITE}[${BG_RED} ERROR ${RESET}${BOLD}${FG_WHITE}]"
STATUS_INFO="${BOLD}${FG_WHITE}[ INFO ]"
STATUS_WARN="${BOLD}${FG_WHITE}[${BG_RED} WARN ${RESET}${BOLD}${FG_WHITE}]"

# Animation Characters
SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Progress Indicators
show_spinner() {
    local pid=$!
    local delay=0.1
    while kill -0 $pid 2>/dev/null; do
        for c in "${SPINNER[@]}"; do
            echo -ne "${BOLD}${FG_WHITE}\r$c ${1}${RESET}"
            sleep $delay
        done
    done
    echo -ne "\r"
}

print_header() {
    clear
    echo "${HEADER_BANNER}"
    echo "  ███████╗███████╗██████╗  ██████╗ ██████╗  █████╗ "
    echo "  ██╔════╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔══██╗"
    echo "  █████╗  █████╗  ██████╔╝██║   ██║██████╔╝███████║"
    echo "  ██╔══╝  ██╔══╝  ██╔══██╗██║   ██║██╔══██╗██╔══██║"
    echo "  ██║     ███████╗██║  ██║╚██████╔╝██║  ██║██║  ██║"
    echo "  ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo "  ${BOLD}Kool's cool FEDORA hyprland install script.${RESET}"
    echo "${SEPARATOR}"
}

print_section() {
    echo "${SECTION_HEADER}${1}${RESET}"
    echo "${SEPARATOR}"
}

print_status() {
    case $1 in
        ok) echo "${STATUS_OK} ${2}" ;;
        error) echo "${STATUS_ERROR} ${2}" ;;
        info) echo "${STATUS_INFO} ${2}" ;;
        warn) echo "${STATUS_WARN} ${2}" ;;
    esac
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_header
    print_status error "This script should NOT be executed as root! Exiting..."
    exit 1
fi

# Initialization
print_header
echo "${SECTION_HEADER}Initializing System Checks${RESET}"
echo "${SEPARATOR}"

# Check for preset arguments
if [[ "$1" == "--preset" ]]; then
    print_status info "Preset configuration detected"
    source ./preset.sh &
    show_spinner "Loading preset configuration"
fi

# System Checks
check_pciutils() {
    if ! rpm -q pciutils > /dev/null; then
        print_status warn "pciutils not found - installing..."
        sudo dnf install -y pciutils > /dev/null &
        show_spinner "Installing pciutils"
    fi
}

check_log_directory() {
    if [ ! -d Install-Logs ]; then
        mkdir -p Install-Logs
        print_status ok "Created Install-Logs directory"
    fi
}

# Enhanced Question Interface
ask_question() {
    echo -n "${PROMPT_ICON}${1} ${BOLD}${FG_WHITE}[y/n]: ${RESET}"
    read -r response
    case $response in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        *) echo "Please answer with y or n"; ask_question "$1" ;;
    esac
}

# Installation Flow
installation_flow() {
    print_header
    print_section "Package Installation"
    
    # NVIDIA Check
    if lspci | grep -i "nvidia" &> /dev/null; then
        print_status info "NVIDIA GPU detected"
        if ask_question "Configure NVIDIA drivers?"; then
            nvidia="Y"
        fi
    fi

    # Main Installation Steps
    declare -a steps=(
        "GTK Themes:gtk_themes"
        "Bluetooth Support:bluetooth"
        "Thunar File Manager:thunar"
        "Desktop Overview:ags"
        "Login Manager:sddm"
        "Screen Sharing:xdph"
        "ZSH Shell:zsh"
        "ROG Laptop Support:rog"
        "Hyprland Dotfiles:dots"
    )

    for step in "${steps[@]}"; do
        local name=${step%:*}
        local var=${step#*:}
        
        if ask_question "Install ${name}?"; then
            eval "$var=Y"
            print_status ok "${name} selected"
        else
            print_status warn "${name} skipped"
        fi
        echo "${SEPARATOR}"
    done
}

# Execute installation
execute_installation() {
    print_header
    print_section "Starting Installation"
    
    # Create directory structure
    mkdir -p {Install-Logs,install-scripts} > /dev/null &
    show_spinner "Creating directory structure"

    # Make scripts executable
    chmod +x install-scripts/* > /dev/null &
    show_spinner "Setting up scripts"

    # Main installation
    declare -a install_scripts=(
        "copr.sh:Configuring COPR Repositories"
        "00-hypr-pkgs.sh:Installing Base Packages"
        "fonts.sh:Installing Fonts"
        "hyprland.sh:Setting Up Hyprland"
    )

    for script in "${install_scripts[@]}"; do
        local file=${script%:*}
        local desc=${script#*:}
        
        print_status info "${desc}"
        ./install-scripts/"${file}" > Install-Logs/"${file}.log" 2>&1 &
        show_spinner "${desc}"
    done
}

# Post-installation
final_steps() {
    print_header
    print_section "Finalizing Installation"
    
    # Final checks
    ./install-scripts/02-Final-Check.sh > Install-Logs/final-check.log 2>&1 &
    show_spinner "Verifying installation"

    # Completion message
    print_status ok "Installation Completed Successfully!"
    echo "${SEPARATOR}"
    echo "${BOLD}${FG_WHITE}Next steps:"
    echo "  - Reboot your system to apply changes"
    echo "  - Start Hyprland with 'Hyprland' command"
    echo "  - Visit GitHub repo for documentation"
    echo "${SEPARATOR}"
}

# Main Execution
check_pciutils
check_log_directory
installation_flow
execute_installation
final_steps

# Cleanup and Exit
rm -rf temp_files > /dev/null &
show_spinner "Cleaning temporary files"
print_status info "Script execution completed"
