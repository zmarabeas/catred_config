#!/bin/bash
# SketchyBar Network Plugin

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

case $CURRENT_THEME in
    "catppuccin-macchiato")
        GREEN="0xffa6da95"
        RED="0xffed8796"
        ;;
    "gruvbox")
        GREEN="0xff98971a"
        RED="0xffcc241d"
        ;;
    "tokyo-night-storm")
        GREEN="0xff9ece6a"
        RED="0xfff7768e"
        ;;
esac

# Check network connectivity
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    ICON="󰤨"
    COLOR=$GREEN
    LABEL="Online"
else
    ICON="󰤭"
    COLOR=$RED
    LABEL="Offline"
fi

sketchybar --set $NAME icon="$ICON" \
                   label="$LABEL" \
                   icon.color=$COLOR