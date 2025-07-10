#!/bin/bash
#
# Comprehensive Linux Installation Script for Catred Config
#
# This script bootstraps a complete, themed development environment on a fresh
# Linux system. It handles:
#   - Backups of existing configurations
#   - Detection of the Linux distribution (Debian/Fedora/Arch)
#   - Installation of all applications, CLIs, and fonts via the native package manager
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
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m

# Logging functions
log() { echo -e "$*" | tee -a "$LOG_FILE"; }
info() { log "${BLUE}INFO:${NC} $*"; }
success() { log "${GREEN}SUCCESS:${NC} $*"; }
warning() { log "${YELLOW}WARNING:${NC} $*"; }
error() { log "${RED}ERROR:${NC} $*"; exit 1; }

# --- Pre-flight & Distro Detection ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                echo "debian"
                ;;
            fedora)
                echo "fedora"
                ;;
            arch)
                echo "arch"
                ;;
            *)
                error "Unsupported Linux distribution: $ID"
                ;;
        esac
    else
        error "Cannot detect Linux distribution."
    fi
}

# --- Backup ---
backup_existing_configs() {
    info "Backing up existing configurations to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    
    local configs_to_backup=(
        "$HOME/.config/nvim"
        "$HOME/.config/fish"
        "$HOME/.config/zed"
        "$HOME/.config/i3"
        "$HOME/.config/sway"
        "$HOME/.config/polybar"
        "$HOME/.config/rofi"
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
    local distro=$1
    info "Installing packages for $distro..."

    case "$distro" in
        debian)
            sudo apt update
            sudo apt install -y stow fish neovim i3 sway polybar rofi kitty alacritty curl wget unzip fontconfig
            # Zed, Ghostty, Warp are installed via other methods
            ;;
        fedora)
            sudo dnf install -y stow fish neovim i3 sway polybar rofi kitty alacritty curl wget unzip fontconfig
            ;;
        arch)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm stow fish neovim i3 sway polybar rofi kitty alacritty curl wget unzip fontconfig
            ;;
    esac

    # Install Zed
    info "Installing Zed editor..."
    curl -fL https://zed.dev/install.sh | sh

    # Install Nerd Fonts
    info "Installing JetBrains Mono Nerd Font..."
    curl -fLo "/tmp/JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    sudo unzip -o /tmp/JetBrainsMono.zip -d /usr/local/share/fonts
    sudo fc-cache -fv
    rm /tmp/JetBrainsMono.zip

    success "All packages installed."
}

# --- Configuration Symlinking ---
symlink_configs() {
    info "Symlinking configuration files..."
    mkdir -p "$HOME/.config"
    stow -d "$REPO_DIR/configs" -t "$HOME/.config" -R nvim fish zed i3 sway polybar rofi kitty alacritty ghostty warp
    success "Configuration files symlinked."
}

# --- System & Shell Setup ---
configure_system() {
    info "Configuring system and shell..."

    # Set Fish as the default shell
    if [ "$SHELL" != "/usr/bin/fish" ] && [ -f /usr/bin/fish ]; then
        info "Setting Fish as the default shell..."
        chsh -s /usr/bin/fish
    fi

    # Install Neovim plugins
    info "Bootstrapping Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa

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

info "Removing symlinks..."
stow -d "$REPO_DIR/configs" -t "$HOME/.config" -D nvim fish zed i3 sway polybar rofi kitty alacritty ghostty warp

info "Removing catred CLI command..."
sudo rm -f /usr/local/bin/catred

info "Uninstalling packages..."
# This part is distro-specific and may need manual adjustment
if command -v apt &> /dev/null; then
    sudo apt remove -y stow fish neovim i3 sway polybar rofi kitty alacritty
elif command -v dnf &> /dev/null; then
    sudo dnf remove -y stow fish neovim i3 sway polybar rofi kitty alacritty
elif command -v pacman &> /dev/null; then
    sudo pacman -Rns --noconfirm stow fish neovim i3 sway polybar rofi kitty alacritty
fi

info "Restoring shell to bash..."
chsh -s /bin/bash

echo "Uninstall complete. You may need to manually restore backups from $BACKUP_DIR"
EOF
    chmod +x "$REPO_DIR/uninstall.sh"
    success "Uninstall script created at $REPO_DIR/uninstall.sh"
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

print_final_instructions() {
    info "Installation complete!"
    echo "Please log out and log back in to apply the new shell and start the window manager."
    echo "Select 'i3' or 'sway' from your login manager."
    success "Setup complete!"
}

# --- Main Execution ---
main() {
    rm -f "$LOG_FILE"
    info "Starting Catred Config Linux installation..."
    
    local distro
    distro=$(detect_distro)
    
    backup_existing_configs
    install_packages "$distro"
    symlink_configs
    configure_system
    apply_default_theme
    install_catred_cli
    create_uninstall_script
    print_final_instructions

    info "Installation finished! See log at $LOG_FILE"
}

main
