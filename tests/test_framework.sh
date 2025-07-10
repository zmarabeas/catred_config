#!/bin/bash
#
# Catred Config Testing Framework
#
# A comprehensive testing framework for validating the Catred Config
# cross-platform development environment.
#

set -eE

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_LOG="$SCRIPT_DIR/test_results.log"

# Colors for output
RED='\033[38;2;204;36;29m'
GREEN='\033[38;2;152;151;26m'
YELLOW='\033[38;2;215;153;33m'
BLUE='\033[38;2;69;133;136m'
PURPLE='\033[38;2;177;98;134m'
AQUA='\033[38;2;104;157;106m'
NC='\033[0m'

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# --- Logging Functions ---
log() { echo -e "$*" | tee -a "$TEST_LOG"; }
info() { log "${AQUA}[INFO]${NC} $*"; }
pass() { log "${GREEN}[PASS]${NC} $*"; ((PASSED_TESTS++)); }
fail() { log "${RED}[FAIL]${NC} $*"; ((FAILED_TESTS++)); }
skip() { log "${YELLOW}[SKIP]${NC} $*"; ((SKIPPED_TESTS++)); }
warn() { log "${YELLOW}[WARN]${NC} $*"; }

# --- Test Framework Functions ---
run_test() {
    local test_name="$1"
    local test_function="$2"
    local test_description="$3"
    
    ((TOTAL_TESTS++))
    
    printf "%-60s" "$test_description"
    
    # Create isolated test environment
    local test_temp_dir=$(mktemp -d)
    trap "rm -rf '$test_temp_dir'" EXIT
    
    if "$test_function" 2>/dev/null; then
        echo -e "[${GREEN}PASS${NC}]"
        ((PASSED_TESTS++))
    else
        echo -e "[${RED}FAIL${NC}]"
        ((FAILED_TESTS++))
    fi
}

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"
    
    if [[ "$expected" == "$actual" ]]; then
        return 0
    else
        fail "$message: expected '$expected', got '$actual'"
        return 1
    fi
}

assert_file_exists() {
    local file_path="$1"
    local message="${2:-File should exist}"
    
    if [[ -f "$file_path" ]]; then
        return 0
    else
        fail "$message: $file_path does not exist"
        return 1
    fi
}

assert_command_exists() {
    local command="$1"
    local message="${2:-Command should exist}"
    
    if command -v "$command" &> /dev/null; then
        return 0
    else
        fail "$message: command '$command' not found"
        return 1
    fi
}

assert_contains() {
    local string="$1"
    local substring="$2"
    local message="${3:-String should contain substring}"
    
    if [[ "$string" == *"$substring"* ]]; then
        return 0
    else
        fail "$message: '$string' does not contain '$substring'"
        return 1
    fi
}

assert_not_contains() {
    local string="$1"
    local substring="$2"
    local message="${3:-String should not contain substring}"
    
    if [[ "$string" != *"$substring"* ]]; then
        return 0
    else
        fail "$message: '$string' contains '$substring'"
        return 1
    fi
}

# --- Test Discovery ---
discover_tests() {
    local test_dir="$1"
    local test_pattern="${2:-test_*.sh}"
    
    find "$test_dir" -name "$test_pattern" -type f 2>/dev/null | sort
}

# --- Test Execution ---
run_test_suite() {
    local test_suite="$1"
    local test_dir="$2"
    
    info "Running $test_suite tests..."
    
    local test_files
    test_files=$(discover_tests "$test_dir")
    
    if [[ -z "$test_files" ]]; then
        warn "No test files found in $test_dir"
        return 0
    fi
    
    while IFS= read -r test_file; do
        if [[ -x "$test_file" ]]; then
            info "Executing test file: $(basename "$test_file")"
            if bash "$test_file"; then
                info "Test file $(basename "$test_file") completed successfully"
            else
                warn "Test file $test_file failed"
            fi
        else
            warn "Test file not executable: $test_file"
        fi
    done <<< "$test_files"
}

# --- Test Report ---
generate_test_report() {
    local report_file="$SCRIPT_DIR/test_report.html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Catred Config Test Report</title>
    <style>
        body { font-family: monospace; margin: 20px; background: #282828; color: #ebdbb2; }
        .pass { color: #98971a; }
        .fail { color: #cc241d; }
        .skip { color: #d79921; }
        .summary { background: #3c3836; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .log { background: #1d2021; padding: 10px; border-radius: 5px; white-space: pre-wrap; }
        h1, h2 { color: #fb4934; }
    </style>
</head>
<body>
    <h1>Catred Config Test Report</h1>
    <div class="summary">
        <h2>Summary</h2>
        <p>Total Tests: $TOTAL_TESTS</p>
        <p class="pass">Passed: $PASSED_TESTS</p>
        <p class="fail">Failed: $FAILED_TESTS</p>
        <p class="skip">Skipped: $SKIPPED_TESTS</p>
        <p>Success Rate: $(( TOTAL_TESTS > 0 ? PASSED_TESTS * 100 / TOTAL_TESTS : 0 ))%</p>
    </div>
    
    <h2>Test Log</h2>
    <div class="log">
$(cat "$TEST_LOG" 2>/dev/null || echo "No test log available")
    </div>
</body>
</html>
EOF
    
    info "Test report generated: $report_file"
}

# --- Main Test Runner ---
main() {
    rm -f "$TEST_LOG"
    info "Starting Catred Config Test Suite"
    info "======================================"
    
    # Check test environment
    if [[ ! -f "$REPO_DIR/CLAUDE.md" ]]; then
        fail "Not in Catred Config repository root"
        exit 1
    fi
    
    # Parse command line arguments
    local target_suite="${1:-all}"
    
    case "$target_suite" in
        unit)
            run_test_suite "unit" "$SCRIPT_DIR/unit"
            ;;
        integration)
            run_test_suite "integration" "$SCRIPT_DIR/integration"
            ;;
        e2e)
            run_test_suite "e2e" "$SCRIPT_DIR/e2e"
            ;;
        all|*)
            # Run different test suites
            local test_suites=(
                "unit:$SCRIPT_DIR/unit"
                "integration:$SCRIPT_DIR/integration"
                "e2e:$SCRIPT_DIR/e2e"
            )
            
            for suite_info in "${test_suites[@]}"; do
                local suite_name="${suite_info%%:*}"
                local suite_dir="${suite_info##*:}"
                
                if [[ -d "$suite_dir" ]]; then
                    run_test_suite "$suite_name" "$suite_dir"
                else
                    warn "Test suite directory not found: $suite_dir"
                fi
            done
            ;;
    esac
    
    # Generate summary
    info "======================================"
    info "Test Summary:"
    info "  Total: $TOTAL_TESTS"
    info "  Passed: $PASSED_TESTS"
    info "  Failed: $FAILED_TESTS"
    info "  Skipped: $SKIPPED_TESTS"
    
    if [[ $FAILED_TESTS -gt 0 ]]; then
        fail "Some tests failed!"
        generate_test_report
        exit 1
    else
        pass "All tests passed!"
        generate_test_report
    fi
}

# Allow sourcing for test utilities
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi