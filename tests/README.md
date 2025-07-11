# Catred Config Testing Suite

This directory contains a comprehensive testing framework for the Catred Config cross-platform development environment. The testing suite ensures reliability, consistency, and quality across all supported platforms.

## Overview

The testing framework is designed to validate:
- **Script functionality** across different environments
- **Theme system consistency** across all applications
- **Installation/uninstall workflows** on multiple platforms
- **Configuration integrity** and validation
- **Cross-platform compatibility** and behavior
- **Security and performance** of all components

## Test Structure

```
tests/
├── unit/                   # Unit tests for individual components
│   ├── test_catred_cli.sh       # Tests for main CLI interface
│   ├── test_theme_system.sh     # Tests for theme switching system
│   └── test_health_check.sh     # Tests for health check functionality
├── integration/            # Integration tests for workflows
│   └── test_install_uninstall.sh # Tests for installation processes
├── e2e/                    # End-to-end tests (future expansion)
├── fixtures/               # Test data and configurations
├── docker/                 # Container-based testing
│   ├── Dockerfile.ubuntu        # Ubuntu test environment
│   └── docker-compose.yml       # Container orchestration
├── test_framework.sh       # Core testing framework
├── run_docker_tests.sh     # Docker test runner
└── README.md              # This file
```

## Running Tests

### Local Testing

#### 1. Run All Tests
```bash
./tests/test_framework.sh
```

#### 2. Run Specific Test Categories
```bash
# Unit tests only
./tests/test_framework.sh unit

# Integration tests only
./tests/test_framework.sh integration

# End-to-end tests only
./tests/test_framework.sh e2e
```

#### 3. Run Individual Test Files
```bash
# Test the catred CLI
./tests/unit/test_catred_cli.sh

# Test the theme system
./tests/unit/test_theme_system.sh

# Test install/uninstall workflows
./tests/integration/test_install_uninstall.sh
```

### Docker-Based Testing

#### 1. Run All Docker Tests
```bash
./tests/run_docker_tests.sh all
```

#### 2. Run Specific Docker Tests
```bash
# ShellCheck linting
./tests/run_docker_tests.sh shellcheck

# Configuration validation
./tests/run_docker_tests.sh validation

# Ubuntu container tests
./tests/run_docker_tests.sh ubuntu

# Security scan
./tests/run_docker_tests.sh security
```

#### 3. Interactive Testing Environment
```bash
./tests/run_docker_tests.sh interactive
```

### GitHub Actions CI/CD

Tests are automatically run on:
- **Push** to `main` or `develop` branches
- **Pull requests** to `main` or `develop` branches
- **Release** tag creation (v1.0.0, v1.1.0, etc.)

The CI pipeline includes:
- ShellCheck linting for all shell scripts
- Unit and integration tests
- Cross-platform compatibility tests (Ubuntu, macOS, Windows)
- Configuration validation (YAML/JSON syntax)
- Theme consistency checks across all applications
- Security scanning for vulnerabilities
- Performance tests with timeout limits
- Documentation validation and completeness

## Test Categories

### 1. Unit Tests

Test individual components and functions:

#### **catred CLI** (`test_catred_cli.sh`)
- ✅ Command existence and permissions
- ✅ Help and version commands
- ✅ Error handling for invalid commands
- ✅ Theme command functionality
- ✅ Health command execution
- ✅ Script structure validation
- ✅ Security checks (no dangerous commands)

#### **Theme System** (`test_theme_system.sh`)
- ✅ Theme script functionality
- ✅ Theme directory structure
- ✅ Color file existence and format
- ✅ Terminal configuration completeness
- ✅ Fish shell theme files
- ✅ Theme validation logic
- ✅ Safety mechanisms
- ✅ Invalid theme handling

#### **Health Check** (`test_health_check.sh`)
- ✅ Script existence and permissions
- ✅ Output format validation
- ✅ Test categories coverage
- ✅ Platform detection accuracy
- ✅ Counter management
- ✅ Error handling
- ✅ Function structure validation

### 2. Integration Tests

Test complete workflows and interactions:

