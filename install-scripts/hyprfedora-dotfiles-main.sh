#!/bin/bash

clear
dotfiles_repo="https://github.com/francisco-cardenas/HyprFedora-dots.git"
dotfiles_dir="$HOME/.dotfiles"
hypr_config="$dotfiles_dir/hypr/.config/hypr"
wallpaper=$HOME/.config/hypr/wallpaper_effects/.wallpaper_current
waybar_style="$HOME/.config/waybar/style/[Retro] Simple Style.css"
waybar_config="$HOME/.config/waybar/configs/HyprFedora"

# Set colors for output messages
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
    echo "${ERROR}  This script should ${WARNING}NOT${RESET} be executed as root!! Exiting......."
    printf "\n%.0s" {1..2} 
    exit 1
fi

# Function to print colorful text
print_color() {
    printf "%b%s%b\n" "$1" "$2" "$CLEAR"
}

# Check /etc/os-release to see if this is an Ubuntu or Debian based distro
if grep -iq '^\(ID_LIKE\|ID\)=.*\(debian\|ubuntu\)' /etc/os-release >/dev/null 2>&1; then
	printf "\n%.0s" {1..1}
    print_color $WARNING "
    █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
                 DOTS version INCOMPATIBLE
    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

    Debian / Ubuntu detected. Refer to https://github.com/JaKooLit/Hyprland-Dots
    exiting ....
    "
  printf "\n%.0s" {1..3}
  exit 1
fi


printf "\n%.0s" {1..1}  
echo -e "\e[35m
    HyprFedora-dots based on
    ╦╔═┌─┐┌─┐╦    ╔╦╗┌─┐┌┬┐┌─┐
    ╠╩╗│ ││ │║     ║║│ │ │ └─┐ 2025
    ╩ ╩└─┘└─┘╩═╝  ═╩╝└─┘ ┴ └─┘
