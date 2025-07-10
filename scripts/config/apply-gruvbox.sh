#!/bin/bash
# Apply gruvbox theme across all applications
# This script applies consistent gruvbox theming to all installed applications

set -e

# Colors for output
RED='\033[38;2;204;36;29m'
GREEN='\033[38;2;152;151;26m'
YELLOW='\033[38;2;215;153;33m'
AQUA='\033[38;2;104;157;106m'
NC='\033[0m'

info() { echo -e "${AQUA}🎨 $*${NC}"; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $*${NC}"; }
error() { echo -e "${RED}❌ $*${NC}"; }

# Load gruvbox colors
load_gruvbox_colors() {
    local colors_file="$HOME/catred_config/configs/gruvbox/colors.sh"
    if [[ -f "$colors_file" ]]; then
        source "$colors_file"
        info "Gruvbox colors loaded"
        export GRUVBOX_THEME_LOADED=1
    else
        error "Gruvbox colors file not found: $colors_file"
        exit 1
    fi
}

# Apply themes based on platform
apply_platform_themes() {
    local platform=$(uname -s)
    
    case $platform in
        Darwin)
            apply_macos_themes
            ;;
        Linux)
            apply_linux_themes
            ;;
        CYGWIN*|MINGW*|MSYS*)
            apply_windows_themes
            ;;
        *)
            warning "Unknown platform: $platform"
            ;;
    esac
}

# Apply macOS-specific themes
apply_macos_themes() {
    info "Applying gruvbox themes for macOS..."
    
    # Reload SketchyBar
    if command -v sketchybar &> /dev/null; then
        sketchybar --reload
        success "SketchyBar theme reloaded"
    fi
    
    # Restart yabai to apply border colors
    if command -v yabai &> /dev/null; then
        yabai --restart-service
        success "yabai restarted with new colors"
    fi
    
    # Apply Warp theme
    apply_warp_theme
    
    # Apply kitty theme if installed
    apply_kitty_theme
    
    # Apply alacritty theme if installed
    apply_alacritty_theme
    
    # Apply ghostty theme if installed
    apply_ghostty_theme
}

# Apply Linux-specific themes
apply_linux_themes() {
    info "Applying gruvbox themes for Linux..."
    
    # Reload polybar
    if [[ -f ~/.config/polybar/launch.sh ]]; then
        ~/.config/polybar/launch.sh &
        success "Polybar reloaded with gruvbox theme"
    fi
    
    # Reload i3/sway
    if pgrep -x "i3" > /dev/null; then
        i3-msg reload
        success "i3 configuration reloaded"
    elif pgrep -x "sway" > /dev/null; then
        swaymsg reload
        success "sway configuration reloaded"
    fi
    
    # Apply terminal themes
    apply_warp_theme
    apply_kitty_theme
    apply_alacritty_theme
    apply_ghostty_theme
    
    # Update Xresources if it exists
    if [[ -f ~/.Xresources ]] && command -v xrdb &> /dev/null; then
        xrdb ~/.Xresources
        success "Xresources updated"
    fi
    
    # Apply GTK theme if available
    apply_gtk_theme
}

# Apply Windows-specific themes
apply_windows_themes() {
    info "Applying gruvbox themes for Windows..."
    
    # Restart yasb
    if tasklist /FI "IMAGENAME eq yasb.exe" 2>NUL | find /I /N "yasb.exe" > /dev/null; then
        taskkill /f /im yasb.exe 2>/dev/null || true
        start /b yasb
        success "yasb restarted with gruvbox theme"
    fi
    
    # Reload komorebi
    if command -v komorebic &> /dev/null; then
        komorebic reload-configuration
        success "komorebi configuration reloaded"
    fi
    
    # Apply terminal themes
    apply_warp_theme
    apply_ghostty_theme
}

