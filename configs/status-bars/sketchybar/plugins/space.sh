#!/bin/bash
# SketchyBar Space Plugin

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

case $CURRENT_THEME in
    "catppuccin-macchiato")
        ACCENT="0xffeed49f"
        FOREGROUND="0xffcad3f5"
        GRAY="0xff6e738d"
        ;;
    "gruvbox")
        ACCENT="0xffd79921"
        FOREGROUND="0xffebdbb2"
        GRAY="0xff928374"
        ;;
    "tokyo-night-storm")
        ACCENT="0xffe0af68"
        FOREGROUND="0xffc0caf5"
        GRAY="0xff565f89"
        ;;
esac

if [ $SELECTED = true ]; then
  sketchybar --set $NAME background.drawing=on \
                   background.color=$ACCENT \
                   label.color=0xff000000 \
                   icon.color=0xff000000
else
  sketchybar --set $NAME background.drawing=off \
                   label.color=$FOREGROUND \
                   icon.color=$GRAY
fi