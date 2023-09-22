#!/bin/bash

CONFIG="$HOME/.config/hypr/wofi/config"
STYLE="$HOME/.config/hypr/wofi/style.css"
COLORS="$HOME/.config/hypr/wofi/colors"

if [[ ! $(pidof wofi) ]]; then
	wofi --show drun --prompt 'Search...' --conf ${CONFIG} --style ${STYLE} --color ${COLORS}
else
	pkill wofi
fi
