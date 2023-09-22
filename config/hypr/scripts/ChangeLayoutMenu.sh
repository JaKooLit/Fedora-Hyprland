#!/bin/bash

# Files
CONFIG="$HOME/.config/hypr/wofi/WofiBig/config"
STYLE="$HOME/.config/hypr/wofi/style.css"
COLORS="$HOME/.config/hypr/wofi/colors"

WAYBARFILE="$HOME/.config/hypr/waybar/config"
WOFIFILE="$HOME/.config/hypr/wofi/config"

# wofi window config (in %)
WIDTH=12
HEIGHT=30

## Wofi Command
wofi_command="wofi --show dmenu \
			--prompt choose...
			--conf $CONFIG --style $STYLE --color $COLORS \
			--width=$WIDTH% --height=$HEIGHT% \
			--cache-file=/dev/null \
			--hide-scroll --no-actions \
			--matching=fuzzy"


menu(){
printf "1. default\n" 
printf "2. plasma-style\n" 
printf "3. gnome-style\n"
printf "4. dual-panel\n"
printf "5. simple\n"
printf "6. no panel" 
}

main() {
    choice=$(menu | ${wofi_command} | cut -d. -f1)
    case $choice in
        1)
            ln -sf "$HOME/.config/hypr/waybar/configs/config-default" "$WAYBARFILE"
            ln -sf "$HOME/.config/hypr/wofi/configs/config-default" "$WOFIFILE"
            ;;
        2)
            ln -sf "$HOME/.config/hypr/waybar/configs/config-plasma" "$WAYBARFILE"
            ln -sf "$HOME/.config/hypr/wofi/configs/config-plasma" "$WOFIFILE"
            ;;
        3)
            ln -sf "$HOME/.config/hypr/waybar/configs/config-gnome" "$WAYBARFILE"
            ln -sf "$HOME/.config/hypr/wofi/configs/config-gnome" "$WOFIFILE"
            ;;
        4)
            ln -sf "$HOME/.config/hypr/waybar/configs/config-dual" "$WAYBARFILE"
            ln -sf "$HOME/.config/hypr/wofi/configs/config-default" "$WOFIFILE"
            ;;
        5)
            ln -sf "$HOME/.config/hypr/waybar/configs/config-simple" "$WAYBARFILE"
            ln -sf "$HOME/.config/hypr/wofi/configs/config-default" "$WOFIFILE"
            ;;
	    6)
            if pgrep -x "waybar" >/dev/null; then
                killall waybar
                exit
            fi
            ;;        
        *)
            ;;
    esac
}

# Check if wofi is already running
if pidof wofi >/dev/null; then
    killall wofi
    exit 0
else
    main
fi

# Restart Waybar and run other scripts if a choice was made
if [[ -n "$choice" ]]; then
    # Restart Waybar
    killall waybar
fi

exec ~/.config/hypr/scripts/Startup.sh &
                