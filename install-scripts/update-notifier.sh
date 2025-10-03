#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Package Update Notifier #

update=(
  dnf-automatic
  libnotify
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_update-notifier.log"

# Update Notifier
printf "${NOTE} Installing ${SKY_BLUE}Update Notifier${RESET} Packages...\n"
for UPD in "${update[@]}"; do
  install_package "$UPD" "$LOG"
done

# Create update check script
printf "${NOTE} Creating ${YELLOW}update check${RESET} script...\n"

UPDATE_SCRIPT="$HOME/.config/hypr/scripts/update-notifier.sh"
mkdir -p "$HOME/.config/hypr/scripts"

cat > "$UPDATE_SCRIPT" << 'EOF'
#!/bin/bash
# Package Update Notifier Script
# Checks for available system updates and notifies user

# Check for updates
UPDATE_COUNT=$(dnf check-update --quiet 2>/dev/null | grep -v "^$" | grep -v "^Last metadata" | wc -l)

if [ "$UPDATE_COUNT" -gt 0 ]; then
    # Get list of packages to update (first 5)
    UPDATE_LIST=$(dnf check-update --quiet 2>/dev/null | grep -v "^$" | grep -v "^Last metadata" | head -5 | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//')
    
    if [ "$UPDATE_COUNT" -le 5 ]; then
        notify-send -u normal -i system-software-update "System Updates Available" "$UPDATE_COUNT package(s) can be updated:\n$UPDATE_LIST"
    else
        notify-send -u normal -i system-software-update "System Updates Available" "$UPDATE_COUNT package(s) can be updated:\n$UPDATE_LIST and more..."
    fi
    
    echo "$(date): $UPDATE_COUNT updates available"
else
    echo "$(date): System is up to date"
fi
EOF

chmod +x "$UPDATE_SCRIPT"

printf "${OK} Update notifier script created at ${YELLOW}$UPDATE_SCRIPT${RESET}\n"

# Create systemd timer for update checks
printf "${NOTE} Creating ${YELLOW}systemd timer${RESET} for update checks...\n"

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/update-notifier.service" << EOF
[Unit]
Description=Package Update Notifier
After=network-online.target

[Service]
Type=oneshot
ExecStart=$UPDATE_SCRIPT

[Install]
WantedBy=default.target
EOF

cat > "$SYSTEMD_DIR/update-notifier.timer" << EOF
[Unit]
Description=Check for Package Updates
Requires=update-notifier.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=6h
Persistent=true

[Install]
WantedBy=timers.target
EOF

printf "${OK} Systemd timer created\n"

# Enable the timer
printf "${NOTE} Enabling ${YELLOW}update-notifier${RESET} timer...\n"
systemctl --user daemon-reload
systemctl --user enable update-notifier.timer 2>&1 | tee -a "$LOG"
systemctl --user start update-notifier.timer 2>&1 | tee -a "$LOG"

printf "${OK} Update notifier timer is now active!\n"
printf "${INFO} Updates will be checked every 6 hours\n"
printf "${INFO} Manual check: ${YELLOW}$UPDATE_SCRIPT${RESET}\n"
printf "${INFO} Check timer status: ${YELLOW}systemctl --user status update-notifier.timer${RESET}\n"

printf "\n%.0s" {1..2}
