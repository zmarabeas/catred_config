#!/bin/bash
#
# Catred Config Testing Framework
#
# A comprehensive testing framework for validating the Catred Config
# cross-platform development environment.
#

# Don't use set -e in test framework to allow tests to fail gracefully

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_LOG="$SCRIPT_DIR/test_results.log"

# CI environment detection
CI_MODE=false
if [[ -n "$CI" || -n "$GITHUB_ACTIONS" || -n "$TRAVIS" || -n "$CIRCLECI" || -n "$JENKINS_URL" ]]; then
    CI_MODE=true
    echo "[DEBUG] CI environment detected: CI=$CI, GITHUB_ACTIONS=$GITHUB_ACTIONS"
fi

# Colors for output (disabled in CI for better parsing)
if [[ "$CI_MODE" == "true" ]]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    PURPLE=''
    AQUA=''
    NC=''
    echo "[DEBUG] Colors disabled for CI environment"
else
    RED='\033[38;2;204;36;29m'
    GREEN='\033[38;2;152;151;26m'
    YELLOW='\033[38;2;215;153;33m'
    BLUE='\033[38;2;69;133;136m'
    PURPLE='\033[38;2;177;98;134m'
    AQUA='\033[38;2;104;157;106m'
    NC='\033[0m'
fi

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Verbose mode flag
VERBOSE_MODE=false

# --- Logging Functions ---
log() { echo -e "$*" | tee -a "$TEST_LOG"; }
info() { log "${AQUA}[INFO]${NC} $*"; }
pass() { log "${GREEN}[PASS]${NC} $*"; ((PASSED_TESTS++)) || true; }
fail() { log "${RED}[FAIL]${NC} $*"; ((FAILED_TESTS++)) || true; }
skip() { log "${YELLOW}[SKIP]${NC} $*"; ((SKIPPED_TESTS++)) || true; }
warn() { log "${YELLOW}[WARN]${NC} $*"; }
verbose() { [[ "$VERBOSE_MODE" == "true" ]] && log "${BLUE}[VERBOSE]${NC} $*"; }

# --- Test Framework Functions ---
run_test() {
    local test_name="$1"
    local test_function="$2"
    local test_description="$3"
    
    ((TOTAL_TESTS++)) || true
    
    printf "%-60s" "$test_description"
    
    # Start timing
    local start_time
    start_time=$(date +%s.%N)
    
    # Create isolated test environment
    local test_temp_dir=$(mktemp -d)
    
    # Temporarily disable exit on error for test function execution
    set +e
    if [[ "$VERBOSE_MODE" == "true" ]]; then
        verbose "Running test function: $test_function"
        local test_output
        test_output=$("$test_function" 2>&1)
        local test_result=$?
        if [[ $test_result -ne 0 && -n "$test_output" ]]; then
            verbose "Test output: $test_output"
        fi
    else
        "$test_function" 2>/dev/null
        local test_result=$?
    fi
    set -e
    
    # Calculate timing (use bash arithmetic instead of bc for CI compatibility)
    local end_time duration
    end_time=$(date +%s.%N)
    if command -v bc &> /dev/null; then
        duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0.000")
    else
        # Fallback to bash arithmetic (less precise but works in CI)
        local start_sec end_sec
        start_sec=${start_time%.*}
        end_sec=${end_time%.*}
        duration=$((end_sec - start_sec))
        [[ $duration -eq 0 ]] && duration="<1"
    fi
    
    if [[ $test_result -eq 0 ]]; then
        if [[ "$VERBOSE_MODE" == "true" ]]; then
            echo -e "[${GREEN}PASS${NC}] (${duration}s)"
        else
            echo -e "[${GREEN}PASS${NC}]"
        fi
        ((PASSED_TESTS++)) || true
    else
        if [[ "$VERBOSE_MODE" == "true" ]]; then
            echo -e "[${RED}FAIL${NC}] (${duration}s)"
        else
            echo -e "[${RED}FAIL${NC}]"
        fi
        ((FAILED_TESTS++)) || true
    fi
    
    # Clean up test temp directory
    rm -rf "$test_temp_dir"
}

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"
    
    verbose "assert_equals: expected='$expected', actual='$actual'"
    
    if [[ "$expected" == "$actual" ]]; then
        verbose "✓ Assertion passed: $message"
        return 0
    else
        fail "$message"
        fail "  Expected: '$expected'"
        fail "  Actual:   '$actual'"
        [[ "$VERBOSE_MODE" == "true" ]] && fail "  Diff: $(diff -u <(echo "$expected") <(echo "$actual") || true)"
        return 1
    fi
}