\e[0m"
printf "\n%.0s" {1..1}  

# Create Directory for Copy Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Function to print colorful text
print_color() {
    printf "%b%s%b\n" "$1" "$2" "$CLEAR"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="$PARENT_DIR/Install-Logs/install-$(date +%d-%H%M%S)_dotfiles.log"

# Installation of GNU Stow
printf "\n%s - Installing ${SKY_BLUE}HyprFedora necessary packages${RESET} .... \n" "${NOTE}"
install_package stow "$LOG"

printf "\n%s - ${RESET} Installing ${SKY_BLUE}Cloning repo${RESET} .... \n" "${NOTE}"
if [ ! -d "$dotfiles_dir" ]; then
    git clone "$dotfiles_repo" "$dotfiles_dir"
else
    echo "Dotfiles directory already exists: $dotfiles_dir"
fi

# Change the working directory to the dotfiles directory
cd "$dotfiles_dir" || { echo "${ERROR} Failed to change directory to $dotfiles_dir"; exit 1; }

printf "\n%.0s" {1..1}

# update home directories
xdg-user-dirs-update 2>&1 | tee -a "$LOG" || true

# setting up for nvidia
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  echo "${INFO} Nvidia GPU detected. Setting up proper env's and configs" 2>&1 | tee -a "$LOG" || true
  sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' "$hypr_config/UserConfigs/ENVariables.conf"
  sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#//' "$hypr_config/UserConfigs/ENVariables.conf"
  sed -i '/env = NVD_BACKEND,direct/s/^#//' "$hypr_config/UserConfigs/ENVariables.conf"
  # no hardware cursors if nvidia detected 
  sed -i 's/^\([[:space:]]*no_hardware_cursors[[:space:]]*=[[:space:]]*\)2/\1 1/' "$hypr_config/UserConfigs/UserSettings.conf" 
  #sed -i 's/^\([[:space:]]*explicit_sync[[:space:]]*=[[:space:]]*\)2/\1 0/' "$hypr_config/UserConfigs/UserSettings.conf"
fi

# uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "${INFO} System is running in a virtual machine. Setting up proper env's and configs" 2>&1 | tee -a "$LOG" || true
  sed -i 's/^\([[:space:]]*no_hardware_cursors[[:space:]]*=[[:space:]]*\)2/\1 1/' "$hypr_config/UserConfigs/UserSettings.conf"
  # enabling proper ENV's for Virtual Environment which should help
  sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' "$hypr_config/UserConfigs/ENVariables.conf"
  #sed -i '/env = LIBGL_ALWAYS_SOFTWARE,1/s/^#//' "$hypr_config/UserConfigs/ENVariables.conf"
  sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' "$hypr_config/monitors.conf"
fi

# activating hyprcursor on env by checking if the directory ~/.icons/Bibata-Modern-Ice/hyprcursors exists
if [ -d "$HOME/.icons/Bibata-Modern-Ice/hyprcursors" ]; then
    HYPRCURSOR_ENV_FILE="$hypr_config/UserConfigs/ENVariables.conf"
    echo "${INFO} Bibata-Hyprcursor directory detected. Activating Hyprcursor...." 2>&1 | tee -a "$LOG" || true
    sed -i 's/^#env = HYPRCURSOR_THEME,Bibata-Modern-Ice/env = HYPRCURSOR_THEME,Bibata-Modern-Ice/' "$HYPRCURSOR_ENV_FILE"
    sed -i 's/^#env = HYPRCURSOR_SIZE,24/env = HYPRCURSOR_SIZE,24/' "$HYPRCURSOR_ENV_FILE"
fi

printf "\n%.0s" {1..1} 

# Function to detect keyboard layout using localectl or setxkbmap
detect_layout() {
  if command -v localectl >/dev/null 2>&1; then
    layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
    if [ -n "$layout" ]; then
      echo "$layout"
    fi
  elif command -v setxkbmap >/dev/null 2>&1; then
    layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    if [ -n "$layout" ]; then
      echo "$layout"
    fi
  fi
}

# Detect the current keyboard layout
layout=$(detect_layout)

if [ "$layout" = "(unset)" ]; then
  while true; do
    printf "\n%.0s" {1..1}
    print_color $WARNING "
    █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
            STOP AND READ
    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

    !!! IMPORTANT WARNING !!!

The Default Keyboard Layout could not be detected
You need to set it Manually

    !!! WARNING !!!

Setting a wrong Keyboard Layout will cause Hyprland to crash
If you are not sure, just type ${YELLOW}us${RESET}
${SKYBLUE}You can change later in ~/.config/hypr/UserConfigs/UserSettings.conf${RESET}

${MAGENTA} NOTE:${RESET}
•  You can also set more than 2 keyboard layouts
•  For example: ${YELLOW}us, kr, gb, ru${RESET}
"
    printf "\n%.0s" {1..1}
    
    echo -n "${CAT} - Please enter the correct keyboard layout: "
    read new_layout

    if [ -n "$new_layout" ]; then
        layout="$new_layout"
        break
    else
        echo "${CAT} Please enter a keyboard layout."
    fi
  done
fi

printf "${NOTE} Detecting keyboard layout to prepare proper Hyprland Settings\n"

# Prompt the user to confirm whether the detected layout is correct
while true; do
  printf "${INFO} Current keyboard layout is ${MAGENTA}$layout${RESET}\n"
  echo -n "${CAT} Is this correct? [y/n] "
  read keyboard_layout

  case $keyboard_layout in
    [yY])
        awk -v layout="$layout" '/kb_layout/ {$0 = "  kb_layout = " layout} 1' "$hypr_config/UserConfigs/UserSettings.conf" > temp.conf
        mv temp.conf "$hypr_config/UserConfigs/UserSettings.conf"
        
        echo "${NOTE} kb_layout ${MAGENTA}$layout${RESET} configured in settings." 2>&1 | tee -a "$LOG"
        break ;;
    [nN])
        printf "\n%.0s" {1..2}
        print_color $WARNING "
    █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
            STOP AND READ
    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

    !!! IMPORTANT WARNING !!!

The Default Keyboard Layout could not be detected
You need to set it Manually

    !!! WARNING !!!

Setting a wrong Keyboard Layout will cause Hyprland to crash
If you are not sure, just type ${YELLOW}us${RESET}
${SKYBLUE}You can change later in ~/.config/hypr/UserConfigs/UserSettings.conf${RESET}

