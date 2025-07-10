#!/bin/bash
# SketchyBar Memory Plugin

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

case $CURRENT_THEME in
    "catppuccin-macchiato")
        PURPLE="0xffc6a0f6"
        ;;
    "gruvbox")
        PURPLE="0xffb16286"
        ;;
    "tokyo-night-storm")
        PURPLE="0xffbb9af7"
        ;;
esac

MEMORY_USAGE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | sed 's/%//')
if [ -z "$MEMORY_USAGE" ]; then
    # Fallback method
    MEMORY_USAGE=$(top -l 1 -s 0 | grep PhysMem | awk '{print $2}' | sed 's/M//' | awk '{printf "%.0f", $1*100/16384}')
fi

sketchybar --set $NAME label="${MEMORY_USAGE}%" icon.color=$PURPLE