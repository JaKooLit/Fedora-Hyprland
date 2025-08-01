#!/bin/bash
# Sets up Snapper, DNF integration, and grub-btrfs on Fedora systems

# Required packages
snapper_packages=(
  snapper
  libdnf5-plugin-actions
  btrfs-assistant
  inotify-tools
  git
  make
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_snapper.log"

printf "\n%.0s" {1..1}

# Install packages
printf "\n%s - Installing ${SKY_BLUE}Snapper and dependencies${RESET} .... \n" "${NOTE}"
for PKG1 in "${snapper_packages[@]}"; do
  install_package "$PKG1" "$LOG"
done

# Configure libdnf5 snapper integration
printf "\n%s - Configuring ${SKY_BLUE}libdnf5-plugin-actions for snapper${RESET} .... \n" "${NOTE}"
sudo bash -c "cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions" <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF

# Configure Snapper
printf "\n%s - Setting up ${SKY_BLUE}Snapper configs${RESET} .... \n" "${NOTE}"
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
sudo restorecon -RFv /.snapshots
sudo restorecon -RFv /home/.snapshots
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes
echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf

# Clone and install grub-btrfs safely
printf "\n%s - Installing ${SKY_BLUE}grub-btrfs${RESET} .... \n" "${NOTE}"
REPO_DIR="$(mktemp -d -p "$PWD" grub-btrfs-XXXX)"
git clone https://github.com/Antynea/grub-btrfs "$REPO_DIR" || { echo "${ERROR} Failed to clone grub-btrfs"; exit 1; }

pushd "$REPO_DIR" > /dev/null

# Modify config before install
sed -i.bkp \
  -e '/^#GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=/a \
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"' \
  -e '/^#GRUB_BTRFS_GRUB_DIRNAME=/a \
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' \
  -e '/^#GRUB_BTRFS_MKCONFIG=/a \
GRUB_BTRFS_MKCONFIG=/usr/bin/grub2-mkconfig' \
  -e '/^#GRUB_BTRFS_SCRIPT_CHECK=/a \
GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' \
  config

sudo make install
sudo systemctl enable --now grub-btrfsd.service

popd > /dev/null
rm -rf "$REPO_DIR"

# Final Snapper settings
sudo snapper -c home set-config TIMELINE_CREATE=no
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

echo -e "${OK} Snapper has been installed and configured successfully!"

printf "\n%.0s" {1..1}
