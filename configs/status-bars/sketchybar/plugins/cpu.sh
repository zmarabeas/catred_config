#!/bin/bash
# SketchyBar CPU Plugin

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

case $CURRENT_THEME in
    "catppuccin-macchiato")
        ORANGE="0xfff5a97f"
        ;;
    "gruvbox")
        ORANGE="0xffd65d0e"
        ;;
    "tokyo-night-storm")
        ORANGE="0xffff9e64"
        ;;
esac

CPU_INFO=$(ps -eo pcpu | awk '{sum += $1} END {print int(sum)}')
CPU_PERCENT="$CPU_INFO%"

sketchybar --set $NAME label="$CPU_PERCENT" icon.color=$ORANGE