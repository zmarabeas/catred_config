#!/bin/bash
# Unified Theme Switching System
# Changes theme across all components: terminals, editors, window managers, status bars, etc.

set -e

# CI environment detection
CI_MODE=false
if [[ -n "$CI" || -n "$GITHUB_ACTIONS" || -n "$TRAVIS" || -n "$CIRCLECI" || -n "$JENKINS_URL" ]]; then
    CI_MODE=true
fi

# Colors for output (disabled in CI for better parsing)
if [[ "$CI_MODE" == "true" ]]; then
    RED=''
    GREEN=''
    YELLOW=''
    AQUA=''
    NC=''
else
    RED='\033[38;2;204;36;29m'
    GREEN='\033[38;2;152;151;26m'
    YELLOW='\033[38;2;215;153;33m'
    AQUA='\033[38;2;104;157;106m'
    NC='\033[0m'
fi

info() { echo -e "${AQUA}INFO:${NC} $*"; }
success() { echo -e "${GREEN}SUCCESS:${NC} $*"; }
warning() { echo -e "${YELLOW}WARNING:${NC} $*"; }
error() { echo -e "${RED}ERROR:${NC} $*"; }

# Configuration - detect the correct config directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Use repository directory for configs when in CI or when running from repo
if [[ "$CI_MODE" == "true" ]] || [[ -d "$REPO_DIR/configs" ]]; then
    CONFIG_DIR="$REPO_DIR"
    THEME_DIR="$CONFIG_DIR/configs"
else
    CONFIG_DIR="$HOME/catred_config"
    THEME_DIR="$CONFIG_DIR/configs"
fi

CURRENT_THEME_FILE="$HOME/.config/catred_config/current_theme"
AVAILABLE_THEMES=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")

# Ensure config directory exists
mkdir -p "$(dirname "$CURRENT_THEME_FILE")"

# Function to display usage
usage() {
    echo "Usage: $0 [THEME_NAME]"
    echo ""
    echo "Available themes:"
    for theme in "${AVAILABLE_THEMES[@]}"; do
        echo "  - $theme"
    done
    echo ""
    echo "If no theme is specified, shows current theme and available options."
}

# Function to get current theme
get_current_theme() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "catppuccin-macchiato"
    fi
}

# Function to validate theme
validate_theme() {
    local theme="$1"
    for available_theme in "${AVAILABLE_THEMES[@]}"; do
        if [[ "$theme" == "$available_theme" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to apply terminal themes
apply_terminal_themes() {
    local theme="$1"
    info "Applying terminal themes for $theme..."
    
    # Ghostty
    if command -v ghostty &> /dev/null; then
        local ghostty_config="$HOME/.config/ghostty/config"
        local ghostty_theme="$THEME_DIR/terminals/ghostty/$theme.config"
        if [[ -f "$ghostty_theme" ]]; then
            mkdir -p "$(dirname "$ghostty_config")"
            cp "$ghostty_theme" "$ghostty_config"
            success "Ghostty theme applied"
        fi
    fi
    
    # Warp
    local warp_theme_dir
    case $(uname -s) in
        Darwin)
            warp_theme_dir="$HOME/.warp/themes"
            ;;
        Linux)
            warp_theme_dir="$HOME/.local/share/warp-terminal/themes"
            ;;
        *)
            warp_theme_dir="$HOME/.warp/themes"
            ;;
    esac
    
    if [[ -n "$warp_theme_dir" ]]; then
        local warp_theme="$THEME_DIR/terminals/warp/$theme.yaml"
        if [[ -f "$warp_theme" ]]; then
            mkdir -p "$warp_theme_dir"
            cp "$warp_theme" "$warp_theme_dir/"
            success "Warp theme applied"
        fi
    fi
    
    # Kitty
    if command -v kitty &> /dev/null; then
        local kitty_config="$HOME/.config/kitty/kitty.conf"
        local kitty_theme="$THEME_DIR/terminals/kitty/$theme.conf"
        if [[ -f "$kitty_theme" ]]; then
            mkdir -p "$(dirname "$kitty_config")"
            cp "$kitty_theme" "$kitty_config"
            # Try to reload kitty if it's running
            if pgrep -x "kitty" > /dev/null; then
                kitty @ set-colors "$kitty_config" 2>/dev/null || true
            fi
            success "Kitty theme applied"
        fi
    fi
    
    # Alacritty
    if command -v alacritty &> /dev/null; then
        local alacritty_config="$HOME/.config/alacritty/alacritty.yml"
        local alacritty_theme="$THEME_DIR/terminals/alacritty/$theme.yml"
        if [[ -f "$alacritty_theme" ]]; then
            mkdir -p "$(dirname "$alacritty_config")"
            cp "$alacritty_theme" "$alacritty_config"
            success "Alacritty theme applied"
        fi
    fi
}

# Function to apply editor themes
apply_editor_themes() {
    local theme="$1"
    info "Applying editor themes for $theme..."
    
    # Neovim theme switching
    if command -v nvim &> /dev/null; then
        local nvim_theme_cmd
        case $theme in
            "catppuccin-macchiato")
                nvim_theme_cmd="colorscheme catppuccin-macchiato"
                ;;
            "gruvbox")
                nvim_theme_cmd="colorscheme gruvbox"
                ;;
            "tokyo-night-storm")
                nvim_theme_cmd="colorscheme tokyonight-storm"
                ;;
        esac
        
        if [[ -n "$nvim_theme_cmd" ]]; then
            # Create theme file for Neovim
            local nvim_config="$HOME/.config/nvim/lua/current_theme.lua"
            mkdir -p "$(dirname "$nvim_config")"
            cat > "$nvim_config" << EOF
