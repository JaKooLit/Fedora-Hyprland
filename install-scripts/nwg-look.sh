#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# NWG-LOOK (GTK-Settings) - an lxappearance like #

nwg_look=(
golang
gtk3
gtk3-devel
cairo-devel
glib-devel
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_nwg-look.log"
MLOG="install-$(date +%d-%H%M%S)_nwg-look2.log"

# Installing NWG-Look Dependencies
for PKG1 in "${nwg_look[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\033[1A\033[K${ERROR} - $PKG1 install had failed, please check the install.log"
    exit 1
  fi
done

printf "${NOTE} Installing nwg-look\n"
# Check if nwg-look directory exists
if [ -d "nwg-look" ]; then
  printf "${INFO} nwg-look directory already exists. Updating...\n"
  cd nwg-look || exit 1
  git stash
  git pull
else
  # Clone nwg-look repository if directory doesn't exist
  if git clone https://github.com/nwg-piotr/nwg-look.git; then
    cd nwg-look || exit 1
  else
    echo -e "${ERROR} Download failed for nwg-look." 2>&1 | tee -a "$LOG"
    mv "$MLOG" ../Install-Logs/ || true
    exit 1
  fi
fi

# Build nwg-look
make build
if sudo make install 2>&1 | tee -a "$MLOG"; then
  printf "${OK} nwg-look installed successfully.\n" 2>&1 | tee -a "$MLOG"
else
  echo -e "${ERROR} Installation failed for nwg-look" 2>&1 | tee -a "$MLOG"
fi

# Move logs to Install-Logs directory
mv "$MLOG" ../Install-Logs/ || true
cd ..

clear