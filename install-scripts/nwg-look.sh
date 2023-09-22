#!/bin/bash

nwg_look=(
go
gtk3
gtk3-devel
cairo-devel
glib-devel
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
LOG="install-$(date +%d-%H%M%S)_nwg-look.log"

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
      echo -e "\033[1A\033[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\033[1A\033[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

for PKG1 in "${nwg_look[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\033[1A\033[K${ERROR} - $PKG1 install had failed, please check the install.log"
    exit 1
  fi
done

printf "${NOTE} Installing nwg-look\n"
if git clone https://github.com/nwg-piotr/nwg-look.git; then
  cd nwg-look
  make build
  sudo make install
  cd ..
else
  echo -e "${ERROR} Download failed for nwg-look."
fi

clear