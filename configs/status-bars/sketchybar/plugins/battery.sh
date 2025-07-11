#!/bin/bash
# SketchyBar Battery Plugin

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
        ORANGE="0xfff5a97f"
        ;;
    "gruvbox")
        GREEN="0xff98971a"
        RED="0xffcc241d"
        ORANGE="0xffd65d0e"
        ;;
    "tokyo-night-storm")
        GREEN="0xff9ece6a"
        RED="0xfff7768e"
        ORANGE="0xffff9e64"
        ;;
esac

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
fi

# Set color based on battery level
if [[ $PERCENTAGE -gt 50 ]]; then
  COLOR=$GREEN
elif [[ $PERCENTAGE -gt 20 ]]; then
  COLOR=$ORANGE
else
  COLOR=$RED
fi

sketchybar --set $NAME icon="$ICON" \
                   label="${PERCENTAGE}%" \
                   icon.color=$COLOR