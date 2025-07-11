#!/bin/bash
#
# Catred Config - Synchronize Local Changes to Repository
#
# This script helps synchronize local configuration changes (made in ~/.config)
# back to the main Catred Config repository.
#

set -e

# --- Configuration & Helpers ---
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../.. && pwd)
LOG_FILE="$HOME/catred_sync.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "$*" | tee -a "$LOG_FILE"; }
info() { log "${BLUE}INFO:${NC} $*"; }
success() { log "${GREEN}SUCCESS:${NC} $*"; }
warning() { log "${YELLOW}WARNING:${NC} $*"; }
error() { log "${RED}ERROR:${NC} $*"; exit 1; }

# --- Main Execution ---
main() {
    rm -f "$LOG_FILE"
    info "Starting configuration synchronization..."

    cd "$REPO_DIR"

    info "Checking for changes in the configs/ directory..."
    git add configs/
    
    if git diff --cached --quiet; then
        info "No changes detected in configs/ to commit."
    else
        info "Changes detected. Please review and commit them."
        git status
        
        read -p "Press Enter to open git commit message, or Ctrl+C to cancel: "
        git commit -v

        read -p "Push changes to remote? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push
            success "Changes pushed to remote repository."
        else
            warning "Changes committed locally but not pushed to remote."
        fi
    fi

    success "Synchronization process complete! See log at $LOG_FILE"
}

main
