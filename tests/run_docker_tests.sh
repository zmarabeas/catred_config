#!/bin/bash
#
# Docker-based test runner for Catred Config
#
# This script provides a consistent testing environment using Docker containers
# to validate the Catred Config system across different platforms.
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[38;2;204;36;29m'
GREEN='\033[38;2;152;151;26m'
YELLOW='\033[38;2;215;153;33m'
BLUE='\033[38;2;69;133;136m'
NC='\033[0m'

# Logging
info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# --- Functions ---

check_docker() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker to run container tests."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        error "Docker daemon is not running. Please start Docker."
        exit 1
    fi
    
    info "Docker is available and running"
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        warn "docker-compose not found, trying docker compose..."
        if ! docker compose version &> /dev/null; then
            error "Neither docker-compose nor docker compose is available."
            exit 1
        fi
        DOCKER_COMPOSE_CMD="docker compose"
    else
        DOCKER_COMPOSE_CMD="docker-compose"
    fi
    
    info "Using: $DOCKER_COMPOSE_CMD"
}

run_shellcheck() {
    info "Running ShellCheck linting..."
    
    if $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" run --rm shellcheck; then
        success "ShellCheck passed"
    else
        error "ShellCheck failed"
        return 1
    fi
}

run_validation() {
    info "Running configuration validation..."
    
    if $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" run --rm validation; then
        success "Configuration validation passed"
    else
        error "Configuration validation failed"
        return 1
    fi
}

run_ubuntu_tests() {
    info "Running tests in Ubuntu container..."
    
    if $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" run --rm ubuntu-test; then
        success "Ubuntu tests passed"
    else
        error "Ubuntu tests failed"
        return 1
    fi
}

run_interactive_ubuntu() {
    info "Starting interactive Ubuntu test environment..."
    info "Use this for manual testing and debugging"
    
    $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" run --rm ubuntu-interactive
}

build_containers() {
    info "Building Docker containers..."
    
    $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" build
    
    success "Docker containers built successfully"
}

cleanup_containers() {
    info "Cleaning up Docker containers and images..."
    
    # Remove containers
    $DOCKER_COMPOSE_CMD -f "$SCRIPT_DIR/docker/docker-compose.yml" down --remove-orphans
    
    # Remove images
    docker rmi catred_config_ubuntu-test catred_config_ubuntu-interactive 2>/dev/null || true
    
    success "Cleanup completed"
}

run_security_scan() {
    info "Running security scan in container..."
    
    if docker run --rm -v "$REPO_DIR:/mnt" ubuntu:22.04 bash -c "
        cd /mnt
        find scripts -name '*.sh' -exec grep -H 'eval.*\$' {} \; | tee security_issues.txt
        find scripts -name '*.sh' -exec grep -H 'curl.*|.*sh' {} \; | tee -a security_issues.txt
        find scripts -name '*.sh' -exec grep -H 'rm -rf /' {} \; | tee -a security_issues.txt
        
        if [ -s security_issues.txt ]; then
            echo 'Security issues found:'
            cat security_issues.txt
            exit 1
        fi
        
        echo 'No security issues found'
    "; then
        success "Security scan passed"
    else
        error "Security scan failed"
        return 1
    fi
}

show_help() {
    cat << EOF
Docker Test Runner for Catred Config

Usage: $0 [COMMAND]

Commands:
    all         Run all tests (default)
    build       Build Docker containers
    shellcheck  Run ShellCheck linting
    validation  Run configuration validation
    ubuntu      Run tests in Ubuntu container
    interactive Start interactive Ubuntu environment
    security    Run security scan
    cleanup     Clean up Docker containers and images
    help        Show this help message

Examples:
    $0 all          # Run all tests
    $0 build        # Build containers
    $0 ubuntu       # Run Ubuntu tests only
    $0 interactive  # Start interactive environment
    $0 cleanup      # Clean up containers

EOF
}

# --- Main ---

main() {
    local command="${1:-all}"
    
    case "$command" in
        all)
            check_docker
            check_docker_compose
            build_containers
            run_shellcheck
            run_validation
            run_ubuntu_tests
            run_security_scan
            success "All Docker tests completed successfully!"
            ;;
        build)
            check_docker
            check_docker_compose
            build_containers
            ;;
        shellcheck)
            check_docker
            check_docker_compose
            run_shellcheck
            ;;
        validation)
            check_docker
            check_docker_compose
            run_validation
            ;;
        ubuntu)
            check_docker
            check_docker_compose
            run_ubuntu_tests
            ;;
        interactive)
            check_docker
            check_docker_compose
            run_interactive_ubuntu
            ;;
        security)
            check_docker
            run_security_scan
            ;;
        cleanup)
            check_docker
            check_docker_compose
            cleanup_containers
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Change to repository directory
cd "$REPO_DIR"

# Run main function
main "$@"