${MAGENTA} NOTE:${RESET}
•  You can also set more than 2 keyboard layouts
•  For example: ${YELLOW}us, kr, gb, ru${RESET}
"
        printf "\n%.0s" {1..1}
        
        echo -n "${CAT} - Please enter the correct keyboard layout: "
        read new_layout

        awk -v new_layout="$new_layout" '/kb_layout/ {$0 = "  kb_layout = " new_layout} 1' "$hypr_config/UserConfigs/UserSettings.conf" > temp.conf
        mv temp.conf "$hypr_config/UserConfigs/UserSettings.conf"
        echo "${OK} kb_layout $new_layout configured in settings." 2>&1 | tee -a "$LOG" 
        break ;;
    *)
        echo "${ERROR} Please enter either 'y' or 'n'." ;;
  esac
done

# Check if asusctl is installed and add rog-control-center on Startup
if command -v asusctl >/dev/null 2>&1; then
    sed -i '/^\s*#exec-once = rog-control-center/s/^#//' "$hypr_config/UserConfigs/Startup_Apps.conf"
fi

printf "\n%.0s" {1..1}

# Checking if neovim or vim is installed and offer user if they want to make as default editor
# Function to modify the ENVariables.conf file
update_editor() {
    local editor=$1
    sed -i "s/#env = EDITOR,.*/env = EDITOR,$editor #default editor/" "$hypr_config/UserConfigs/01-UserDefaults.conf"
    echo "${OK} Default editor set to ${MAGENTA}$editor${RESET}." 2>&1 | tee -a "$LOG"
}

EDITOR_SET=0
# Check for neovim if installed
if command -v nvim &> /dev/null; then
    printf "${INFO} ${MAGENTA}neovim${RESET} is detected as installed\n"
    echo -n "${CAT} Do you want to make ${MAGENTA}neovim${RESET} the default editor? (y/N): "
    read EDITOR_CHOICE
    if [[ "$EDITOR_CHOICE" == "y" || "$EDITOR_CHOICE" == "Y" ]]; then
        update_editor "nvim"
        EDITOR_SET=1
    fi
fi

printf "\n"

# Check for vim if installed, but only if neovim wasn't chosen
if [[ "$EDITOR_SET" -eq 0 ]] && command -v vim &> /dev/null; then
    printf "${INFO} ${MAGENTA}vim${RESET} is detected as installed\n"
    echo -n "${CAT} Do you want to make ${MAGENTA}vim${RESET} the default editor? (y/N): "
    read EDITOR_CHOICE
    if [[ "$EDITOR_CHOICE" == "y" || "$EDITOR_CHOICE" == "Y" ]]; then
        update_editor "vim"
        EDITOR_SET=1
    fi
fi

printf "\n"