assert_file_exists() {
    local file_path="$1"
    local message="${2:-File should exist}"
    
    verbose "assert_file_exists: checking '$file_path'"
    
    if [[ -f "$file_path" ]]; then
        verbose "✓ File exists: $file_path"
        return 0
    else
        fail "$message: $file_path does not exist"
        [[ "$VERBOSE_MODE" == "true" ]] && fail "  Parent directory: $(dirname "$file_path")"
        [[ "$VERBOSE_MODE" == "true" ]] && fail "  Directory contents: $(ls -la "$(dirname "$file_path")" 2>/dev/null || echo "directory not accessible")"
        return 1
    fi
}

assert_command_exists() {
    local command="$1"
    local message="${2:-Command should exist}"
    
    verbose "assert_command_exists: checking '$command'"
    
    if command -v "$command" &> /dev/null; then
        verbose "✓ Command exists: $command at $(command -v "$command")"
        return 0
    else
        fail "$message: command '$command' not found"
        [[ "$VERBOSE_MODE" == "true" ]] && fail "  PATH: $PATH"
        return 1
    fi
}

assert_contains() {
    local string="$1"
    local substring="$2"
    local message="${3:-String should contain substring}"
    
    verbose "assert_contains: looking for '$substring' in string of length ${#string}"
    
    if [[ "$string" == *"$substring"* ]]; then
        verbose "✓ String contains substring: $message"
        return 0
    else
        fail "$message: string does not contain '$substring'"
        if [[ "$VERBOSE_MODE" == "true" ]]; then
            fail "  String length: ${#string} characters"
            fail "  String preview: ${string:0:200}..."
            fail "  Looking for: '$substring'"
        fi
        return 1
    fi
}

