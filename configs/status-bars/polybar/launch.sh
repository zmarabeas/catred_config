#!/bin/bash
# Polybar Launch Script

# Load theme colors
if [ -f ~/.config/catred_config/current_theme ]; then
    CURRENT_THEME=$(cat ~/.config/catred_config/current_theme)
else
    CURRENT_THEME="catppuccin-macchiato"
fi

# Load color definitions based on theme
case $CURRENT_THEME in
    "catppuccin-macchiato")
        cat > /tmp/polybar_colors << EOF
background=#24273a
foreground=#cad3f5
primary=#8aadf4
secondary=#a6da95
alert=#ed8796
accent=#f5a97f
EOF
        ;;
    "gruvbox")
        cat > /tmp/polybar_colors << EOF
background=#282828
foreground=#ebdbb2
primary=#458588
secondary=#98971a
alert=#cc241d
accent=#d65d0e
EOF
        ;;
    "tokyo-night-storm")
        cat > /tmp/polybar_colors << EOF
background=#24283b
foreground=#c0caf5
primary=#7aa2f7
secondary=#9ece6a
alert=#f7768e
accent=#ff9e64
EOF
        ;;
esac

# Terminate already running polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."