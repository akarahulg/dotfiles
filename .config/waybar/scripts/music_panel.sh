#!/bin/bash

# Path to the script that gets the current song
CURRENT_SONG="$HOME/.config/waybar/scripts/current_song.sh"

# Zscroll command
zscroll -p " | " --delay 0.1 \
    --length 20 \
    --match-command "playerctl status" \
    --match-text "Playing" "--scroll 2" \
    --match-text "Paused" " --scroll 0" \
    --update-interval 1 \
    --update-check true "$CURRENT_SONG" &

wait
