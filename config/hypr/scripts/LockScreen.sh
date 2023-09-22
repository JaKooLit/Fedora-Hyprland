#!/bin/bash

CONFIG="$HOME/.config/hypr/swaylock/config"

sleep 0.5s; swaylock --config ${CONFIG} & disown
