## Changelogs

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
