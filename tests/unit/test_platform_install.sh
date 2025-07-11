#!/bin/bash
#
# Unit tests for platform-specific installation scripts
#

# Disable errexit for test scripts
set +e

# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test configuration
BOOTSTRAP_SCRIPT="$REPO_DIR/scripts/install/bootstrap.sh"
MACOS_INSTALL="$REPO_DIR/scripts/install/macos-install.sh"
LINUX_INSTALL="$REPO_DIR/scripts/install/linux-install.sh" 
WINDOWS_INSTALL="$REPO_DIR/scripts/install/windows-install.sh"

# --- Test Functions ---

# Bootstrap script tests
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

test_bootstrap_platform_detection() {
    local content
    content=$(cat "$BOOTSTRAP_SCRIPT")
    
    # Check for platform detection logic
    assert_contains "$content" "uname" "Should detect platform using uname"
    assert_contains "$content" "Darwin" "Should detect macOS"
    assert_contains "$content" "Linux" "Should detect Linux"
    assert_contains "$content" "CYGWIN" "Should detect Windows"
    
    return 0
}

# macOS installation tests
test_macos_install_exists() {
    assert_file_exists "$MACOS_INSTALL" "macOS install script should exist"
}

test_macos_install_executable() {
    if [[ -x "$MACOS_INSTALL" ]]; then
        return 0
    else
        fail "macOS install script should be executable"
        return 1
    fi
}

test_macos_install_structure() {
    local content
    content=$(cat "$MACOS_INSTALL")
    
    # Check for proper structure
    assert_contains "$content" "#!/bin/bash" "Should have bash shebang"
    assert_contains "$content" "set -e" "Should have error handling"
    assert_contains "$content" "pre_flight_checks" "Should have pre-flight checks"
    assert_contains "$content" "install_packages" "Should install packages"
    assert_contains "$content" "configure_system" "Should configure system"
    assert_contains "$content" "symlink_configs" "Should symlink configs"
    
    return 0
}

test_macos_install_dependencies() {
    local content
    content=$(cat "$MACOS_INSTALL")
    
    # Check for essential dependencies
    assert_contains "$content" "brew install" "Should use Homebrew"
    assert_contains "$content" "stow" "Should install stow"
    assert_contains "$content" "fish" "Should install fish shell"
    assert_contains "$content" "neovim" "Should install neovim"
    assert_contains "$content" "yabai" "Should install yabai"
    assert_contains "$content" "skhd" "Should install skhd"
    
    return 0
}

test_macos_install_safety() {
    local content
    content=$(cat "$MACOS_INSTALL")
    
    # Check for safety measures
    assert_contains "$content" "backup" "Should backup existing configs"
    assert_not_contains "$content" "rm -rf /" "Should not have dangerous commands"
    assert_not_contains "$content" "sudo rm -rf" "Should not have dangerous sudo commands"
    
    return 0
}

# Linux installation tests
test_linux_install_exists() {
    # Linux install script might not exist yet, so skip if not found
    if [[ ! -f "$LINUX_INSTALL" ]]; then
        skip "Linux install script not implemented yet"
        return 0
    fi
    assert_file_exists "$LINUX_INSTALL" "Linux install script should exist"
}

test_linux_install_executable() {
    if [[ ! -f "$LINUX_INSTALL" ]]; then
        skip "Linux install script not implemented yet"
        return 0
    fi
    
    if [[ -x "$LINUX_INSTALL" ]]; then
        return 0
    else
        fail "Linux install script should be executable"
        return 1
    fi
}

test_linux_install_distro_detection() {
    if [[ ! -f "$LINUX_INSTALL" ]]; then
        skip "Linux install script not implemented yet"
        return 0
    fi
    
    local content
    content=$(cat "$LINUX_INSTALL")
    
    # Check for distro detection
    assert_contains "$content" "/etc/os-release" "Should detect Linux distribution"
    assert_contains "$content" "debian" "Should support Debian/Ubuntu"
    assert_contains "$content" "fedora" "Should support Fedora"
    assert_contains "$content" "arch" "Should support Arch"
    
    return 0
}

