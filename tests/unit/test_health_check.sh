#!/bin/bash
#
# Unit tests for the health check system
#

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
HEALTH_SCRIPT="$REPO_DIR/scripts/maintenance/health-check.sh"

# --- Test Functions ---

test_health_script_exists() {
    assert_file_exists "$HEALTH_SCRIPT" "Health check script should exist"
}

test_health_script_executable() {
    if [[ -x "$HEALTH_SCRIPT" ]]; then
        return 0
    else
        fail "Health check script should be executable"
        return 1
    fi
}

test_health_script_output_format() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Health check will likely fail on uninstalled system, but should have proper format
    assert_contains "$output" "Catred Config Health Check" "Should show health check title"
    assert_contains "$output" "Health Check Summary:" "Should show summary section"
    assert_contains "$output" "Passed:" "Should show passed count"
    assert_contains "$output" "Failed:" "Should show failed count"
    
    return 0
}

test_health_script_categories() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Check for different test categories
    assert_contains "$output" "Core CLI Tools" "Should test core CLI tools"
    assert_contains "$output" "Configuration Symlinks" "Should test configuration symlinks"
    assert_contains "$output" "Theme System" "Should test theme system"
    assert_contains "$output" "Platform-Specific Components" "Should test platform-specific components"
    
    return 0
}

test_health_script_tool_checks() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Check for specific tool checks
    assert_contains "$output" "Neovim" "Should check for Neovim"
    assert_contains "$output" "Fish" "Should check for Fish"
    assert_contains "$output" "Zed" "Should check for Zed"
    assert_contains "$output" "Stow" "Should check for Stow"
    
    return 0
}

test_health_script_symlink_checks() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Check for symlink validation
    assert_contains "$output" "init.lua" "Should check Neovim config"
    assert_contains "$output" "config.fish" "Should check Fish config"
    assert_contains "$output" "settings.json" "Should check Zed config"
    
    return 0
}

test_health_script_theme_checks() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Check for theme system validation
    assert_contains "$output" "Theme switch script" "Should check theme switch script"
    assert_contains "$output" "Current theme file" "Should check current theme file"
    
    return 0
}

test_health_script_platform_detection() {
    local output
    output=$("$HEALTH_SCRIPT" 2>&1)
    
    # Should detect macOS and check appropriate tools
    assert_contains "$output" "Darwin" "Should detect macOS platform"
    assert_contains "$output" "yabai" "Should check for yabai"
    assert_contains "$output" "skhd" "Should check for skhd"
    assert_contains "$output" "SketchyBar" "Should check for SketchyBar"
    assert_contains "$output" "Raycast" "Should check for Raycast"
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "health_script_exists" test_health_script_exists "Health check script exists"
run_test "health_script_executable" test_health_script_executable "Health check script is executable"
run_test "health_script_output_format" test_health_script_output_format "Health check has proper output format"
run_test "health_script_categories" test_health_script_categories "Health check tests all categories"
run_test "health_script_tool_checks" test_health_script_tool_checks "Health check validates core tools"
run_test "health_script_symlink_checks" test_health_script_symlink_checks "Health check validates symlinks"
run_test "health_script_theme_checks" test_health_script_theme_checks "Health check validates theme system"
run_test "health_script_platform_detection" test_health_script_platform_detection "Health check detects platform correctly"

info "Unit tests for health check system completed"