# Apply Warp terminal theme
apply_warp_theme() {
    local warp_theme_dir
    case $(uname -s) in
        Darwin)
            warp_theme_dir="$HOME/.warp/themes"
            ;;
        Linux)
            warp_theme_dir="$HOME/.local/share/warp-terminal/themes"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            warp_theme_dir="$HOME/.warp/themes"
            ;;
    esac
    
    if [[ -n "$warp_theme_dir" ]]; then
        mkdir -p "$warp_theme_dir"
        local source_theme="$HOME/catred_config/configs/terminals/warp/gruvbox-dark.yaml"
        if [[ -f "$source_theme" ]]; then
            cp "$source_theme" "$warp_theme_dir/"
            success "Warp gruvbox theme applied"
        fi
    fi
}

# Apply kitty theme
apply_kitty_theme() {
    if command -v kitty &> /dev/null; then
        local kitty_config="$HOME/.config/kitty/gruvbox-dark.conf"
        local source_config="$HOME/catred_config/configs/terminals/kitty/gruvbox-dark.conf"
        
        if [[ -f "$source_config" ]]; then
            mkdir -p "$(dirname "$kitty_config")"
            cp "$source_config" "$kitty_config"
            
            # Try to reload kitty if it's running
            if pgrep -x "kitty" > /dev/null; then
                kitty @ set-colors "$kitty_config" 2>/dev/null || true
            fi
            
            success "kitty gruvbox theme applied"
        fi
    fi
}

# Apply alacritty theme
apply_alacritty_theme() {
    if command -v alacritty &> /dev/null; then
        local alacritty_config="$HOME/.config/alacritty/gruvbox-dark.yml"
        local source_config="$HOME/catred_config/configs/terminals/alacritty/gruvbox-dark.yml"
        
        if [[ -f "$source_config" ]]; then
            mkdir -p "$(dirname "$alacritty_config")"
            cp "$source_config" "$alacritty_config"
            success "alacritty gruvbox theme applied"
        fi
    fi
}

# Apply ghostty theme
apply_ghostty_theme() {
    if command -v ghostty &> /dev/null; then
        local ghostty_config_dir="$HOME/.config/ghostty"
        local source_config="$HOME/catred_config/configs/terminals/ghostty/gruvbox-dark.config"
        
        if [[ -f "$source_config" ]]; then
            mkdir -p "$ghostty_config_dir"
            cp "$source_config" "$ghostty_config_dir/config"
            success "ghostty gruvbox theme applied"
        fi
    fi
}

# Apply GTK theme (Linux only)
apply_gtk_theme() {
    if command -v gsettings &> /dev/null; then
        # Check if gruvbox GTK theme is installed
        local gtk_theme_dir="/usr/share/themes/Gruvbox-Dark-BL"
        if [[ -d "$gtk_theme_dir" ]]; then
            gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark-BL' 2>/dev/null || true
            gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Dark' 2>/dev/null || true
            success "GTK gruvbox theme applied"
        else
            info "GTK gruvbox theme not installed, skipping"
        fi
    fi
}

# Apply rofi theme
apply_rofi_theme() {
    if command -v rofi &> /dev/null; then
        local rofi_theme_dir="$HOME/.config/rofi"
        local source_theme="$HOME/catred_config/configs/launchers/rofi/gruvbox-dark.rasi"
        
        if [[ -f "$source_theme" ]]; then
            mkdir -p "$rofi_theme_dir"
            cp "$source_theme" "$rofi_theme_dir/"
            success "rofi gruvbox theme applied"
        fi
    fi
}

# Apply dunst theme (Linux only)
apply_dunst_theme() {
    if command -v dunst &> /dev/null; then
        local dunst_config="$HOME/.config/dunst/dunstrc"
        local source_config="$HOME/catred_config/configs/dunst/gruvbox-dunstrc"
        
        if [[ -f "$source_config" ]]; then
            mkdir -p "$(dirname "$dunst_config")"
            cp "$source_config" "$dunst_config"
            
            # Restart dunst if running
            if pgrep -x "dunst" > /dev/null; then
                killall dunst 2>/dev/null || true
                dunst &
            fi
            
            success "dunst gruvbox theme applied"
        fi
    fi
}

