#!/bin/bash

# Get player status and metadata from the default player
PLAYER_STATUS=$(playerctl status 2> /dev/null)
ARTIST=$(playerctl metadata artist 2> /dev/null)
TITLE=$(playerctl metadata title 2> /dev/null)

# Check if a player is running
if [ "$PLAYER_STATUS" = "" ]; then
    echo "Music Player Offline"
elif [ "$PLAYER_STATUS" = "Stopped" ]; then
    echo "No Music Playing"
else # Player is Playing or Paused
    echo "${ARTIST} - ${TITLE}"
fi