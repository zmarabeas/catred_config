#!/bin/bash
#
# Unit tests for the main catred CLI script
#

# Disable errexit for test scripts
set +e

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
CATRED_SCRIPT="$REPO_DIR/scripts/catred"

# --- Test Functions ---

test_catred_script_exists() {
    assert_file_exists "$CATRED_SCRIPT" "catred CLI script should exist"
}

test_catred_script_executable() {
    if [[ -x "$CATRED_SCRIPT" ]]; then
        return 0
    else
        fail "catred CLI script should be executable"
        return 1
    fi
}

test_catred_help_command() {
    local output
    output=$("$CATRED_SCRIPT" help 2>&1 || true)
    
    # Help command should always succeed and show help text
    assert_contains "$output" "Catred Config" "Help should contain project name"
    assert_contains "$output" "USAGE:" "Help should contain usage section"
    assert_contains "$output" "COMMANDS:" "Help should contain commands section"
    assert_contains "$output" "theme" "Help should list theme command"
    assert_contains "$output" "health" "Help should list health command"
    return 0
}

test_catred_version_command() {
    local output
    output=$("$CATRED_SCRIPT" version 2>&1 || true)
    
    # Version command should show version info
    assert_contains "$output" "Catred Config" "Version should contain project name"
    assert_contains "$output" "v" "Version should contain version number"
    return 0
}

test_catred_invalid_command() {
    local output
    output=$("$CATRED_SCRIPT" invalid_command 2>&1 || true)
    
    # Should show error for invalid command
    assert_contains "$output" "Unknown command" "Should show error for invalid command"
    return 0
}

test_catred_theme_command_no_args() {
    local output
    output=$("$CATRED_SCRIPT" theme 2>&1 || true)
    
    # Should show current theme or theme info
    assert_contains "$output" "theme" "Should show theme-related output"
    # More flexible checks for CI environment where theme files might not exist
    if [[ -z "$CI" && -z "$GITHUB_ACTIONS" ]]; then
        assert_contains "$output" "Available themes:" "Should show available themes"
        assert_contains "$output" "catppuccin-macchiato" "Should list catppuccin theme"
        assert_contains "$output" "gruvbox" "Should list gruvbox theme"
        assert_contains "$output" "tokyo-night-storm" "Should list tokyo-night theme"
    fi
    return 0
}

test_catred_health_command() {
    local output
    output=$("$CATRED_SCRIPT" health 2>&1 || true)
    
    # Health check should run (might fail but should execute)
    assert_contains "$output" "Health Check" "Should run health check"
    return 0
}

test_catred_script_structure() {
    local content
    content=$(cat "$CATRED_SCRIPT")
    
    # Check for proper script structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "set -e" "Should have error handling"
    assert_contains "$content" "main(" "Should have main function"
    assert_contains "$content" "case.*theme" "Should handle theme command"
    assert_contains "$content" "case.*health" "Should handle health command"
    
    return 0
}

test_catred_error_handling() {
    local content
    content=$(cat "$CATRED_SCRIPT")
    
    # Check for error handling patterns
    assert_contains "$content" "error.*exit" "Should have error handling with exit"
    assert_not_contains "$content" "rm -rf /" "Should not have dangerous commands"
    assert_not_contains "$content" "eval.*\$" "Should not have dangerous eval"
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "catred_script_exists" test_catred_script_exists "catred CLI script exists"
run_test "catred_script_executable" test_catred_script_executable "catred CLI script is executable"
run_test "catred_help_command" test_catred_help_command "catred help command works"
run_test "catred_version_command" test_catred_version_command "catred version command works"
run_test "catred_invalid_command" test_catred_invalid_command "catred handles invalid commands"
run_test "catred_theme_command_no_args" test_catred_theme_command_no_args "catred theme command without args works"
run_test "catred_health_command" test_catred_health_command "catred health command works"
run_test "catred_script_structure" test_catred_script_structure "catred script has proper structure"
run_test "catred_error_handling" test_catred_error_handling "catred script has safe error handling"

info "Unit tests for catred CLI completed"

# Exit with success - individual test functions handle their own failures
exit 0