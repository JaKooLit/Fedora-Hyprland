#!/bin/sh

# WOFI STYLES
CONFIG="$HOME/.config/hypr/wofi/WofiBig/config"
STYLE="$HOME/.config/hypr/wofi/style.css"
COLORS="$HOME/.config/hypr/wofi/colors"

if [[ ! $(pidof wofi) ]]; then
  cliphist list | wofi --show dmenu --prompt 'Search...' \
    --conf ${CONFIG} --style ${STYLE} --color ${COLORS} \
    --width=600 --height=400 | cliphist decode | wl-copy
else
	pkill wofi
fi