# Validate theme application
validate_themes() {
    info "Validating theme application..."
    
    local validation_passed=true
    
    # Check if gruvbox colors are loaded
    if [[ "$GRUVBOX_THEME_LOADED" != "1" ]]; then
        error "Gruvbox colors not loaded"
        validation_passed=false
    fi
    
    # Check terminal themes
    local warp_theme_applied=false
    case $(uname -s) in
        Darwin)
            [[ -f "$HOME/.warp/themes/gruvbox-dark.yaml" ]] && warp_theme_applied=true
            ;;
        Linux)
            [[ -f "$HOME/.local/share/warp-terminal/themes/gruvbox-dark.yaml" ]] && warp_theme_applied=true
            ;;
        CYGWIN*|MINGW*|MSYS*)
            [[ -f "$HOME/.warp/themes/gruvbox-dark.yaml" ]] && warp_theme_applied=true
            ;;
    esac
    
    if $warp_theme_applied; then
        success "Warp theme validation passed"
    else
        warning "Warp theme may not be applied"
    fi
    
    # Check kitty theme
    if [[ -f "$HOME/.config/kitty/gruvbox-dark.conf" ]]; then
        success "kitty theme validation passed"
    fi
    
    # Check alacritty theme
    if [[ -f "$HOME/.config/alacritty/gruvbox-dark.yml" ]]; then
        success "alacritty theme validation passed"
    fi
    
    # Check ghostty theme
    if [[ -f "$HOME/.config/ghostty/config" ]]; then
        success "ghostty theme validation passed"
    fi
    
    if $validation_passed; then
        success "Theme validation completed successfully"
        return 0
    else
        warning "Some theme validations failed"
        return 1
    fi
}

# Create theme switching script
create_theme_switcher() {
    info "Creating theme switcher script..."
    
    cat > ~/.config/scripts/switch-theme.sh << 'EOF'
#!/bin/bash
# Theme switcher script

THEME=${1:-gruvbox-dark}
CONFIG_DIR="$HOME/catred_config"

case $THEME in
    gruvbox-dark)
        source "$CONFIG_DIR/configs/gruvbox/colors.sh"
        echo "Switched to Gruvbox Dark theme"
        ;;
    gruvbox-light)
        echo "Gruvbox Light theme not yet implemented"
        exit 1
        ;;
    *)
        echo "Unknown theme: $THEME"
        echo "Available themes: gruvbox-dark"
        exit 1
        ;;
esac

# Apply the theme
bash "$CONFIG_DIR/scripts/config/apply-gruvbox.sh"
EOF
    
    chmod +x ~/.config/scripts/switch-theme.sh
    
    success "Theme switcher created at ~/.config/scripts/switch-theme.sh"
}

# Print completion message
print_completion_message() {
    echo ""
    echo -e "${GREEN}🎉 Gruvbox Theme Application Complete!${NC}"
    echo ""
    echo -e "${YELLOW}What was applied:${NC}"
    echo -e "${AQUA}• Window manager colors and borders${NC}"
    echo -e "${AQUA}• Status bar themes${NC}"
    echo -e "${AQUA}• Terminal themes (Warp, kitty, alacritty, ghostty)${NC}"
    echo -e "${AQUA}• Application launcher themes${NC}"
    echo -e "${AQUA}• System notification themes${NC}"
    echo ""
    echo -e "${YELLOW}To apply themes to new applications:${NC}"
    echo -e "${AQUA}• Run this script again: ./apply-gruvbox.sh${NC}"
    echo -e "${AQUA}• Use theme switcher: ~/.config/scripts/switch-theme.sh${NC}"
    echo ""
    echo -e "${YELLOW}Manual theme selection:${NC}"
    echo -e "${AQUA}• Warp: Select 'Gruvbox Dark' in settings${NC}"
    echo -e "${AQUA}• Flow Launcher: Select 'Gruvbox Dark' theme${NC}"
    echo -e "${AQUA}• Raycast: Import gruvbox theme extension${NC}"
    echo ""
}

# Main function
main() {
    echo "🎨 Gruvbox Theme Application"
    echo "=========================="
    
    load_gruvbox_colors
    apply_platform_themes
    apply_rofi_theme
    apply_dunst_theme
    
    if validate_themes; then
        create_theme_switcher
        print_completion_message
        success "Gruvbox themes applied successfully!"
    else
        warning "Theme application completed with some issues"
        info "Check the output above for any missing themes"
    fi
}

main "$@"