#!/bin/bash
set -x
# Define the path
wallpaper_path="$HOME/Pictures/wallpapers/Dynamic-Wallpapers"
hypr_config_path="$HOME/.config/hypr"

# Define the GTK themes for light and dark modes
light_gtk_theme="Tokyonight-Light-B"
dark_gtk_theme="Tokyonight-Dark-B"
light_icon_theme="TokyoNight-SE"
dark_icon_theme="TokyoNight-SE"

# Define functions for notifying user and updating symlinks
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u normal "Switching to $1 mode"
}

# Determine the current wallpaper mode by checking a configuration file
if [ "$(cat ~/.wallpaper_mode)" = "light" ]; then
  current_mode="light"
  next_mode="dark"
else
  current_mode="dark"
  next_mode="light"
fi
path_param=$(echo $next_mode | sed 's/.*/\u&/')

notify_user "$next_mode"
ln -sf "${hypr_config_path}/waybar/style/style-${next_mode}.css" "${hypr_config_path}/waybar/style.css"
ln -sf "${hypr_config_path}/dunst/styles/dunstrc-${next_mode}" "${hypr_config_path}/dunst/dunstrc"
ln -sf "${hypr_config_path}/wofi/styles/style-${next_mode}.css" "${hypr_config_path}/wofi/style.css"

gtk_theme="${next_mode}_gtk_theme"
icon_theme="${next_mode}_icon_theme"

gsettings set org.gnome.desktop.interface gtk-theme "${!gtk_theme}"
gsettings set org.gnome.desktop.interface icon-theme "${!icon_theme}"

# Find the next wallpaper if one exists
current_wallpaper="$(cat ~/.current_wallpaper)"
next_wallpaper="${current_wallpaper/_"$current_mode"/_"$next_mode"}"

if ! [ -f "$next_wallpaper" ]; then
  next_wallpaper="$(find "${wallpaper_path/"${path_param}"}" -type f -iname "*_"${next_mode}".jpg" -print0 | shuf -n1 -z | xargs -0)"
fi

swaybg -m fill -i "${next_wallpaper}" &

# Update the configuration file to reflect the new wallpaper mode and current wallpaper
echo "$next_mode" > ~/.wallpaper_mode
echo "$next_wallpaper" > ~/.current_wallpaper

sleep 2
exec ~/.config/hypr/scripts/Startup.sh &