#### **Install/Uninstall** (`test_install_uninstall.sh`)
- ✅ Script existence and permissions
- ✅ Platform detection
- ✅ Safety confirmation prompts
- ✅ Backup creation
- ✅ Error handling
- ✅ Script structure validation
- ✅ Package management (install/uninstall)
- ✅ Stow configuration management
- ✅ Shell configuration
- ✅ Safety mechanisms

### 3. Validation Tests

Ensure configuration integrity:

#### **Configuration Validation**
- ✅ YAML file syntax validation
- ✅ JSON file validity checks
- ✅ Required file existence
- ✅ Directory structure validation

#### **Theme Consistency**
- ✅ All themes have required color files
- ✅ Terminal configurations exist for all themes
- ✅ Color definitions are complete
- ✅ Fish theme files present for all themes

### 4. Security Tests

Validate security practices:

#### **Script Security**
- ✅ No dangerous eval usage
- ✅ No insecure curl piping
- ✅ No dangerous rm -rf commands
- ✅ Proper input validation
- ✅ Safe file operations

### 5. Performance Tests

Ensure acceptable performance:

#### **Script Performance**
- ✅ Execution time limits (30s timeout)
- ✅ Resource usage monitoring
- ✅ No hanging processes
- ✅ Startup time validation

### 6. Cross-Platform Tests

Validate multi-platform compatibility:

#### **Platform Support**
- ✅ Ubuntu Linux compatibility
- ✅ macOS compatibility
- ✅ Windows compatibility
- ✅ Script execution across platforms
- ✅ Configuration structure consistency

## Test Framework Features

### Core Testing Functions

```bash
# Test assertions
assert_equals "expected" "actual" "message"
assert_file_exists "/path/to/file" "message"
assert_command_exists "command" "message"
assert_contains "string" "substring" "message"
assert_not_contains "string" "substring" "message"

# Test execution
run_test "test_name" test_function "description"

# Test discovery
discover_tests "/path/to/tests" "test_*.sh"
```

### Test Environment

Each test runs in an isolated environment:
- ✅ Temporary directories for test data
- ✅ Clean environment variables
- ✅ Proper cleanup after completion
- ✅ Consistent logging and reporting

### Test Reporting

Tests generate comprehensive reports:
- ✅ **Console output** with color-coded results
- ✅ **Log files** for detailed analysis (`test_results.log`)
- ✅ **HTML reports** for visual review (`test_report.html`)
- ✅ **Exit codes** for CI/CD integration

## Docker Testing Environment

### Available Services

```bash
# Core testing
docker-compose run ubuntu-test          # Run full test suite
docker-compose run ubuntu-interactive   # Interactive debugging

# Validation services
docker-compose run shellcheck          # Shell script linting
docker-compose run validation          # YAML/JSON validation
docker-compose run security-scan       # Security vulnerability scan
docker-compose run theme-consistency   # Theme completeness check
docker-compose run performance-test    # Performance validation
```

### Container Features

- ✅ **Ubuntu 22.04** base environment
- ✅ **Isolated testing** with volume mounts
- ✅ **Automated setup** with required tools
- ✅ **Interactive debugging** capability
- ✅ **Consistent environment** across runs

## Adding New Tests

### 1. Unit Tests

Create a new test file in `tests/unit/`:

```bash
#!/bin/bash
# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test functions
test_my_feature() {
    assert_file_exists "$REPO_DIR/scripts/my_script.sh" "My script should exist"
    
    local output
    output=$(my_command 2>&1)
    assert_contains "$output" "expected" "Should contain expected output"
}

# Run tests
run_test "my_feature" test_my_feature "Test my feature functionality"
```

### 2. Integration Tests

Create a new test file in `tests/integration/`:

```bash
#!/bin/bash
# Source the test framework
source "$(dirname "${BASH_SOURCE[0]}")/../test_framework.sh"

# Test workflow
test_my_workflow() {
    local output
    output=$(my_workflow_command 2>&1)
    assert_contains "$output" "success" "Workflow should complete successfully"
}

# Run tests
run_test "my_workflow" test_my_workflow "Test my workflow integration"
```