# Ask whether to change to 12hr format
while true; do
    echo -e "${NOTE} ${SKY_BLUE} By default, KooL's Dots are configured in 24H clock format."
    echo -n "$CAT Do you want to change to 12H (AM/PM) clock format? (y/n): "
    read answer

    # Convert the answer to lowercase for comparison
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    # Check if the answer is valid
    if [[ "$answer" == "y" ]]; then
        # Modify waybar clock modules if 12hr is selected    
        # Clock 1
        sed -i 's#^\(\s*\)//\("format": " {:%I:%M %p}",\) #\1\2 #g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        sed -i 's#^\(\s*\)\("format": " {:%H:%M:%S}",\) #\1//\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        
        # Clock 2
        sed -i 's#^\(\s*\)\("format": "  {:%H:%M}",\) #\1//\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        
        # Clock 3
        sed -i 's#^\(\s*\)//\("format": "{:%I:%M %p - %d/%b}",\) #\1\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        sed -i 's#^\(\s*\)\("format": "{:%H:%M - %d/%b}",\) #\1//\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        
        # Clock 4
        sed -i 's#^\(\s*\)//\("format": "{:%B | %a %d, %Y | %I:%M %p}",\) #\1\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        sed -i 's#^\(\s*\)\("format": "{:%B | %a %d, %Y | %H:%M}",\) #\1//\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"

        # Clock 5
        sed -i 's#^\(\s*\)//\("format": "{:%A, %I:%M %P}",\) #\1\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        sed -i 's#^\(\s*\)\("format": "{:%a %d | %H:%M}",\) #\1//\2#g' config/waybar/Modules 2>&1 | tee -a "$LOG"
        
        # for hyprlock
        sed -i 's/^\s*text = cmd\[update:1000\] echo "\$(date +"%H")"/# &/' "$hypr_config/hyprlock.conf" 2>&1 | tee -a "$LOG"
        sed -i 's/^\(\s*\)# *text = cmd\[update:1000\] echo "\$(date +"%I")" #AM\/PM/\1    text = cmd\[update:1000\] echo "\$(date +"%I")" #AM\/PM/' "$hypr_config/hyprlock.conf" 2>&1 | tee -a "$LOG"

        sed -i 's/^\s*text = cmd\[update:1000\] echo "\$(date +"%S")"/# &/' "$hypr_config/hyprlock.conf" 2>&1 | tee -a "$LOG"
        sed -i 's/^\(\s*\)# *text = cmd\[update:1000\] echo "\$(date +"%S %p")" #AM\/PM/\1    text = cmd\[update:1000\] echo "\$(date +"%S %p")" #AM\/PM/' "$hypr_config/hyprlock.conf" 2>&1 | tee -a "$LOG"
        
        echo "${OK} 12H format set on waybar clocks succesfully." 2>&1 | tee -a "$LOG"

      # Function to apply 12H format to SDDM themes
      apply_sddm_12h_format() {
      local sddm_directory=$1

      # Check if the directory exists
      if [ -d "$sddm_directory" ]; then
        echo "Editing ${SKY_BLUE}$sddm_directory${RESET} to 12H format" 2>&1 | tee -a "$LOG"

        sudo sed -i 's|^## HourFormat="hh:mm AP"|HourFormat="hh:mm AP"|' "$sddm_directory/theme.conf" 2>&1 | tee -a "$LOG" || true
        sudo sed -i 's|^HourFormat="HH:mm"|## HourFormat="HH:mm"|' "$sddm_directory/theme.conf" 2>&1 | tee -a "$LOG" || true
      fi
      }

      # Applying to different SDDM themes
      apply_sddm_12h_format "/usr/share/sddm/themes/simple-sddm"
      apply_sddm_12h_format "/usr/share/sddm/themes/simple-sddm-2"

      # For SDDM (sequoia_2)
      sddm_directory_3="/usr/share/sddm/themes/sequoia_2"
      if [ -d "$sddm_directory_3" ]; then
        echo "${YELLOW}sddm sequoia_2${RESET} theme exists. Editing to 12H format" 2>&1 | tee -a "$LOG"

        # Comment out the existing clockFormat="HH:mm" line
        sudo sed -i 's|^clockFormat="HH:mm"|## clockFormat="HH:mm"|' "$sddm_directory_3/theme.conf" 2>&1 | tee -a "$LOG" || true

        # Insert the new clockFormat="hh:mm AP" line if it's not already present
        if ! grep -q 'clockFormat="hh:mm AP"' "$sddm_directory_3/theme.conf"; then
          sudo sed -i '/^clockFormat=/a clockFormat="hh:mm AP"' "$sddm_directory_3/theme.conf" 2>&1 | tee -a "$LOG" || true
        fi

        echo "${OK} 12H format set to SDDM successfully." 2>&1 | tee -a "$LOG"
      fi

    break
     
    elif [[ "$answer" == "n" ]]; then
        echo "${NOTE} You chose not to change to 12H format." 2>&1 | tee -a "$LOG"
        break  # Exit the loop if the user chooses "n"
    else
        echo "${ERROR} Invalid choice. Please enter y for yes or n for no."
    fi
done
printf "\n%.0s" {1..1}

set -e

# Function to create a unique backup directory name with month, day, hours, and minutes
get_backup_dirname() {
  local timestamp
  timestamp=$(date +"%m%d_%H%M")
  echo "back-up_${timestamp}"
}

