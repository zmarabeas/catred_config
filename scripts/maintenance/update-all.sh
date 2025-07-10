#!/bin/bash
#
# Catred Config - Update All Components
#
# This script updates various components of the Catred Config development
# environment, including Homebrew packages, Neovim plugins, and Fish shell.
#

set -e

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../.. && pwd)
LOG_FILE="$HOME/catred_update.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "$*" | tee -a "$LOG_FILE"; }
info() { log "${BLUE}INFO:${NC} $*"; }
success() { log "${GREEN}SUCCESS:${NC} $*"; }
warning() { log "${YELLOW}WARNING:${NC} $*"; }
error() { log "${RED}ERROR:${NC} $*"; exit 1; }

# --- Update Functions ---
update_homebrew() {
    info "Updating Homebrew packages..."
    if command -v brew &> /dev/null; then
        brew update
        brew upgrade
        brew cleanup
        success "Homebrew packages updated."
    else
        warning "Homebrew not found. Skipping Homebrew update."
    fi
}

update_neovim_plugins() {
    info "Updating Neovim plugins..."
    if command -v nvim &> /dev/null; then
        # Update plugins using lazy.nvim with proper async handling
        nvim --headless -c "autocmd User LazyDone ++once qall" -c "Lazy! sync" &
        local nvim_pid=$!
        
        # Wait for completion with timeout
        local timeout=300 # 5 minutes
        local elapsed=0
        
        while kill -0 $nvim_pid 2>/dev/null; do
            if [ $elapsed -ge $timeout ]; then
                kill $nvim_pid 2>/dev/null
                warning "Neovim plugin update timed out"
                return 1
            fi
            sleep 1
            ((elapsed++))
        done
        
        success "Neovim plugins updated."
    else
        warning "Neovim not found. Skipping Neovim plugin update."
    fi
}

update_fish_plugins() {
    info "Updating Fish shell plugins..."
    if command -v fish &> /dev/null; then
        # Assuming fisher is used for Fish plugin management
        if command -v fisher &> /dev/null; then
            fish -c "fisher update"
            success "Fish shell plugins updated."
        else
            warning "Fisher (Fish plugin manager) not found. Skipping Fish plugin update."
        fi
    else
        warning "Fish shell not found. Skipping Fish plugin update."
    fi
}

update_zed() {
    info "Updating Zed editor..."
    if command -v zed &> /dev/null; then
        # Zed's update mechanism is usually built-in or via app store/package manager
        # For Homebrew Cask, it's handled by brew upgrade
        # For Linux, it's usually a re-download/re-install or package manager update
        # For Windows, it's usually a re-download/re-install or winget/choco update
        # This function primarily serves as a placeholder or for specific CLI updates if Zed adds one.
        warning "Zed update typically handled by system package manager (Homebrew/winget/dnf/apt/pacman)."
        warning "Manual check for Zed updates might be required."
    else
        warning "Zed not found. Skipping Zed update."
    fi
}

# --- Main Execution ---
main() {
    rm -f "$LOG_FILE"
    info "Starting Catred Config update process..."
    
    update_homebrew
    update_neovim_plugins
    update_fish_plugins
    update_zed

    success "All components updated! See log at $LOG_FILE"
}

main
