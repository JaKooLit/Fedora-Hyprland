#!/bin/bash
# https://github.com/JaKooLit

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

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

clear

printf "\n%.0s" {1..3}                            
echo "   |  _.   |/  _   _  |  o _|_ "
echo " \_| (_| o |\ (_) (_) |_ |  |_ "
printf "\n%.0s" {1..2}

# Welcome message
echo "${SKY_BLUE}Welcome to JaKooLit's Fedora-Hyprland Install Script!${RESET}"
echo
echo "${WARNING}ATTENTION: Run a full system update and Reboot first!! (Highly Recommended) ${RESET}"
echo
echo "${YELLOW}NOTE: You will be required to answer some questions during the installation! ${RESET}"
echo
echo "${YELLOW}NOTE: If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start! ${RESET}"
echo

read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

printf "\n%.0s" {1..2}

if [ "$proceed" != "y" ]; then
    echo "${INFO} Installation aborted. No changes done! Goodbye!"
    printf "\n%.0s" {1..2}
    exit 1
fi

printf "\n%.0s" {1..2}

# install pciutils if detected not installed. Necessary for detecting GPU
if ! rpm -q pciutils > /dev/null; then
    echo "pciutils is not installed. Installing..."
    sudo dnf install -y pciutils
fi

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

#echo "${WARN} ${WARNING}ATTENTION: Choosing Y on use preset question will install also ${MAGENTA}nvidia packages!!!${RESET}"
#echo "${YELLOW}CTRL C or Q to cancel and edit the file ${MAGENTA}preset.sh${RESET} ${RESET}"  
#echo "If you are not sure what to do, answer N in here"
#read -p "${SKY_BLUE}Would you like to Use ${YELLOW}Preset Install Settings?${RESET} (See note above)? (y/n): ${RESET}" use_preset

# Use of Preset Settings
#if [[ $use_preset = [Yy] ]]; then
#  source ./preset.sh
#fi

printf "\n%.0s" {1..2}

# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
    while true; do
        read -p "$(colorize_prompt "$CAT"  "$1 (y/n): ")" choice
        case "$choice" in
            [Yy]* ) eval "$2='Y'"; return 0;;
            [Nn]* ) eval "$2='N'"; return 1;;
            * ) echo "Please answer with y or n.";;
        esac
    done
}

# Function to ask a custom question with specific options and set the response in a variable
ask_custom_option() {
    local prompt="$1"
    local valid_options="$2"
    local response_var="$3"

    while true; do
        read -p "$(colorize_prompt "$CAT"  "$prompt ($valid_options): ")" choice
        if [[ " $valid_options " == *" $choice "* ]]; then
            eval "$response_var='$choice'"
            return 0
        else
            echo "Please choose one of the provided options: $valid_options"
        fi
    done
}
# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}


# Collect user responses to all questions
printf "\n"
# Check if nvidia is present
if lspci | grep -i "nvidia" &> /dev/null; then
    ask_yes_no "-${YELLOW}NVIDIA${RESET} GPU is detected. Do you want script to configure it?" nvidia
fi
printf "\n"
ask_yes_no "-Install ${YELLOW}GTK themes${RESET} (required for Dark/Light function)?" gtk_themes
printf "\n"
ask_yes_no "-Do you want to configure ${YELLOW}Bluetooth${RESET}?" bluetooth
printf "\n"
ask_yes_no "-Do you want to install ${YELLOW}Thunar file manager${RESET}?" thunar
printf "\n"
ask_yes_no "-Install ${YELLOW}AGS (aylur's GTK shell) v1${RESET} for Desktop-Like Overview?" ags
printf "\n"
ask_yes_no "-Install & configure ${YELLOW}SDDM${RESET} login manager, plus (OPTIONAL) SDDM theme?" sddm
printf "\n"
ask_yes_no "-Install ${YELLOW}XDG-DESKTOP-PORTAL-HYPRLAND${RESET}? (For proper Screen Share, e.g., OBS)" xdph
printf "\n"
ask_yes_no "-Install ${YELLOW}zsh${RESET}, ${YELLOW}oh-my-zsh${RESET} & (Optional) ${YELLOW}pokemon-colorscripts${RESET}?" zsh
printf "\n"
ask_yes_no "-Installing on ${YELLOW}Asus ROG laptops${RESET}?" rog
printf "\n"
ask_yes_no "-Do you want to download pre-configured ${YELLOW}KooL Hyprland dotfiles${RESET}?" dots
printf "\n"

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*
sleep 1
# Install hyprland packages
execute_script "copr.sh"
execute_script "00-hypr-pkgs.sh"
execute_script "fonts.sh"
execute_script "hyprland.sh"

