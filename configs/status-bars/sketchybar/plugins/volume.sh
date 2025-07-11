#!/bin/bash
# SketchyBar Volume Plugin

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

VOLUME=$(osascript -e "output volume of (get volume settings)")

case $VOLUME in
  [6-9][0-9]|100) ICON="󰕾"
  ;;
  [3-5][0-9]) ICON="󰖀"
  ;;
  [1-2][0-9]) ICON="󰕿"
  ;;
  *) ICON="󰝟"
esac

sketchybar --set $NAME icon="$ICON" \
                   label="$VOLUME%" \
                   icon.color=$BLUE