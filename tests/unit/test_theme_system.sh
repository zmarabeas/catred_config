#!/bin/bash
#
# Unit tests for the theme system
#

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
THEME_SCRIPT="$REPO_DIR/scripts/config/switch-theme.sh"
THEME_DIR="$REPO_DIR/configs"

# --- Test Functions ---

test_theme_script_exists() {
    assert_file_exists "$THEME_SCRIPT" "Theme switch script should exist"
}

test_theme_script_executable() {
    if [[ -x "$THEME_SCRIPT" ]]; then
        return 0
    else
        fail "Theme switch script should be executable"
        return 1
    fi
}

test_theme_directories_exist() {
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for theme in "${themes[@]}"; do
        local theme_dir="$THEME_DIR/$theme"
        if [[ ! -d "$theme_dir" ]]; then
            fail "Theme directory should exist: $theme_dir"
            return 1
        fi
    done
    
    return 0
}

test_theme_color_files_exist() {
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for theme in "${themes[@]}"; do
        local color_file="$THEME_DIR/$theme/colors.yaml"
        if [[ ! -f "$color_file" ]]; then
            fail "Color file should exist: $color_file"
            return 1
        fi
    done
    
    return 0
}

test_theme_script_no_args() {
    local output
    output=$("$THEME_SCRIPT" 2>&1)
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        assert_contains "$output" "Current theme:" "Should show current theme"
        assert_contains "$output" "Available themes:" "Should show available themes"
        assert_contains "$output" "catppuccin-macchiato" "Should list catppuccin theme"
        assert_contains "$output" "gruvbox" "Should list gruvbox theme"
        assert_contains "$output" "tokyo-night-storm" "Should list tokyo-night theme"
        return 0
    else
        fail "Theme script should succeed with no arguments"
        return 1
    fi
}

test_theme_script_invalid_theme() {
    local output
    output=$("$THEME_SCRIPT" invalid_theme 2>&1)
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]]; then
        assert_contains "$output" "Invalid theme" "Should show error for invalid theme"
        return 0
    else
        fail "Theme script should fail with invalid theme"
        return 1
    fi
}

test_terminal_config_files_exist() {
    local terminals=("kitty" "alacritty" "ghostty" "warp")
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for terminal in "${terminals[@]}"; do
        for theme in "${themes[@]}"; do
            local config_files=(
                "$THEME_DIR/terminals/$terminal/$theme.conf"
                "$THEME_DIR/terminals/$terminal/$theme.yml"
                "$THEME_DIR/terminals/$terminal/$theme.yaml"
                "$THEME_DIR/terminals/$terminal/$theme.config"
            )
            
            local found=false
            for config_file in "${config_files[@]}"; do
                if [[ -f "$config_file" ]]; then
                    found=true
                    break
                fi
            done
            
            if [[ "$found" == false ]]; then
                fail "Terminal config file should exist for $terminal/$theme"
                return 1
            fi
        done
    done
    
    return 0
}

test_fish_theme_files_exist() {
    local themes=("catppuccin-macchiato" "gruvbox" "tokyo-night-storm")
    
    for theme in "${themes[@]}"; do
        local fish_theme="$THEME_DIR/fish/themes/$theme.fish"
        if [[ ! -f "$fish_theme" ]]; then
            fail "Fish theme file should exist: $fish_theme"
            return 1
        fi
    done
    
    return 0
}

test_theme_script_structure() {
    local content
    content=$(cat "$THEME_SCRIPT")
    
    # Check for proper script structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "set -e" "Should have error handling"
    assert_contains "$content" "apply_terminal_themes" "Should have terminal theme function"
    assert_contains "$content" "apply_editor_themes" "Should have editor theme function"
    assert_contains "$content" "validate_theme" "Should have theme validation"
    
    return 0
}

test_theme_validation_logic() {
    local content
    content=$(cat "$THEME_SCRIPT")
    
    # Check for theme validation
    assert_contains "$content" "AVAILABLE_THEMES" "Should define available themes"
    assert_contains "$content" "catppuccin-macchiato" "Should include catppuccin theme"
    assert_contains "$content" "gruvbox" "Should include gruvbox theme"
    assert_contains "$content" "tokyo-night-storm" "Should include tokyo-night theme"
    
    return 0
}

test_theme_safety_checks() {
    local content
    content=$(cat "$THEME_SCRIPT")
    
    # Check for safety measures
    assert_not_contains "$content" "rm -rf /" "Should not have dangerous rm commands"
    assert_not_contains "$content" "eval.*\$" "Should not have dangerous eval"
    assert_contains "$content" "mkdir -p" "Should safely create directories"
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "theme_script_exists" test_theme_script_exists "Theme switch script exists"
run_test "theme_script_executable" test_theme_script_executable "Theme switch script is executable"
run_test "theme_directories_exist" test_theme_directories_exist "Theme directories exist"
run_test "theme_color_files_exist" test_theme_color_files_exist "Theme color files exist"
run_test "theme_script_no_args" test_theme_script_no_args "Theme script works with no args"
run_test "theme_script_invalid_theme" test_theme_script_invalid_theme "Theme script handles invalid theme"
run_test "terminal_config_files_exist" test_terminal_config_files_exist "Terminal config files exist"
run_test "fish_theme_files_exist" test_fish_theme_files_exist "Fish theme files exist"
run_test "theme_script_structure" test_theme_script_structure "Theme script has proper structure"
run_test "theme_validation_logic" test_theme_validation_logic "Theme validation logic exists"
run_test "theme_safety_checks" test_theme_safety_checks "Theme script has safety checks"

info "Unit tests for theme system completed"