# Function to backup a config
backup_config() {
  local CONFIG="$1"
  local CONFIG_PATH="$2"

  echo -e "\n${NOTE} - Config for ${YELLOW}$CONFIG${RESET} found, attempting to back up."
  BACKUP_DIR=$(get_backup_dirname)

  # Backup the existing file or directory
  mv "$CONFIG_PATH" "$CONFIG_PATH-$BACKUP_DIR" 2>&1 | tee -a "$LOG"
  if [ $? -eq 0 ]; then
    echo -e "${NOTE} - Backed up $CONFIG to $CONFIG_PATH-$BACKUP_DIR."
  else
    echo "${ERROR} - Failed to back up $CONFIG."
    exit 1
  fi
}

# Function to stow configs
stow_config() {
    local target="$1"
    if command stow -v "$target" 2>&1 | tee -a "$LOG"; then
        echo "${OK} Stowed $target successfully." | tee -a "$LOG"
    else
        echo "${ERROR} Failed to stow $target." | tee -a "$LOG"
    fi
}

printf "${INFO} - Copying dotfiles. ${SKY_BLUE}Existing configs will be backed up!${RESET}\n"
# Configs to set
CONFIGS="ags fastfetch kitty ghostty rofi swaync waybar btop cava hypr Kvantum qt5ct qt6ct swappy wallust wlogout zsh"

for CONFIG in $CONFIGS; do
  # Backup the existing directory if it exists
  CONFIG_PATH="$HOME/.config/$CONFIG"

  if [ -d "$CONFIG_PATH" ]; then
    backup_config "$CONFIG" "$CONFIG_PATH"
  
    # Set the new config
    stow_config $CONFIG
  elif [ "$CONFIG" = "zsh" ] && [ -f "$HOME/.zshrc" ]; then
    # Special handling for .zshrc
    backup_config "$CONFIG" "$HOME/.zshrc"

    # Set the new config
    stow_config $CONFIG
  else
    # Set the new config without a config to backup
    stow_config $CONFIG
  fi
done

printf "\n%.0s" {1..1}

# Restore automatically Animations and Monitor-Profiles
# including monitors.conf and workspaces.conf
HYPR_DIR="$HOME/.config/hypr"
BACKUP_DIR=$(get_backup_dirname)
BACKUP_HYPR_PATH="$HYPR_DIR-backup-$BACKUP_DIR"

if [ -d "$BACKUP_HYPR_PATH" ]; then
  echo -e "\n${NOTE} Restoring ${SKY_BLUE}Animations & Monitor Profiles${RESET} directories into ${YELLOW}$HYPR_DIR${RESET}..."
  
  DIR_B=("Monitor_Profiles" "animations" "wallpaper_effects")
  # Restore directories automatically 
  for DIR_RESTORE in "${DIR_B[@]}"; do
    BACKUP_SUBDIR="$BACKUP_HYPR_PATH/$DIR_RESTORE"
    
    if [ -d "$BACKUP_SUBDIR" ]; then
      cp -r "$BACKUP_SUBDIR" "$HYPR_DIR/" 
      echo "${OK} - Restored directory: ${MAGENTA}$DIR_RESTORE${RESET}" 2>&1 | tee -a "$LOG"
    fi
  done

  # Restore files automatically
  FILE_B=("monitors.conf" "workspaces.conf")
  for FILE_RESTORE in "${FILE_B[@]}"; do
    BACKUP_FILE="$BACKUP_HYPR_PATH/$FILE_RESTORE"

    if [ -f "$BACKUP_FILE" ]; then
      cp "$BACKUP_FILE" "$HYPR_DIR/$FILE_RESTORE" 
      echo "${OK} - Restored file: ${MAGENTA}$FILE_RESTORE${RESET}" 2>&1 | tee -a "$LOG"
    fi
  done
fi

printf "\n%.0s" {1..1}

# Restoring UserConfigs and UserScripts
DIRH="hypr"
FILES_TO_RESTORE=(
  "01-UserDefaults.conf"
  "ENVariables.conf"
  "LaptopDisplay.conf"
  "Laptops.conf"
  "Startup_Apps.conf"
  "UserDecorations.conf"
  "UserAnimations.conf"
  "UserKeybinds.conf"
  "UserSettings.conf"
  "WindowRules.conf"
)

DIRPATH="$HOME/.config/$DIRH"
BACKUP_DIR=$(get_backup_dirname)
BACKUP_DIR_PATH="$DIRPATH-backup-$BACKUP_DIR/UserConfigs"

