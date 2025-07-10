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

test_health_script_structure() {
    local content
    content=$(cat "$HEALTH_SCRIPT")
    
    # Check for proper script structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "check()" "Should have check function"
    assert_contains "$content" "run_cli_checks" "Should have CLI checks function"
    assert_contains "$content" "run_symlink_checks" "Should have symlink checks function"
    assert_contains "$content" "run_theme_checks" "Should have theme checks function"
    
    return 0
}

test_health_script_error_handling() {
    local content
    content=$(cat "$HEALTH_SCRIPT")
    
    # Check for error handling and safety
    assert_contains "$content" "PASS_COUNT" "Should track passed tests"
    assert_contains "$content" "FAIL_COUNT" "Should track failed tests"
    assert_contains "$content" "exit.*FAIL_COUNT" "Should exit with error code on failures"
    assert_not_contains "$content" "rm -rf" "Should not have dangerous commands"
    
    return 0
}

test_health_script_check_function() {
    local content
    content=$(cat "$HEALTH_SCRIPT")
    
    # Check for proper check function implementation
    assert_contains "$content" "command -v" "Should use command -v for tool checks"
    assert_contains "$content" "\\[.*PASS.*\\]" "Should show PASS status"
    assert_contains "$content" "\\[.*FAIL.*\\]" "Should show FAIL status"
    assert_contains "$content" "&> /dev/null" "Should suppress command output"
    
    return 0
}

test_health_script_counters() {
    local content
    content=$(cat "$HEALTH_SCRIPT")
    
    # Check for proper counter management
    assert_contains "$content" "((PASS_COUNT++))" "Should increment pass counter"
    assert_contains "$content" "((FAIL_COUNT++))" "Should increment fail counter"
    assert_contains "$content" "PASS_COUNT=0" "Should initialize pass counter"
    assert_contains "$content" "FAIL_COUNT=0" "Should initialize fail counter"
    
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
run_test "health_script_structure" test_health_script_structure "Health check has proper structure"
run_test "health_script_error_handling" test_health_script_error_handling "Health check has error handling"
run_test "health_script_check_function" test_health_script_check_function "Health check function works correctly"
run_test "health_script_counters" test_health_script_counters "Health check counters work correctly"

info "Unit tests for health check system completed"

# Exit with success - individual test functions handle their own failures
exit 0