#!/bin/bash
# SketchyBar Front App Plugin

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

case $CURRENT_THEME in
    "catppuccin-macchiato")
        BLUE="0xff8aadf4"
        ;;
    "gruvbox")
        BLUE="0xff458588"
        ;;
    "tokyo-night-storm")
        BLUE="0xff7aa2f7"
        ;;
esac

sketchybar --set $NAME label="$INFO" icon.color=$BLUE