#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Adding users into input group #


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_input.log"

while true; do
    echo "${WARN} This script will add your user to the 'input' group."
    echo "${NOTE} Please note that adding yourself to the 'input' group might be necessary for waybar keyboard-state functionality."

    read -p "${YELLOW}Do you want to proceed? (y/n): ${RESET}" choice

    if [[ $choice == "y" || $choice == "Y" ]]; then
        # Check if the 'input' group exists
        if grep -q '^input:' /etc/group; then
            echo "${OK} 'input' group exists."
        else
            echo "${NOTE} 'input' group doesn't exist. Creating 'input' group..."
            sudo groupadd input

            # Log the creation of the 'input' group
            echo "'input' group created" >> "$LOG"
        fi

        # Add the user to the input group
        sudo usermod -aG input "$(whoami)"
        echo "${OK} User added to the 'input' group. Changes will take effect after you log out and log back in."

        # Log the addition of the user to the 'input' group
        echo "User added to 'input' group" >> "$LOG"
        break  # Break out of the loop if 'yes' is chosen
    elif [[ $choice == "n" || $choice == "N" ]]; then
        echo "${NOTE} No changes made. Exiting the script."
        break  # Break out of the loop if 'no' is chosen
    else
        echo "${ERROR} Invalid choice. Please enter 'y' for yes or 'n' for no."
    fi
done

clear
