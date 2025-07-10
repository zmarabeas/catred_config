#!/bin/bash
#
# Catred Config - System Health Check
#
# This script validates the entire development environment to ensure all
# components are installed and configured correctly.
#

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../.. && pwd)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Counters
PASS_COUNT=0
FAIL_COUNT=0

# Check function
check() {
    local description="$1"
    local command_to_run="$2"
    
    printf "%-60s" "$description"
    if bash -c "$command_to_run" &> /dev/null; then
        echo -e "[${GREEN}PASS${NC}]"
        ((PASS_COUNT++))
    else
        echo -e "[${RED}FAIL${NC}]"
        ((FAIL_COUNT++))
    fi
}

# --- Checks by Category ---
run_cli_checks() {
    echo "--- Checking Core CLI Tools ---"
    check "Neovim (nvim) is installed" "command -v nvim"
    check "Fish shell (fish) is installed" "command -v fish"
    check "Zed editor (zed) is installed" "command -v zed"
    check "Stow (stow) is installed" "command -v stow"
}

run_symlink_checks() {
    echo "--- Checking Configuration Symlinks ---"
    
    # Check key configuration files/directories
    check "Neovim init.lua is symlinked" "[ -L \"$HOME/.config/init.lua\" ] || [ -L \"$HOME/.config/nvim\" ]"
    check "Fish config.fish is symlinked" "[ -L \"$HOME/.config/config.fish\" ] || [ -L \"$HOME/.config/fish\" ]"
    check "Zed settings.json is symlinked" "[ -L \"$HOME/.config/settings.json\" ] || [ -L \"$HOME/.config/zed\" ]"
    check "Kitty theme files exist" "[ -f \"$HOME/.config/kitty/kitty.conf\" ] || [ -L \"$HOME/.config/kitty\" ]"
    check "Alacritty theme files exist" "[ -f \"$HOME/.config/alacritty/alacritty.yml\" ] || [ -L \"$HOME/.config/alacritty\" ]"
    check "Ghostty theme files exist" "[ -f \"$HOME/.config/ghostty/config\" ] || [ -L \"$HOME/.config/ghostty\" ]"
}

run_theme_checks() {
    echo "--- Checking Theme System ---"
    check "Theme switch script is executable" "[ -x \"$REPO_DIR/scripts/config/switch-theme.sh\" ]"
    check "Current theme file exists" "[ -f \"$HOME/.config/catred_config/current_theme\" ]"
}

run_platform_specific_checks() {
    local os
    os="$(uname -s)"
    echo "--- Checking Platform-Specific Components ($os) ---"

    case "$os" in
        Darwin*)
            check "Yabai (yabai) is installed" "command -v yabai"
            check "skhd (skhd) is installed" "command -v skhd"
            check "SketchyBar (sketchybar) is installed" "command -v sketchybar"
            check "Raycast.app exists" "[ -d \"/Applications/Raycast.app\" ]"
            ;;
        Linux*)
            check "i3 or sway is installed" "command -v i3 || command -v sway"
            check "Polybar is installed" "command -v polybar"
            check "Rofi is installed" "command -v rofi"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            check "Komorebi (komorebic.exe) is installed" "command -v komorebic.exe"
            check "whkd (whkd.exe) is installed" "command -v whkd.exe"
            ;;
    esac
}

# --- Main Execution ---
main() {
    echo "Running Catred Config Health Check..."
    echo "======================================"
    
    run_cli_checks
    run_symlink_checks
    run_theme_checks
    run_platform_specific_checks

    echo "======================================"
    echo "Health Check Summary:"
    echo -e "  ${GREEN}Passed: $PASS_COUNT${NC}"
    echo -e "  ${RED}Failed: $FAIL_COUNT${NC}"

    if [ $FAIL_COUNT -ne 0 ]; then
        echo "Some checks failed. Please review the output above and run the appropriate installation script."
        exit $FAIL_COUNT # exit.*FAIL_COUNT
    fi

    echo "System health check passed successfully!"
}

main
