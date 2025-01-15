## Changelogs

## 13 Jan 2025
- replaced mate polkit with hyprpolkitagent

## 12 Jan 2025
- switch to final version of aylurs-gtk-shell-v1

## 06 Jan 2025
- added fastfetch compact-config for fedora
- remove copr tofik/nwg-shell since solopasha has nwg-look plus tofik-nwg-shell copr is installing all kinds of shits
- default theme for oh my zsh theme is now "funky" 

## 26 Dec 2024
- Removal of Bibata Ice cursor on assets since its integrated in the GTK Themes and Icons extract from a separate repo
- integrated hyprcursor in Bibata Ice Cursor

## 16 Nov 2024
- adjusted ags v1.8.2 install script

## 15 Nov 2024
- revert Aylurs GTK Shell (AGS) to install older version

## 20 Sep 2024
- User will be ask if they want to set Thunar as default file manager if they decided to install it

## 19 Sep 2024
- Added fastfetch on tty. However, will be disabled if user decided to install pokemon colorscripts

## 18 Sep 2024
- refactored to work with Fedora 41. Tested on Fedora 41 server install
- dotfiles will now be downloaded from main or master branch instead of from the releases version.

## 14 Sep 2024
- remove the final error checks instead, introduced a final check of essential packages to ran Hyprland
- switched from manual build to copr repo - nwg-look

## 08 Sep 2024
- Added final error checks on install-logs

## 03 Sep 2024
- Some re-arranging of hyprland packages and added hyprland-eco.sh script for -eco packages

## 28 Aug 2024
- Added final check if hyprland is installed and will give an error to user

## 26 Aug 2024
- added nvidia_drm.fbdev=1 for grub

## 22 Aug 2024
- Added pre-clean up script

## 13 Aug 2024
- updated to download from Hyprland-Dots releases as usual

## 09 Aug 2024
- updated dotfiles.sh to download from Hyprland-Dots main branch for Hyprland 0.42.0 update

## 08 Aug 2024
- added aquamarine for Hyprland v0.42.0

## 07 Jul 2024
- added eza (ls replacement for tty). Note only on .zshrc
- 
## 04 Jul 2024
- Added uninstall.sh. USE THIS WITH CAUTION!

## 26 May 2024
- Added fzf for zsh (CTRL R to invoke FZF history)

## 23 May 2024
- added qalculate-gtk to work with rofi-calc. Default keybinds (SUPER ALT C)
- added power-profiles-daemon for ROG laptops. Note, I cant add to all since it conflicts with TLP, CPU-Auto-frequency etc.
- added fastfetch

## 22 May 2024
- change the sddm theme destination to /etc/sddm.conf.d/10-theme.conf to theme.conf.user

## 19 May 2024
- Disabled the auto-login in .zprofile as it causes auto-login to Hyprland if any wayland was chosen. Can enabled if only using hyprland

## 10 May 2024
- added wallust-git and remove python-pywal for migration to wallust on Hyprland-Dots v2.2.11

## 03 May 2024
- added python3-pyquery for new weather-waybar python based on Hyprland-Dots

## 02 May 2024
- Added pyprland (hyprland plugin)

## 28 Apr 2024
- Fixed nvidia.sh

## 26 Apr 2024
- Updated sddm.sh for Qt6 variant

## 23 Apr 2024
- Dropping swayidle and swaylock in favor of hypridle and hyprlock

## 20 Apr 2024
- Change default Oh-my-zsh theme to xiong-chiamiov-plus
- updated nvidia.sh (added hyprcursor and changed to hyprland only from git for nvidia)

## 11 Jan 2024
- dropped wlsunset

## 29 December 2023
- Remove dunst in favor of swaync. NOTE: Part of the script is to also uninstall mako and dunst (if installed) as on my experience, dunst is sometimes taking over the notification even if it is not set to start

## 16 Dec 2023
- zsh theme switched to `agnoster` theme by default
- pywal tty color change disabled by default

## 11 Dec 2023
- Changing over to zsh automatically if user opted
- If chose to install zsh and have no login manager, zsh auto login will auto start Hyprland
- added as optional, with zsh, pokemon colorscripts
- improved zsh install scripts, so even the existing zsh users of can still opt for zsh and oh-my-zsh installation :)

## 03 Dec 2023
- Added kvantum for qt apps theming
- return of wlogout due to theming issues of rofi-power

## 26 Nov 2023
- nvidia - Move to hyprland-git. see [`commit`](https://github.com/hyprwm/Hyprland/commit/cd96ceecc551c25631783499bd92c6662c5d3616)

## 25 Nov 2023
- drop wlogout since Hyprland-Dots v2.1.9 uses rofi-power

## 23-Nov-2023
- Added Bibata cursor to install if opted for GTK Themes. However, it is not pre-applied. Use nwg-look utility to apply

## 19-Nov-2023
- Adjust dotfiles script to download from releases instead of from upstream

## 27 Oct 2023
- Moving to a centralized Hyprland-dots

## 30-Sep-2023
- added gnome-system-monitor (right click cpu module in waybar)

## 27-Sep-2023
- remove auto start of portal-hyprland-hyprland
- removal of Virtual-1 monitor in Monitors.conf

## 22-Sep-2023
- initial release
