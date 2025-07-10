#!/bin/bash
#
# Integration tests for install/uninstall workflows
#

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
BOOTSTRAP_SCRIPT="$REPO_DIR/scripts/install/bootstrap.sh"
UNINSTALL_SCRIPT="$REPO_DIR/uninstall.sh"
MACOS_INSTALL_SCRIPT="$REPO_DIR/scripts/install/macos-install.sh"

# --- Test Functions ---

test_bootstrap_script_exists() {
    assert_file_exists "$BOOTSTRAP_SCRIPT" "Bootstrap script should exist"
}

test_bootstrap_script_executable() {
    if [[ -x "$BOOTSTRAP_SCRIPT" ]]; then
        return 0
    else
        fail "Bootstrap script should be executable"
        return 1
    fi
}

test_uninstall_script_exists() {
    assert_file_exists "$UNINSTALL_SCRIPT" "Uninstall script should exist"
}

test_uninstall_script_executable() {
    if [[ -x "$UNINSTALL_SCRIPT" ]]; then
        return 0
    else
        fail "Uninstall script should be executable"
        return 1
    fi
}

test_macos_install_script_exists() {
    assert_file_exists "$MACOS_INSTALL_SCRIPT" "macOS install script should exist"
}

test_macos_install_script_executable() {
    if [[ -x "$MACOS_INSTALL_SCRIPT" ]]; then
        return 0
    else
        fail "macOS install script should be executable"
        return 1
    fi
}

test_bootstrap_platform_detection() {
    # Skip this test in CI environment as it requires system tools
    if [[ -n "$CI" || -n "$GITHUB_ACTIONS" ]]; then
        skip "Skipping bootstrap platform detection test in CI environment"
        return 0
    fi
    
    local output
    output=$("$BOOTSTRAP_SCRIPT" 2>&1 || true)
    
    # Should detect macOS and try to run macOS installer
    assert_contains "$output" "macOS detected" "Should detect macOS platform"
    assert_contains "$output" "Running macOS installer" "Should run macOS installer"
    
    return 0
}

test_uninstall_safety_confirmation() {
    # Skip this test in CI environment as it requires system tools
    if [[ -n "$CI" || -n "$GITHUB_ACTIONS" ]]; then
        skip "Skipping uninstall safety confirmation test in CI environment"
        return 0
    fi
    
    local output
    output=$(echo "n" | "$UNINSTALL_SCRIPT" 2>&1 || true)
    
    # Should ask for confirmation and exit when user says no
    assert_contains "$output" "Are you sure" "Should ask for confirmation"
    
    return 0
}

test_install_script_has_safety_checks() {
    # Skip this test in CI environment as it requires system tools
    if [[ -n "$CI" || -n "$GITHUB_ACTIONS" ]]; then
        skip "Skipping install script safety checks test in CI environment"
        return 0
    fi
    
    local output
    output=$("$MACOS_INSTALL_SCRIPT" 2>&1 || true)
    
    # Should perform pre-flight checks
    assert_contains "$output" "pre-flight checks" "Should perform pre-flight checks"
    
    return 0
}

test_install_script_creates_backup() {
    # Skip this test in CI environment as it requires system tools
    if [[ -n "$CI" || -n "$GITHUB_ACTIONS" ]]; then
        skip "Skipping install script backup test in CI environment"
        return 0
    fi
    
    local output
    output=$("$MACOS_INSTALL_SCRIPT" 2>&1 || true)
    
    # Should create backup
    assert_contains "$output" "Backing up" "Should create backup"
    
    return 0
}

test_uninstall_script_has_proper_structure() {
    local content
    content=$(cat "$UNINSTALL_SCRIPT")
    
    # Should have proper structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "stow" "Should use stow for cleanup"
    assert_contains "$content" "brew uninstall" "Should uninstall packages"
    assert_contains "$content" "chsh" "Should restore shell"
    
    return 0
}

test_install_script_has_proper_structure() {
    local content
    content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should have proper structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "pre_flight_checks" "Should have pre-flight checks"
    assert_contains "$content" "backup_existing_configs" "Should backup configs"
    assert_contains "$content" "install_packages" "Should install packages"
    assert_contains "$content" "symlink_configs" "Should symlink configs"
    assert_contains "$content" "apply_default_theme" "Should apply default theme"
    
    return 0
}

test_scripts_have_error_handling() {
    local bootstrap_content
    bootstrap_content=$(cat "$BOOTSTRAP_SCRIPT")
    
    local install_content
    install_content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should have set -e for error handling
    assert_contains "$bootstrap_content" "set -e" "Bootstrap should have error handling"
    assert_contains "$install_content" "set -e" "Install script should have error handling"
    
    return 0
}

test_install_script_package_lists() {
    local content
    content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should install expected packages (check for various patterns)
    assert_contains "$content" "stow" "Should install stow"
    assert_contains "$content" "fish" "Should install fish"
    assert_contains "$content" "neovim" "Should install neovim"
    assert_contains "$content" "zed" "Should install zed"
    assert_contains "$content" "yabai" "Should install yabai"
    assert_contains "$content" "skhd" "Should install skhd"
    assert_contains "$content" "sketchybar" "Should install sketchybar"
    
    return 0
}

