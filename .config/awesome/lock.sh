#!/bin/bash

# ==============================
# Colors
# ==============================

# Teal Inspired Colors
BG_COLOR="0A1E1EFF"           # Background: Very dark teal
RING_COLOR="1B4D4AFF"         # Ring: Deep muted teal
INSIDE_COLOR="0F2D2CFF"       # Inside: Dark sea green
RING_VER_COLOR="2F7C79FF"     # Verifying ring: Medium teal
INSIDE_VER_COLOR="0F2D2CFF"   # Verifying inside: Dark sea green
RING_WRONG_COLOR="3FA7A2FF"   # Wrong ring: Light vibrant teal
INSIDE_WRONG_COLOR="14403EFF" # Wrong inside: Muted greenish teal
SEPARATOR_COLOR="1B4D4AFF"    # Separator: Deep muted teal
TEXT_COLOR="D0F5F2FF"         # Text: Pale mint white
HL_KEY_COLOR="2FA7A2FF"       # Highlighted key: Bright cyan teal
HL_BACKSPACE_COLOR="50CFC8FF" # Backspace highlight: Light aqua


# ==============================
# Fonts & Sizes
# ==============================
FONT="FiraCode"
TIME_SIZE=50
DATE_SIZE=26
TEXT_SIZE=26
RADIUS=180
RING_WIDTH=12

# ==============================
# i3lock Command
# ==============================
i3lock \
    -k \
    -B 20 \
    --radius=$RADIUS \
    --ring-width=$RING_WIDTH \
    --indicator \
    --layout-color=$TEXT_COLOR \
    --time-color=$TEXT_COLOR \
    --date-color=$TEXT_COLOR \
    --greeter-color=$TEXT_COLOR \
    --verif-color=$TEXT_COLOR \
    --wrong-color=$TEXT_COLOR \
    --modif-color=$TEXT_COLOR \
    --verif-text="Authenticating..." \
    --wrong-text="Wrong!!!" \
    --noinput-text="No Input" \
    --date-size=$DATE_SIZE \
    --layout-size=$TEXT_SIZE \
    --verif-size=$TEXT_SIZE \
    --wrong-size=$TEXT_SIZE \
    --greeter-size=$TEXT_SIZE \
    --time-size=$TIME_SIZE \
    --time-font=$FONT \
    --date-font=$FONT \
    --layout-font=$FONT \
    --verif-font=$FONT \
    --wrong-font=$FONT \
    --greeter-font=$FONT \
    --inside-color=$INSIDE_COLOR \
    --ring-color=$RING_COLOR \
    --ringver-color=$RING_VER_COLOR \
    --insidever-color=$INSIDE_VER_COLOR \
    --separator-color=$SEPARATOR_COLOR \
    --date-str="%A, %b %d" \
    --time-pos="ix:iy-20" \
    --date-pos="tx:ty+60" \
    --keyhl-color=$HL_KEY_COLOR \
    --bshl-color=$HL_BACKSPACE_COLOR \
    --insidewrong-color=$INSIDE_WRONG_COLOR \
    --ringwrong-color=$RING_WRONG_COLOR \
    --nofork

