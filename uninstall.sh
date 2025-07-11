#!/bin/bash
echo "This will uninstall Catred Config and its components."
read -p "Are you sure? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

info "Stopping services..."
brew services stop yabai
brew services stop skhd
brew services stop sketchybar

info "Removing symlinks..."
stow -d "/Users/ayo/catred_config/configs" -t "/Users/ayo/.config" -D     nvim     fish     zed

stow -d "/Users/ayo/catred_config/configs/window-managers" -t "/Users/ayo/.config" -D     yabai

stow -d "/Users/ayo/catred_config/configs/status-bars" -t "/Users/ayo/.config" -D     sketchybar

stow -d "/Users/ayo/catred_config/configs/terminals" -t "/Users/ayo/.config" -D     kitty     alacritty     ghostty     warp

stow -d "/Users/ayo/catred_config/configs/launchers" -t "/Users/ayo/.config" -D     raycast

info "Uninstalling packages..."
brew uninstall stow fish neovim zed yabai skhd sketchybar
brew uninstall --cask raycast warp ghostty kitty alacritty font-jetbrains-mono-nerd-font

info "Restoring shell to bash..."
chsh -s /bin/bash

echo "Uninstall complete. You may need to manually restore backups from /Users/ayo/.config-backup-20250709-004505"