-- Auto-generated theme file
-- This file is created by the theme switcher

vim.cmd("$nvim_theme_cmd")
EOF
            success "Neovim theme configured"
        fi
    fi
    
    # Zed theme switching
    if command -v zed &> /dev/null; then
        local zed_settings="$HOME/.config/zed/settings.json"
        if [[ -f "$zed_settings" ]]; then
            local zed_theme
            case $theme in
                "catppuccin-macchiato")
                    zed_theme="Catppuccin Macchiato"
                    ;;
                "gruvbox")
                    zed_theme="Gruvbox Dark Hard"
                    ;;
                "tokyo-night-storm")
                    zed_theme="Tokyo Night Storm"
                    ;;
            esac
            
            if [[ -n "$zed_theme" ]]; then
                # Update theme in settings.json
                if command -v jq &> /dev/null; then
                    local temp_file=$(mktemp)
                    jq --arg theme "$zed_theme" '.theme = $theme' "$zed_settings" > "$temp_file"
                    mv "$temp_file" "$zed_settings"
                    success "Zed theme configured"
                else
                    warning "jq not found, skipping Zed theme update"
                fi
            fi
        fi
    fi
}

# Function to apply window manager themes
apply_window_manager_themes() {
    local theme="$1"
    info "Applying window manager themes for $theme..."
    
    case $(uname -s) in
        Darwin)
            # macOS - yabai
            if command -v yabai &> /dev/null; then
                # Restart yabai to reload config with new theme
                yabai --restart-service 2>/dev/null || true
                success "yabai restarted with new theme"
            fi
            ;;
        Linux)
            # Linux - i3/sway
            if pgrep -x "i3" > /dev/null; then
                i3-msg reload 2>/dev/null || true
                success "i3 configuration reloaded"
            elif pgrep -x "sway" > /dev/null; then
                swaymsg reload 2>/dev/null || true
                success "sway configuration reloaded"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            # Windows - komorebi
            if command -v komorebic &> /dev/null; then
                komorebic reload-configuration 2>/dev/null || true
                success "komorebi configuration reloaded"
            fi
            ;;
    esac
}

# Function to apply status bar themes
apply_status_bar_themes() {
    local theme="$1"
    info "Applying status bar themes for $theme..."
    
    case $(uname -s) in
        Darwin)
            # macOS - SketchyBar
            if command -v sketchybar &> /dev/null; then
                sketchybar --reload 2>/dev/null || true
                success "SketchyBar reloaded with new theme"
            fi
            ;;
        Linux)
            # Linux - polybar
            if command -v polybar &> /dev/null && [[ -f ~/.config/polybar/launch.sh ]]; then
                ~/.config/polybar/launch.sh & 2>/dev/null || true
                success "Polybar reloaded with new theme"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            # Windows - yasb
            if tasklist /FI "IMAGENAME eq yasb.exe" 2>NUL | find /I /N "yasb.exe" > /dev/null; then
                taskkill /f /im yasb.exe 2>/dev/null || true
                start /b yasb 2>/dev/null || true
                success "yasb restarted with new theme"
            fi
            ;;
    esac
}

# Function to apply fish shell theme
apply_fish_theme() {
    local theme="$1"
    info "Applying Fish shell theme for $theme..."
    
    if command -v fish &> /dev/null; then
        # Fish will automatically load the theme on next startup
        # based on the current_theme file
        success "Fish theme will be applied on next shell startup"
    fi
}

# Function to apply all themes
apply_all_themes() {
    local theme="$1"
    
    info "Switching to theme: $theme"
    
    # Save current theme
    echo "$theme" > "$CURRENT_THEME_FILE"
    
    # Apply themes to all components
    apply_terminal_themes "$theme"
    apply_editor_themes "$theme"
    apply_window_manager_themes "$theme"
    apply_status_bar_themes "$theme"
    apply_fish_theme "$theme"
    
    success "Theme switched to $theme successfully!"
    info "Some changes may require restarting applications or opening new terminals."
}

# Main function
main() {
    local theme=""
    
    # Parse arguments
    case $# in
        0)
            # Show current theme and available options
            local current_theme=$(get_current_theme)
            echo "Current theme: $current_theme"
            echo ""
            echo "Available themes:"
            for available_theme in "${AVAILABLE_THEMES[@]}"; do
                if [[ "$available_theme" == "$current_theme" ]]; then
                    echo "  * $available_theme (current)"
                else
                    echo "  - $available_theme"
                fi
            done
            echo ""
            echo "Usage: $0 [THEME_NAME]"
            return 0
            ;;
        1)
            theme="$1"
            ;;
        *)
            usage
            return 1
            ;;
    esac
    
    # Validate theme
    if ! validate_theme "$theme"; then
        error "Invalid theme: $theme"
        echo ""
        usage
        return 1
    fi
    
    # Apply the theme
    apply_all_themes "$theme"
}

# Run main function
main "$@"