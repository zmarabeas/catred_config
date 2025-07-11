#!/bin/bash
#
# Comprehensive macOS Installation Script for Catred Config
#
# This script bootstraps a complete, themed development environment on a fresh
# macOS system. It handles:
#   - Backups of existing configurations
#   - Dependency checks (Homebrew)
#   - Installation of all applications, CLIs, and fonts
#   - Symlinking of all configuration files from the repository
#   - Setup of Neovim plugins and the Fish shell
#   - Application of the default theme
#   - Creation of a comprehensive uninstall script
#

set -e

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../.. && pwd)
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$HOME/catred_install.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "$*" | tee -a "$LOG_FILE"; }
info() { log "${BLUE}INFO:${NC} $*"; }
success() { log "${GREEN}SUCCESS:${NC} $*"; }
warning() { log "${YELLOW}WARNING:${NC} $*"; }
error() { log "${RED}ERROR:${NC} $*"; exit 1; }

# --- Pre-flight Checks ---
pre_flight_checks() {
    info "Starting pre-flight checks..."
    if [[ "$(uname -s)" != "Darwin" ]]; then
        error "This script is for macOS only."
    fi

    if ! command -v brew &> /dev/null; then
        error "Homebrew is not installed. Please install it first: https://brew.sh/"
    fi
    success "Pre-flight checks passed."
}

# --- Backup ---
backup_existing_configs() {
    info "Backing up existing configurations to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    
    local configs_to_backup=(
        "$HOME/.config/nvim"
        "$HOME/.config/fish"
        "$HOME/.config/zed"
        "$HOME/.config/yabai"
        "$HOME/.config/skhd"
        "$HOME/.config/sketchybar"
        "$HOME/.config/kitty"
        "$HOME/.config/alacritty"
        "$HOME/.config/ghostty"
        "$HOME/.config/warp"
    )

    for config in "${configs_to_backup[@]}"; do
        if [ -e "$config" ]; then
            info "Backing up $config..."
            mv "$config" "$BACKUP_DIR/"
        fi
    done
    success "Backup complete."
}

# --- Installation ---
install_packages() {
    info "Ensuring Homebrew permissions are correct..."
    # This might prompt for your password
    sudo chown -R $(whoami) $(brew --prefix)
    success "Homebrew permissions set."

    info "Installing packages via Homebrew..."
    
    # Core Utils
    brew install stow fish neovim zed

    # Tiling WM
    brew install koekeishiya/formulae/yabai
    brew install koekeishiya/formulae/skhd

    # Status Bar
    brew install felixkratz/formulae/sketchybar

    # Apps & Terminals
    brew install --cask raycast warp ghostty kitty alacritty

    # Fonts
    brew install --cask font-jetbrains-mono-nerd-font

    success "All packages installed."
}

# --- Configuration Symlinking ---
symlink_configs() {
    info "Symlinking configuration files..."
    
    # Ensure target directories exist
    mkdir -p "$HOME/.config"

    # Using stow to manage symlinks for top-level configs
    stow -d "$REPO_DIR/configs" -t "$HOME/.config" -R nvim fish zed

    # Using stow for nested configs
    stow -d "$REPO_DIR/configs/window-managers" -t "$HOME/.config" -R yabai
    stow -d "$REPO_DIR/configs/status-bars" -t "$HOME/.config" -R sketchybar
    stow -d "$REPO_DIR/configs/terminals" -t "$HOME/.config" -R kitty alacritty ghostty warp
    stow -d "$REPO_DIR/configs/launchers" -t "$HOME/.config" -R raycast

    success "Configuration files symlinked."
}