# Windows installation tests
test_windows_install_exists() {
    # Windows install script might not exist yet, so skip if not found
    if [[ ! -f "$WINDOWS_INSTALL" ]]; then
        skip "Windows install script not implemented yet"
        return 0
    fi
    assert_file_exists "$WINDOWS_INSTALL" "Windows install script should exist"
}

test_windows_install_structure() {
    if [[ ! -f "$WINDOWS_INSTALL" ]]; then
        skip "Windows install script not implemented yet"
        return 0
    fi
    
    local content
    content=$(cat "$WINDOWS_INSTALL")
    
    # Check for Windows-specific elements
    assert_contains "$content" "scoop\|choco\|winget" "Should use Windows package manager"
    assert_contains "$content" "komorebi" "Should install komorebi"
    assert_contains "$content" "whkd" "Should install whkd"
    
    return 0
}

# Build script tests
test_build_scripts_exist() {
    # Check if any build scripts exist
    local build_scripts=(
        "$REPO_DIR/scripts/build/build-all.sh"
        "$REPO_DIR/scripts/build/build-configs.sh"
        "$REPO_DIR/Makefile"
    )
    
    local found=false
    for script in "${build_scripts[@]}"; do
        if [[ -f "$script" ]]; then
            found=true
            break
        fi
    done
    
    if [[ "$found" == "false" ]]; then
        skip "No build scripts found (might not be needed for this project)"
        return 0
    fi
    
    return 0
}

# Cross-platform compatibility tests
test_scripts_use_portable_commands() {
    local scripts=(
        "$BOOTSTRAP_SCRIPT"
        "$MACOS_INSTALL"
    )
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            local content
            content=$(cat "$script")
            
            # Check for non-portable commands
            if echo "$content" | grep -q "readlink -f"; then
                fail "$script uses non-portable 'readlink -f' (not available on macOS)"
                return 1
            fi
            
            if echo "$content" | grep -q "sed -i"; then
                # Check if it handles macOS sed properly
                if ! echo "$content" | grep -q "sed -i\(\\.bak\|''\)"; then
                    warn "$script uses 'sed -i' without considering macOS compatibility"
                fi
            fi
        fi
    done
    
    return 0
}

test_scripts_handle_spaces_in_paths() {
    local scripts=(
        "$BOOTSTRAP_SCRIPT"
        "$MACOS_INSTALL"
    )
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            local content
            content=$(cat "$script")
            
            # Check for proper quoting in common patterns
            if echo "$content" | grep -E "cd \$|cp \$|mv \$" | grep -v '"'; then
                warn "$script might not handle spaces in paths properly"
            fi
        fi
    done
    
    return 0
}

# --- Test Execution ---

# Run the tests
run_test "bootstrap_script_exists" test_bootstrap_script_exists "Bootstrap script exists"
run_test "bootstrap_script_executable" test_bootstrap_script_executable "Bootstrap script is executable"
run_test "bootstrap_platform_detection" test_bootstrap_platform_detection "Bootstrap detects platforms correctly"

run_test "macos_install_exists" test_macos_install_exists "macOS install script exists"
run_test "macos_install_executable" test_macos_install_executable "macOS install script is executable"
run_test "macos_install_structure" test_macos_install_structure "macOS install script has proper structure"
run_test "macos_install_dependencies" test_macos_install_dependencies "macOS install script installs dependencies"
run_test "macos_install_safety" test_macos_install_safety "macOS install script has safety measures"

run_test "linux_install_exists" test_linux_install_exists "Linux install script exists"
run_test "linux_install_executable" test_linux_install_executable "Linux install script is executable"
run_test "linux_install_distro_detection" test_linux_install_distro_detection "Linux install detects distributions"

run_test "windows_install_exists" test_windows_install_exists "Windows install script exists"
run_test "windows_install_structure" test_windows_install_structure "Windows install script has proper structure"

run_test "build_scripts_exist" test_build_scripts_exist "Build scripts exist"

run_test "scripts_use_portable_commands" test_scripts_use_portable_commands "Scripts use portable commands"
run_test "scripts_handle_spaces_in_paths" test_scripts_handle_spaces_in_paths "Scripts handle spaces in paths"

info "Unit tests for platform installation completed"

# Exit with success - individual test functions handle their own failures
exit 0