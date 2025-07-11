#!/bin/bash
#
# Catred Config - Universal Bootstrap Installer
#
# This script is the single entry point for setting up the entire development
# environment. It detects the operating system and executes the appropriate
# platform-specific installation script.
#

set -e

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd .. && pwd)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
info() { echo -e "${BLUE}INFO:${NC} $*"; }
success() { echo -e "${GREEN}SUCCESS:${NC} $*"; }
error() { echo -e "${RED}ERROR:${NC} $*"; exit 1; }

# --- Main Execution ---
main() {
    info "Starting Catred Config bootstrap process..."

    local os
    os="$(uname -s)"

    case "$os" in
        Darwin*)
            info "macOS detected. Running macOS installer..."
            bash "$REPO_DIR/install/macos-install.sh"
            ;;
        Linux*)
            info "Linux detected. Running Linux installer..."
            bash "$REPO_DIR/install/linux-install.sh"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            info "Windows detected. Running Windows installer..."
            powershell.exe -ExecutionPolicy Bypass -File "$REPO_DIR\install\windows-install.ps1"
            ;;
        *)
            error "Unsupported operating system: $os"
            ;;
    esac

    success "Bootstrap process complete!"
}

main "$@"