if [ -z "$BACKUP_DIR" ]; then
  echo "${ERROR} - Backup directory name is empty. Exiting."
  exit 1
fi

if [ -d "$BACKUP_DIR_PATH" ]; then
	echo -e "${NOTE} Restoring previous ${MAGENTA}User-Configs${RESET}... "
    print_color $WARNING "
    █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
            NOTES for RESTORING PREVIOUS CONFIGS
    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

    If you decide to restore your old configs, make sure to
    handle the updates or changes manually !!!
    "
	echo -e "${MAGENTA}Kindly Visit and check KooL's Hyprland-Dots GitHub page for the history of commits.${RESET}"


  for FILE_NAME in "${FILES_TO_RESTORE[@]}"; do
    BACKUP_FILE="$BACKUP_DIR_PATH/$FILE_NAME"
    if [ -f "$BACKUP_FILE" ]; then
      printf "\n${INFO} Found ${YELLOW}$FILE_NAME${RESET} in hypr backup...\n"
      echo -n "${CAT} Do you want to restore ${YELLOW}$FILE_NAME${RESET} from backup? (y/N): "
      read file_restore

      if [[ "$file_restore" == [Yy]* ]]; then
        if cp "$BACKUP_FILE" "$DIRPATH/UserConfigs/$FILE_NAME"; then
          echo "${OK} - $FILE_NAME restored!" 2>&1 | tee -a "$LOG"
        else
          echo "${ERROR} - Failed to restore $FILE_NAME!" 2>&1 | tee -a "$LOG"
        fi
      else
        echo "${NOTE} - Skipped restoring $FILE_NAME." 2>&1 | tee -a "$LOG"
      fi
    fi
  done
fi

printf "\n%.0s" {1..1}

# Restoring previous UserScripts
DIRSH="hypr"
SCRIPTS_TO_RESTORE=(
  "RofiBeats.sh"
  "Weather.py"
  "Weather.sh"
)

DIRSHPATH="$HOME/.config/$DIRSH"
BACKUP_DIR_PATH_S="$DIRSHPATH-backup-$BACKUP_DIR/UserScripts"

if [ -d "$BACKUP_DIR_PATH_S" ]; then
  echo -e "${NOTE} Restoring previous ${MAGENTA}User-Scripts${RESET}..."

  for SCRIPT_NAME in "${SCRIPTS_TO_RESTORE[@]}"; do
    BACKUP_SCRIPT="$BACKUP_DIR_PATH_S/$SCRIPT_NAME"

    if [ -f "$BACKUP_SCRIPT" ]; then
      printf "\n${INFO} Found ${YELLOW}$SCRIPT_NAME${RESET} in hypr backup...\n"
      echo -n "${CAT} Do you want to restore ${YELLOW}$SCRIPT_NAME${RESET} from backup? (y/N): "
      read script_restore
      
      if [[ "$script_restore" == [Yy]* ]]; then
        if cp "$BACKUP_SCRIPT" "$DIRSHPATH/UserScripts/$SCRIPT_NAME"; then
          echo "${OK} - $SCRIPT_NAME restored!" 2>&1 | tee -a "$LOG"
        else
          echo "${ERROR} - Failed to restore $SCRIPT_NAME!" 2>&1 | tee -a "$LOG"
        fi
      else
        echo "${NOTE} - Skipped restoring $SCRIPT_NAME." 2>&1 | tee -a "$LOG"
      fi
    fi
  done
fi

printf "\n%.0s" {1..1}

# restoring some files in ~/.config/hypr
DIR_H="hypr"
FILES_2_RESTORE=(
  "hyprlock.conf"
  "hypridle.conf"
)

DIRPATH="$HOME/.config/$DIR_H"
BACKUP_DIR=$(get_backup_dirname)
BACKUP_DIR_PATH_F="$DIRPATH-backup-$BACKUP_DIR"

