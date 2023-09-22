#!/usr/bin/env bash

CONFIG="$HOME/.config/hypr/dunst/dunstrc"

if [[ ! $(pidof dunst) ]]; then
	dunst -conf ${CONFIG}
fi