assert_not_contains() {
    local string="$1"
    local substring="$2"
    local message="${3:-String should not contain substring}"
    
    verbose "assert_not_contains: ensuring '$substring' is NOT in string of length ${#string}"
    
    if [[ "$string" != *"$substring"* ]]; then
        verbose "✓ String does not contain substring: $message"
        return 0
    else
        fail "$message: string contains '$substring'"
        if [[ "$VERBOSE_MODE" == "true" ]]; then
            fail "  String length: ${#string} characters"
            fail "  String preview: ${string:0:200}..."
            fail "  Found unwanted: '$substring'"
        fi
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
    local suite_start_time
    suite_start_time=$(date +%s.%N)
    
    local test_files
    test_files=$(discover_tests "$test_dir")
    
    if [[ -z "$test_files" ]]; then
        warn "No test files found in $test_dir"
        return 0
    fi
    
    while IFS= read -r test_file; do
        if [[ -x "$test_file" ]]; then
            info "Executing test file: $(basename "$test_file")"
            local test_output
            set +e  # Don't exit on test file failure
            test_output=$(bash "$test_file" 2>&1)
            local test_exit_code=$?
            set -e
            
            # Parse test results from output (robust parsing for CI and local)
            local pass_count fail_count clean_output
            
            # Strip ANSI color codes for better parsing in CI
            clean_output=$(echo "$test_output" | sed 's/\x1b\[[0-9;]*m//g' 2>/dev/null || echo "$test_output")
            
            # Count PASS/FAIL patterns (case insensitive, multiple methods)
            pass_count=$(echo "$clean_output" | grep -ci "PASS" 2>/dev/null || echo "0")
            fail_count=$(echo "$clean_output" | grep -ci "FAIL" 2>/dev/null || echo "0")
            
            # Ensure we have valid numbers
            [[ "$pass_count" =~ ^[0-9]+$ ]] || pass_count=0
            [[ "$fail_count" =~ ^[0-9]+$ ]] || fail_count=0
            
            # Debug output for CI
            if [[ "$CI_MODE" == "true" ]]; then
                echo "[DEBUG] Test file: $(basename "$test_file")"
                echo "[DEBUG] Exit code: $test_exit_code"
                echo "[DEBUG] PASS count: $pass_count"
                echo "[DEBUG] FAIL count: $fail_count"
                echo "[DEBUG] Output length: ${#test_output} chars"
                if [[ ${#test_output} -lt 200 ]]; then
                    echo "[DEBUG] Full output: $test_output"
                else
                    echo "[DEBUG] Output preview: ${test_output:0:200}..."
                fi
            fi
            
            # Update global counters
            ((TOTAL_TESTS += pass_count + fail_count)) || true
            ((PASSED_TESTS += pass_count)) || true
            ((FAILED_TESTS += fail_count)) || true
            
            # Determine success based on PASS/FAIL count, not exit code
            if [[ $fail_count -eq 0 ]]; then
                info "Test file $(basename "$test_file") completed successfully ($pass_count passed, $fail_count failed)"
            else
                warn "Test file $test_file had failures ($pass_count passed, $fail_count failed)"
                if [[ "$VERBOSE_MODE" == "true" ]]; then
                    info "--- Failed test output ---"
                    echo "$test_output" | grep -A 5 -B 1 "FAIL" || true
                    info "--- End failed test output ---"
                fi
            fi
        else
            warn "Test file not executable: $test_file"
        fi
    done <<< "$test_files"
    
    # Calculate suite timing (use bash arithmetic instead of bc for CI compatibility)
    local suite_end_time suite_duration
    suite_end_time=$(date +%s.%N)
    if command -v bc &> /dev/null; then
        suite_duration=$(echo "$suite_end_time - $suite_start_time" | bc -l 2>/dev/null || echo "0.000")
    else
        # Fallback to bash arithmetic (less precise but works in CI)
        local start_sec end_sec
        start_sec=${suite_start_time%.*}
        end_sec=${suite_end_time%.*}
        suite_duration=$((end_sec - start_sec))
        [[ $suite_duration -eq 0 ]] && suite_duration="<1"
    fi
    
    if [[ "$VERBOSE_MODE" == "true" ]]; then
        info "$test_suite tests completed in ${suite_duration}s"
    fi
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
show_test_help() {
    cat << EOF
Catred Config Test Framework

USAGE:
    ./tests/test_framework.sh [OPTIONS] [SUITE]

SUITES:
    unit            Run unit tests only
    integration     Run integration tests only  
    e2e             Run end-to-end tests only
    all             Run all test suites (default)

OPTIONS:
    -v, --verbose   Enable verbose output with detailed failure information
    -h, --help      Show this help message

EXAMPLES:
    ./tests/test_framework.sh                    # Run all tests
    ./tests/test_framework.sh unit               # Run unit tests only
    ./tests/test_framework.sh --verbose unit     # Run unit tests with verbose output
    ./tests/test_framework.sh -v                 # Run all tests with verbose output

EOF
}

main() {
    rm -f "$TEST_LOG"
    
    # Enhanced logging for CI debugging
    if [[ "$CI_MODE" == "true" ]]; then
        echo "[DEBUG] === CI Environment Information ==="
        echo "[DEBUG] Working directory: $(pwd)"
        echo "[DEBUG] Script directory: $SCRIPT_DIR"
        echo "[DEBUG] Repository directory: $REPO_DIR"
        echo "[DEBUG] Environment variables:"
        echo "[DEBUG]   CI: $CI"
        echo "[DEBUG]   GITHUB_ACTIONS: $GITHUB_ACTIONS"
        echo "[DEBUG]   TERM: $TERM"
        echo "[DEBUG]   PATH: $PATH"
        echo "[DEBUG] Available commands:"
        echo "[DEBUG]   bash: $(command -v bash || echo 'not found')"
        echo "[DEBUG]   grep: $(command -v grep || echo 'not found')"
        echo "[DEBUG]   sed: $(command -v sed || echo 'not found')"
        echo "[DEBUG] === End CI Information ==="
    fi
    
    info "Starting Catred Config Test Suite"
    info "======================================"
    
    # Check test environment - be more flexible about repository structure
    verbose "Checking repository structure..."
    verbose "REPO_DIR: $REPO_DIR"
    verbose "Current directory: $(pwd)"
    
    # In CI, be more lenient about repository structure
    if [[ -n "$CI" || -n "$GITHUB_ACTIONS" ]]; then
        verbose "Running in CI environment - skipping strict repository checks"
    else
        verbose "Files in repo root: $(ls -la "$REPO_DIR" 2>/dev/null | head -5 || echo 'cannot list directory')"
        if [[ ! -f "$REPO_DIR/README.md" ]]; then
            fail "Not in Catred Config repository root (README.md)"
            verbose "Available files: $(ls -la "$REPO_DIR" 2>/dev/null || echo 'cannot list directory')"
            exit 1
        fi
    fi
    
    # Parse command line arguments
    local target_suite="all"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE_MODE=true
                verbose "Verbose mode enabled"
                shift
                ;;
            -h|--help)
                show_test_help
                exit 0
                ;;
            unit|integration|e2e|all)
                target_suite="$1"
                shift
                ;;
            *)
                if [[ -z "$target_suite" || "$target_suite" == "all" ]]; then
                    target_suite="$1"
                fi
                shift
                ;;
        esac
    done
    
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