if [ -d "$BACKUP_DIR_PATH_F" ]; then
  echo -e "${NOTE} Restoring some files in ${MAGENTA}$HOME/.config/hypr directory${RESET}..."

  for FILE_RESTORE in "${FILES_2_RESTORE[@]}"; do
    BACKUP_FILE="$BACKUP_DIR_PATH_F/$FILE_RESTORE"
  
    if [ -f "$BACKUP_FILE" ]; then
      echo -e "\n${INFO} Found ${YELLOW}$FILE_RESTORE${RESET} in hypr backup..."
      echo -n "${CAT} Do you want to restore ${YELLOW}$FILE_RESTORE${RESET} from backup? (y/N): "
      read file2restore

      if [[ "$file2restore" == [Yy]* ]]; then
        if cp "$BACKUP_FILE" "$DIRPATH/$FILE_RESTORE"; then
          echo "${OK} - $FILE_RESTORE restored!" 2>&1 | tee -a "$LOG"
        else
          echo "${ERROR} - Failed to restore $FILE_RESTORE!" 2>&1 | tee -a "$LOG"
        fi
      else
        echo "${NOTE} - Skipped restoring $FILE_RESTORE." 2>&1 | tee -a "$LOG"
      fi
    else
      echo "${ERROR} - Backup file $BACKUP_FILE does not exist."
    fi
  done
fi

printf "\n%.0s" {1..1}

# Define the target directory for rofi themes
rofi_DIR="$HOME/.local/share/rofi/themes"

if [ ! -d "$rofi_DIR" ]; then
  mkdir -p "$rofi_DIR"
fi
if [ -d "$HOME/.config/rofi/themes" ]; then
  if [ -z "$(ls -A $HOME/.config/rofi/themes)" ]; then
    echo '/* Dummy Rofi theme */' > "$HOME/.config/rofi/themes/dummy.rasi"
  fi
  ln -snf "$HOME/.config/rofi/themes/"* "$HOME/.local/share/rofi/themes/"
  # Delete the dummy file if it was created
  if [ -f "$HOME/.config/rofi/themes/dummy.rasi" ]; then
    rm "$HOME/.config/rofi/themes/dummy.rasi"
  fi
fi

printf "\n%.0s" {1..1}

# wallpaper stuff
mkdir -p $HOME/Pictures/wallpapers
source_wallpaper="default-wallpaper/Pictures/wallpapers/HyprFedora-default.jpg"

if stow -v default-wallpaper; then
  cp  "$source_wallpaper" "$wallpaper"
  echo "${OK} ${MAGENTA}default wallpaper ${RESET} set successfully!" | tee -a "$LOG"
else
  echo "${ERROR} Failed to set ${YELLOW}default wallpaper ${RESET}" | tee -a "$LOG"
fi
 
# Set some files as executable
chmod +x "$HOME/.config/hypr/scripts/"* 2>&1 | tee -a "$LOG"
chmod +x "$HOME/.config/hypr/UserScripts/"* 2>&1 | tee -a "$LOG"
# Set executable for initial-boot.sh
chmod +x "$HOME/.config/hypr/initial-boot.sh" 2>&1 | tee -a "$LOG"

# Check if ~/.config/waybar/config does not exist or is a symlink
if [ ! -e "$HOME/.config/waybar/config" ] || [ -L "$HOME/.config/waybar/config" ]; then
    ln -sf "$waybar_config" "$HOME/.config/waybar/config" 2>&1 | tee -a "$LOG"
fi

# SDDM Background
sddm_sequioa="/usr/share/sddm/themes/sequoia_2"
sddm_simple2="/usr/share/sddm/themes/simple_sddm_2"
if [ -d "$sddm_simple2" ]; then
  sudo cp "$source_wallpaper" "$sddm_simple2/Backgrounds/default" || true
  echo "${NOTE} Current wallpaper applied as default SDDM background" 2>&1 | tee -a "$LOG"
elif [ -d "$sddm_sequioa" ]; then
  sudo cp "$source_wallpaper" "$sddm_sequioa/backgrounds/default" || true
  echo "${NOTE} Current wallpaper applied as default SDDM background" 2>&1 | tee -a "$LOG"
fi

# additional wallpapers
printf "\n%.0s" {1..1}
echo "${MAGENTA}By default only a single wallpaper is copied${RESET}..."

