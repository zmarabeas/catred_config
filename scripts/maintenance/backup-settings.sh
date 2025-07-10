#!/bin/bash
#
# Catred Config - Backup Settings
#
# This script creates a timestamped backup of all managed configuration
# directories from their home directory locations.
#

set -e

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../.. && pwd)
BACKUP_ROOT="$REPO_DIR/backups"
BACKUP_DIR="$BACKUP_ROOT/backup-$(date +%Y-%m-%d_%H-%M-%S)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}INFO:${NC} $*"; }
success() { echo -e "${GREEN}SUCCESS:${NC} $*"; }

# --- Main Execution ---
main() {
    info "Starting configuration backup..."
    mkdir -p "$BACKUP_DIR"

    local configs_to_backup=(
        "$HOME/.config/nvim"
        "$HOME/.config/fish"
        "$HOME/.config/zed"
        "$HOME/.config/yabai"
        "$HOME/.config/skhd"
        "$HOME/.config/sketchybar"
        "$HOME/.config/i3"
        "$HOME/.config/sway"
        "$HOME/.config/polybar"
        "$HOME/.config/rofi"
        "$HOME/.config/komorebi"
        "$HOME/.config/whkd"
        "$HOME/.config/yasb"
        "$HOME/.config/kitty"
        "$HOME/.config/alacritty"
        "$HOME/.config/ghostty"
        "$HOME/.config/warp"
    )

    info "Copying configurations to $BACKUP_DIR..."
    for config in "${configs_to_backup[@]}"; do
        if [ -e "$config" ]; then
            info "Backing up $config..."
            cp -r "$config" "$BACKUP_DIR/"
        fi
    done

    success "Backup complete!"
    echo "Configurations have been saved to: $BACKUP_DIR"
}

main