### 3. Make Tests Executable

```bash
chmod +x tests/unit/test_my_feature.sh
chmod +x tests/integration/test_my_workflow.sh
```

## Continuous Integration

### GitHub Actions Workflows

#### 1. Test Workflow (`.github/workflows/test.yml`)
Comprehensive testing pipeline including:
- ✅ **ShellCheck linting** for all shell scripts
- ✅ **Unit tests** for individual components
- ✅ **Integration tests** for workflows
- ✅ **Cross-platform testing** (Ubuntu, macOS, Windows)
- ✅ **Configuration validation** (YAML/JSON)
- ✅ **Theme consistency** checks
- ✅ **Security scanning** for vulnerabilities
- ✅ **Performance testing** with timeouts
- ✅ **Documentation validation**
- ✅ **Full test suite** execution
- ✅ **Test result artifacts** upload

#### 2. Release Workflow (`.github/workflows/release.yml`)
Automated release pipeline including:
- ✅ **Multi-platform release testing**
- ✅ **Full test suite validation**
- ✅ **Asset generation** and checksums
- ✅ **Security scanning** before release
- ✅ **Documentation validation**
- ✅ **Post-release validation**

### Quality Gates

All tests must pass before:
- ✅ **Merging pull requests**
- ✅ **Creating releases**
- ✅ **Deploying changes**

## Best Practices

### Writing Tests

1. **Test Independence**: Each test should be independent and isolated
2. **Clear Assertions**: Use descriptive assertion messages
3. **Error Handling**: Test both success and failure cases
4. **Resource Cleanup**: Clean up temporary files and processes
5. **Platform Awareness**: Consider platform-specific behavior

### Test Organization

1. **Logical Grouping**: Group related tests together
2. **Naming Convention**: Use descriptive test names
3. **Documentation**: Document test purpose and expectations
4. **Maintainability**: Keep tests simple and focused

### Performance Considerations

1. **Execution Speed**: Keep tests fast and efficient
2. **Resource Usage**: Monitor memory and CPU usage
3. **Parallel Execution**: Design tests for parallel running
4. **Timeout Handling**: Use appropriate timeouts

## Test Coverage

### Current Coverage

- ✅ **CLI Interface**: 9 tests covering all main commands
- ✅ **Theme System**: 11 tests covering theme functionality
- ✅ **Health Check**: 12 tests covering validation logic
- ✅ **Install/Uninstall**: 17 tests covering complete workflows
- ✅ **Configuration**: Validation for all YAML/JSON files
- ✅ **Security**: Comprehensive security scanning
- ✅ **Performance**: Timeout-based performance validation
- ✅ **Cross-Platform**: Testing on Ubuntu, macOS, Windows

### Total Test Count: 49+ individual tests

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure test files are executable (`chmod +x`)
2. **Path Issues**: Use absolute paths in tests
3. **Environment Variables**: Set required environment variables
4. **Dependencies**: Install required tools and packages
5. **Docker Issues**: Ensure Docker is running and accessible

### Debug Mode

Run tests with debug output:
```bash
DEBUG=1 ./tests/test_framework.sh
```

### Verbose Logging

Enable verbose logging:
```bash
VERBOSE=1 ./tests/test_framework.sh
```

### Test Isolation

Run tests in Docker for isolation:
```bash
./tests/run_docker_tests.sh interactive
```

## Contributing

When contributing to the testing suite:

1. ✅ **Add tests** for new features
2. ✅ **Update existing tests** when modifying functionality
3. ✅ **Follow conventions** established in existing tests
4. ✅ **Document test purpose** and expected behavior
5. ✅ **Ensure tests pass** in CI/CD pipeline
6. ✅ **Test cross-platform** compatibility

## Support

For testing-related questions:
- 📖 Check existing test implementations
- 🔍 Review test framework documentation
- 🧪 Run tests locally before submitting PRs
- 🐛 Use interactive Docker environment for debugging
- 💬 Ask questions in GitHub discussions

---

**The Catred Config testing suite provides comprehensive validation ensuring reliability, security, and consistency across all supported platforms.**