while true; do
  echo -n "${CAT} Would you like to download additional wallpapers? ${WARN} This is 1GB in size (y/n): "
  read WALL
  
  case $WALL in
    [Yy])
      echo "${NOTE} Downloading additional wallpapers..."
      if git clone "https://gitlab.com/dwt1/wallpapers.git"; then
          echo "${OK} Wallpapers downloaded successfully." 2>&1 | tee -a "$LOG"

          # Check if wallpapers directory exists and create it if not
          if [ ! -d "$HOME/Pictures/wallpapers" ]; then
              mkdir -p "$HOME/Pictures/wallpapers"
              echo "${OK} Created wallpapers directory." 2>&1 | tee -a "$LOG"
          fi

          if cp -R wallpapers/* "$HOME/Pictures/wallpapers/" >> "$LOG" 2>&1; then
              echo "${OK} Wallpapers copied successfully." 2>&1 | tee -a "$LOG"
              rm -rf wallpapers 2>&1 # Remove cloned repository after copying wallpapers
              break
          else
              echo "${ERROR} Copying wallpapers failed" 2>&1 | tee -a "$LOG"
          fi
      else
          echo "${ERROR} Downloading additional wallpapers failed" 2>&1 | tee -a "$LOG"
      fi
      ;;
  [Nn])
      echo "${NOTE} You chose not to download additional wallpapers." 2>&1 | tee -a "$LOG"
      break
      ;;
  *)
      echo "Please enter 'y' or 'n' to proceed."
      ;;
  esac
done

# Cleaning up of ~/.config/ backups
cleanup_backups() {
  CONFIG_DIR="$HOME/.config"
  BACKUP_PREFIX="-backup"

  # Loop through directories in $HOME/.config
  for DIR in "$CONFIG_DIR"/*; do
    if [ -d "$DIR" ]; then
      BACKUP_DIRS=()

      # Check for backup directories
      for BACKUP in "$DIR"$BACKUP_PREFIX*; do
        if [ -d "$BACKUP" ]; then
          BACKUP_DIRS+=("$BACKUP")
        fi
      done
	  
      # If more than one backup found
      if [ ${#BACKUP_DIRS[@]} -gt 1 ]; then
      	printf "\n%.0s" {1..2}
        echo -e "${INFO} Found ${MAGENTA}multiple backups${RESET} for: ${YELLOW}${DIR##*/}${RESET}"
        echo "${YELLOW}Backups: ${RESET}"

        # List the backups
        for BACKUP in "${BACKUP_DIRS[@]}"; do
          echo "  - ${BACKUP##*/}"
        done

        echo -n "${CAT} Do you want to delete the older backups of ${YELLOW}${DIR##*/}${RESET} and keep the latest backup only? (y/N): "
        read back_choice

        if [[ "$back_choice" == [Yy]* ]]; then
          # Sort backups by modification time
          latest_backup="${BACKUP_DIRS[0]}"
          for BACKUP in "${BACKUP_DIRS[@]}"; do
            if [ "$BACKUP" -nt "$latest_backup" ]; then
              latest_backup="$BACKUP"
            fi
          done

          for BACKUP in "${BACKUP_DIRS[@]}"; do
            if [ "$BACKUP" != "$latest_backup" ]; then
              echo "Deleting: ${BACKUP##*/}"
              rm -rf "$BACKUP"
            fi
          done
          echo "Old backups of ${YELLOW}${DIR##*/}${RESET} deleted, keeping: ${MAGENTA}${latest_backup##*/}${RESET}"
        fi
      fi
    fi
  done
}
# Execute the cleanup function
cleanup_backups

# Check if ~/.config/waybar/style.css does not exist or is a symlink
if [ ! -e "$HOME/.config/waybar/style.css" ] || [ -L "$HOME/.config/waybar/style.css" ]; then
    ln -sf "$waybar_style" "$HOME/.config/waybar/style.css" 2>&1 | tee -a "$LOG"
fi

printf "\n%.0s" {1..1}

# initialize wallust to avoid config error on hyprland
wallust run -s $wallpaper 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
printf "${OK} GREAT! HyprFedora-dots is now Loaded & Ready !!! "
printf "\n%.0s" {1..1}
printf "${INFO} However, it is ${MAGENTA}HIGHLY SUGGESTED${RESET} to logout and re-login or better reboot to avoid any issues"
printf "\n%.0s" {1..1}
