#!/bin/bash
# Rofi Launch Script with Dynamic Theme Loading

# Load current theme
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

# Set theme file path
THEME_DIR="$HOME/.config/catred_config/configs/launchers/rofi/themes"
THEME_FILE="$THEME_DIR/$CURRENT_THEME.rasi"

# Create symlink to current theme
ln -sf "$THEME_FILE" "$HOME/.config/catred_config/configs/launchers/rofi/theme.rasi"

# Launch rofi with current theme
rofi -show drun \
     -config "$HOME/.config/catred_config/configs/launchers/rofi/config.rasi" \
     -theme "$HOME/.config/catred_config/configs/launchers/rofi/theme.rasi"