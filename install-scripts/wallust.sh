#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# wallust - pywal colors replacement #

depend=(
imagemagick
)

#specific branch or release
wal_tag="dev"

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_wallust.log"
MLOG="install-$(date +%d-%H%M%S)_wallust.log"

# Installing depencies
for PKG1 in "${depend[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\033[1A\033[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

##
printf "${NOTE} Installing wallust from dev branch...\n"  

# Check if folder exists and remove it
if [ -d "wallust" ]; then
    printf "${NOTE} Removing existing wallust folder...\n"
    rm -rf "wallust"
fi

# Clone and build wallust
printf "${NOTE} Installing wallust...\n"
if git clone --depth 1 -b $wal_tag https://codeberg.org/explosion-mental/wallust.git; then
    cd wallust || exit 1
	make
    if sudo cmake --install 2>&1 | tee -a "$MLOG" ; then
        printf "${OK} wallust installed successfully.\n" 2>&1 | tee -a "$MLOG"
    else
        echo -e "${ERROR} Installation failed for wallust." 2>&1 | tee -a "$MLOG"
    fi
    #moving the addional logs to Install-Logs directory
    mv $MLOG ../Install-Logs/ || true 
    cd ..
else
    echo -e "${ERROR} Download failed for wallust." 2>&1 | tee -a "$LOG"
fi

clear