if [ "$nvidia" == "Y" ]; then
    execute_script "nvidia.sh"
fi

if [ "$gtk_themes" == "Y" ]; then
    execute_script "gtk_themes.sh"
fi

if [ "$bluetooth" == "Y" ]; then
    execute_script "bluetooth.sh"
fi

if [ "$thunar" == "Y" ]; then
    execute_script "thunar.sh"
fi

if [ "$ags" == "Y" ]; then
    execute_script "ags.sh"
fi

if [ "$sddm" == "Y" ]; then
    execute_script "sddm.sh"
fi

if [ "$xdph" == "Y" ]; then
    execute_script "xdph.sh"
fi

if [ "$zsh" == "Y" ]; then
    execute_script "zsh.sh"
fi

if [ "$rog" == "Y" ]; then
    execute_script "rog.sh"
fi

execute_script "InputGroup.sh"

if [ "$dots" == "Y" ]; then
    execute_script "dotfiles-main.sh"

fi

clear

# copy fastfetch config if fedora is not present
if [ ! -f "$HOME/.config/fastfetch/fedora.png" ]; then
    cp -r assets/fastfetch "$HOME/.config/"
fi


# final check essential packages if it is installed
execute_script "02-Final-Check.sh"

printf "\n%.0s" {1..1}

# Check if hyprland or hyprland-git is installed
if rpm -q hyprland &> /dev/null || rpm -q hyprland-git &> /dev/null; then
    printf "\n${OK} Hyprland is installed. However, some essential packages may not be installed. Please see above!"
    printf "\n${CAT} Ignore this message if it states ${YELLOW}All essential packages${RESET} are installed as per above\n"
    sleep 2
    printf "\n${NOTE} You can start Hyprland by typing ${MAGENTA}Hyprland${RESET} (IF SDDM is not installed) (note the capital H!).\n"
    printf "\n${NOTE} However, it is ${YELLOW}highly recommended to reboot${RESET} your system.\n\n"

    # Prompt user to reboot
    read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

    # Normalize user input to lowercase
    HYP=$(echo "$HYP" | tr '[:upper:]' '[:lower:]')

    if [[ "$HYP" == "y" || "$HYP" == "yes" ]]; then
        echo "${INFO} Rebooting now..."
        reboot # Optionally reboot if the user agrees
    elif [[ "$HYP" == "n" || "$HYP" == "no" ]]; then
        echo "${INFO} You can reboot later at any time."
    else
        echo "${WARN} Invalid response. Please answer with 'y' or 'n'. Exiting."
        exit 1
    fi

    # Check if NVIDIA GPU is present
    if lspci | grep -i "nvidia" &> /dev/null; then
        echo "${INFO} ${YELLOW}NVIDIA GPU${RESET} detected. Reminder that you must REBOOT your SYSTEM..."
    else
        echo -e "\n${CAT} Thanks for using ${MAGENTA}KooL's Hyprland Dots${RESET}. Enjoy and Have a good day!"
        exit 0
    fi
else
    # Print error message if neither package is installed
    printf "\n${WARN} Hyprland failed to install. Please check 00_CHECK-time_installed.log and other files in the Install-Logs/ directory...\n\n"
    exit 1
fi