test_install_script_cask_packages() {
    local content
    content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should install expected cask packages (check for various patterns)
    assert_contains "$content" "raycast" "Should install Raycast"
    assert_contains "$content" "warp" "Should install Warp"
    assert_contains "$content" "ghostty" "Should install Ghostty"
    assert_contains "$content" "kitty" "Should install Kitty"
    assert_contains "$content" "alacritty" "Should install Alacritty"
    assert_contains "$content" "font-jetbrains-mono-nerd-font" "Should install JetBrains font"
    
    return 0
}

test_uninstall_script_package_removal() {
    local content
    content=$(cat "$UNINSTALL_SCRIPT")
    
    # Should uninstall the same packages that were installed (check for various patterns)
    assert_contains "$content" "stow" "Should uninstall stow"
    assert_contains "$content" "fish" "Should uninstall fish"
    assert_contains "$content" "neovim" "Should uninstall neovim"
    assert_contains "$content" "zed" "Should uninstall zed"
    assert_contains "$content" "yabai" "Should uninstall yabai"
    assert_contains "$content" "skhd" "Should uninstall skhd"
    assert_contains "$content" "sketchybar" "Should uninstall sketchybar"
    
    return 0
}

test_install_script_stow_usage() {
    local content
    content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should use stow for symlinking (check for various patterns)
    assert_contains "$content" "stow" "Should use stow"
    assert_contains "$content" "configs" "Should reference configs directory"
    assert_contains "$content" "HOME/.config" "Should target HOME/.config"
    assert_contains "$content" "nvim" "Should stow nvim config"
    assert_contains "$content" "fish" "Should stow fish config"
    assert_contains "$content" "zed" "Should stow zed config"
    
    return 0
}

test_uninstall_script_stow_cleanup() {
    local content
    content=$(cat "$UNINSTALL_SCRIPT")
    
    # Should use stow -D for cleanup (check for various patterns)
    assert_contains "$content" "stow" "Should use stow"
    assert_contains "$content" "-D" "Should use stow -D for removal"
    assert_contains "$content" "nvim" "Should remove nvim config"
    assert_contains "$content" "fish" "Should remove fish config"
    assert_contains "$content" "zed" "Should remove zed config"
    
    return 0
}

test_install_script_shell_configuration() {
    local content
    content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    # Should configure Fish shell (check for various patterns)
    assert_contains "$content" "/etc/shells" "Should add fish to shells"
    assert_contains "$content" "chsh" "Should change shell"
    assert_contains "$content" "fish" "Should configure fish shell"
    
    return 0
}

test_safety_mechanisms() {
    local install_content
    install_content=$(cat "$MACOS_INSTALL_SCRIPT")
    
    local uninstall_content
    uninstall_content=$(cat "$UNINSTALL_SCRIPT")
    
    # Install script safety
    assert_not_contains "$install_content" "rm -rf /" "Install should not have dangerous rm"
    assert_not_contains "$install_content" "eval.*\$" "Install should not have dangerous eval"
    
    # Uninstall script safety
    assert_not_contains "$uninstall_content" "rm -rf /" "Uninstall should not have dangerous rm"
    assert_not_contains "$uninstall_content" "eval.*\$" "Uninstall should not have dangerous eval"
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "bootstrap_script_exists" test_bootstrap_script_exists "Bootstrap script exists"
run_test "bootstrap_script_executable" test_bootstrap_script_executable "Bootstrap script is executable"
run_test "uninstall_script_exists" test_uninstall_script_exists "Uninstall script exists"
run_test "uninstall_script_executable" test_uninstall_script_executable "Uninstall script is executable"
run_test "macos_install_script_exists" test_macos_install_script_exists "macOS install script exists"
run_test "macos_install_script_executable" test_macos_install_script_executable "macOS install script is executable"
run_test "bootstrap_platform_detection" test_bootstrap_platform_detection "Bootstrap detects platform correctly"
run_test "uninstall_safety_confirmation" test_uninstall_safety_confirmation "Uninstall requires confirmation"
run_test "install_script_has_safety_checks" test_install_script_has_safety_checks "Install script has safety checks"
run_test "install_script_creates_backup" test_install_script_creates_backup "Install script creates backup"
run_test "uninstall_script_has_proper_structure" test_uninstall_script_has_proper_structure "Uninstall script has proper structure"
run_test "install_script_has_proper_structure" test_install_script_has_proper_structure "Install script has proper structure"
run_test "scripts_have_error_handling" test_scripts_have_error_handling "Scripts have error handling"
run_test "install_script_package_lists" test_install_script_package_lists "Install script has correct package lists"
run_test "install_script_cask_packages" test_install_script_cask_packages "Install script has correct cask packages"
run_test "uninstall_script_package_removal" test_uninstall_script_package_removal "Uninstall script removes correct packages"
run_test "install_script_stow_usage" test_install_script_stow_usage "Install script uses stow correctly"
run_test "uninstall_script_stow_cleanup" test_uninstall_script_stow_cleanup "Uninstall script cleans up stow correctly"
run_test "install_script_shell_configuration" test_install_script_shell_configuration "Install script configures shell correctly"
run_test "safety_mechanisms" test_safety_mechanisms "Scripts have proper safety mechanisms"

info "Integration tests for install/uninstall workflows completed"

# Exit with success - individual test functions handle their own failures
exit 0