# --- System & Shell Setup ---
configure_system() {
    info "Configuring system and shell..."

    # Add Fish to list of known shells
    if ! grep -q "$(brew --prefix)/bin/fish" /etc/shells; then
        info "Adding Fish to /etc/shells..."
        echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
    fi

    # Set Fish as the default shell
    local fish_path="$(brew --prefix)/bin/fish"
    if [ "$SHELL" != "$fish_path" ]; then
        info "Setting Fish as the default shell..."
        if chsh -s "$fish_path"; then
            success "Fish shell set as default"
        else
            warning "Failed to set Fish as default shell, you may need to set it manually"
        fi
    else
        success "Fish is already the default shell"
    fi

    # Install Neovim plugins with lazy.nvim
    info "Bootstrapping Neovim plugins..."
    # This command ensures lazy.nvim is bootstrapped and then syncs plugins
    nvim --headless -c "autocmd User LazyDone ++once call Lazy sync" -c "qa"

    success "System and shell configuration complete."
}

# --- Theming ---
apply_default_theme() {
    info "Applying default theme (Catppuccin Macchiato)..."
    "$REPO_DIR/scripts/config/switch-theme.sh" catppuccin-macchiato
    success "Default theme applied."
}

# --- Post-Install ---
create_uninstall_script() {
    info "Creating uninstall script..."
    cat > "$REPO_DIR/uninstall.sh" << EOF
#!/bin/bash
echo "This will uninstall Catred Config and its components."
read -p "Are you sure? (y/n): " -n 1 -r
echo
if [[ ! \$REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

info "Stopping services..."
brew services stop yabai
brew services stop skhd
brew services stop sketchybar

info "Removing symlinks..."
stow -d "$REPO_DIR/configs" -t "$HOME/.config" -D \
    nvim \
    fish \
    zed

stow -d "$REPO_DIR/configs/window-managers" -t "$HOME/.config" -D \
    yabai

stow -d "$REPO_DIR/configs/status-bars" -t "$HOME/.config" -D \
    sketchybar

stow -d "$REPO_DIR/configs/terminals" -t "$HOME/.config" -D \
    kitty \
    alacritty \
    ghostty \
    warp

stow -d "$REPO_DIR/configs/launchers" -t "$HOME/.config" -D \
    raycast

info "Removing catred CLI command..."
sudo rm -f /usr/local/bin/catred

info "Uninstalling packages..."
brew uninstall stow fish neovim zed yabai skhd sketchybar
brew uninstall --cask raycast warp ghostty kitty alacritty font-jetbrains-mono-nerd-font

info "Restoring shell to bash..."
chsh -s /bin/bash

echo "Uninstall complete. You may need to manually restore backups from $BACKUP_DIR"
EOF
    chmod +x "$REPO_DIR/uninstall.sh"
    success "Uninstall script created at $REPO_DIR/uninstall.sh"
}

print_final_instructions() {
    info "Installation is nearly complete. Some manual steps are required:"
    echo "1. Grant Accessibility permissions for yabai and your terminal in System Settings -> Privacy & Security."
    echo "2. Disable SIP (System Integrity Protection) for full yabai functionality (e.g., window animations)."
    echo "   - Reboot into Recovery Mode."
    echo "   - Open Terminal and run: csrutil disable"
    echo "3. Restart your machine to apply all changes, including the default shell."
    success "Setup complete!"
}

# --- CLI Installation ---
install_catred_cli() {
    info "Installing catred CLI command..."
    
    local catred_script="$REPO_DIR/scripts/catred"
    if [[ -f "$catred_script" ]]; then
        chmod +x "$catred_script"
        sudo ln -sf "$catred_script" /usr/local/bin/catred
        success "catred CLI command installed globally"
    else
        warning "catred CLI script not found, skipping CLI installation"
    fi
}

# --- Main Execution ---
main() {
    rm -f "$LOG_FILE"
    info "Starting Catred Config macOS installation..."
    
    pre_flight_checks
    backup_existing_configs
    install_packages
    symlink_configs
    configure_system
    apply_default_theme
    install_catred_cli
    create_uninstall_script
    print_final_instructions

    info "Installation finished! See log at $LOG_FILE"
}

main
