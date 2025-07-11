#!/bin/bash
#
# Unit tests for configuration completeness
#

# Disable errexit for test scripts
set +e

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
CONFIGS_DIR="$REPO_DIR/configs"

# --- Test Functions ---

# Test that all major application configs exist
test_editor_configs_exist() {
    # Neovim config
    assert_file_exists "$CONFIGS_DIR/nvim/init.lua" "Neovim init.lua should exist"
    
    # Zed config
    assert_file_exists "$CONFIGS_DIR/zed/settings.json" "Zed settings.json should exist"
    
    return 0
}

test_shell_configs_exist() {
    # Fish shell config
    assert_file_exists "$CONFIGS_DIR/fish/config.fish" "Fish config.fish should exist"
    
    # Fish themes
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    for theme in "${themes[@]}"; do
        assert_file_exists "$CONFIGS_DIR/fish/themes/$theme.fish" "Fish theme $theme should exist"
    done
    
    return 0
}

test_terminal_configs_exist() {
    local terminals=("kitty" "alacritty" "ghostty" "warp")
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for terminal in "${terminals[@]}"; do
        local found_config=false
        for theme in "${themes[@]}"; do
            # Check various possible extensions
            for ext in conf yml yaml config; do
                if [[ -f "$CONFIGS_DIR/terminals/$terminal/$theme.$ext" ]]; then
                    found_config=true
                    break 2
                fi
            done
        done
        
        if [[ "$found_config" == "false" ]]; then
            fail "No theme configs found for $terminal"
            return 1
        fi
    done
    
    return 0
}

test_window_manager_configs_exist() {
    # macOS - yabai
    if [[ -d "$CONFIGS_DIR/window-managers/yabai" ]]; then
        assert_file_exists "$CONFIGS_DIR/window-managers/yabai/yabairc" "yabairc should exist"
        assert_file_exists "$CONFIGS_DIR/window-managers/yabai/skhdrc" "skhdrc should exist"
    fi
    
    # Linux - i3/sway
    if [[ -d "$CONFIGS_DIR/window-managers/i3" ]]; then
        assert_file_exists "$CONFIGS_DIR/window-managers/i3/config" "i3 config should exist"
    fi
    
    if [[ -d "$CONFIGS_DIR/window-managers/sway" ]]; then
        assert_file_exists "$CONFIGS_DIR/window-managers/sway/config" "sway config should exist"
    fi
    
    return 0
}

test_status_bar_configs_exist() {
    # macOS - SketchyBar
    if [[ -d "$CONFIGS_DIR/status-bars/sketchybar" ]]; then
        assert_file_exists "$CONFIGS_DIR/status-bars/sketchybar/sketchybarrc" "sketchybarrc should exist"
    fi
    
    # Linux - polybar
    if [[ -d "$CONFIGS_DIR/status-bars/polybar" ]]; then
        assert_file_exists "$CONFIGS_DIR/status-bars/polybar/config.ini" "polybar config should exist"
    fi
    
    return 0
}

test_launcher_configs_exist() {
    # macOS - Raycast
    if [[ -d "$CONFIGS_DIR/launchers/raycast" ]]; then
        local found_config=false
        # Raycast might have various config files
        if [[ -n "$(ls -A "$CONFIGS_DIR/launchers/raycast" 2>/dev/null)" ]]; then
            found_config=true
        fi
        
        if [[ "$found_config" == "false" ]]; then
            warn "Raycast config directory is empty"
        fi
    fi
    
    # Linux - rofi
    if [[ -d "$CONFIGS_DIR/launchers/rofi" ]]; then
        assert_file_exists "$CONFIGS_DIR/launchers/rofi/config.rasi" "rofi config should exist"
    fi
    
    return 0
}

test_theme_color_definitions() {
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for theme in "${themes[@]}"; do
        assert_file_exists "$CONFIGS_DIR/$theme/colors.yaml" "Color definition for $theme should exist"
    done
    
    return 0
}

test_config_consistency() {
    # Check that configs don't contain hardcoded paths
    local config_files
    config_files=$(find "$CONFIGS_DIR" -type f -name "*.lua" -o -name "*.vim" -o -name "*.fish" -o -name "*.sh" 2>/dev/null)
    
    local issues_found=false
    while IFS= read -r file; do
        if [[ -n "$file" ]] && grep -q "/Users/[^/]*/\|/home/[^/]*/" "$file" 2>/dev/null; then
            warn "Config file contains hardcoded home path: $file"
            issues_found=true
        fi
    done <<< "$config_files"
    
    if [[ "$issues_found" == "true" ]]; then
        warn "Some config files contain hardcoded paths"
    fi
    
    return 0
}

test_executable_scripts() {
    # Check that all shell scripts are executable
    local scripts
    scripts=$(find "$REPO_DIR/scripts" -name "*.sh" -type f 2>/dev/null)
    
    local non_executable_found=false
    while IFS= read -r script; do
        if [[ -n "$script" ]] && [[ ! -x "$script" ]]; then
            fail "Script is not executable: $script"
            non_executable_found=true
        fi
    done <<< "$scripts"
    
    if [[ "$non_executable_found" == "true" ]]; then
        return 1
    fi
    
    return 0
}

test_symlink_structure() {
    # Test that configs are organized for proper stow usage
    # Stow expects the structure to mirror the target directory structure
    
    # Check nvim structure
    if [[ -d "$CONFIGS_DIR/nvim" ]]; then
        if [[ ! -f "$CONFIGS_DIR/nvim/init.lua" ]] && [[ ! -d "$CONFIGS_DIR/nvim/lua" ]]; then
            fail "Neovim config not properly structured for stow"
            return 1
        fi
    fi
    
    # Check fish structure  
    if [[ -d "$CONFIGS_DIR/fish" ]]; then
        if [[ ! -f "$CONFIGS_DIR/fish/config.fish" ]] && [[ ! -d "$CONFIGS_DIR/fish/functions" ]]; then
            fail "Fish config not properly structured for stow"
            return 1
        fi
    fi
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "editor_configs_exist" test_editor_configs_exist "Editor configurations exist"
run_test "shell_configs_exist" test_shell_configs_exist "Shell configurations exist"
run_test "terminal_configs_exist" test_terminal_configs_exist "Terminal configurations exist"
run_test "window_manager_configs_exist" test_window_manager_configs_exist "Window manager configurations exist"
run_test "status_bar_configs_exist" test_status_bar_configs_exist "Status bar configurations exist"
run_test "launcher_configs_exist" test_launcher_configs_exist "Launcher configurations exist"
run_test "theme_color_definitions" test_theme_color_definitions "Theme color definitions exist"
run_test "config_consistency" test_config_consistency "Configurations are consistent"
run_test "executable_scripts" test_executable_scripts "All scripts are executable"
run_test "symlink_structure" test_symlink_structure "Config structure is suitable for stow"

info "Unit tests for configuration completeness completed"

# Exit with success - individual test functions handle their own failures
exit 0