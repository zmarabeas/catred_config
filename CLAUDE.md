# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Catred Config is a production-ready cross-platform development environment achieving 80-90% workflow consistency across macOS, Linux, and Windows. It provides i3-style tiling window management with unified theming, keyboard-driven workflows, and modern development tools.

## Key Commands

### Build and Test Commands
```bash
# Run comprehensive test suite
./tests/test_framework.sh

# Run specific test types
./tests/test_framework.sh unit
./tests/test_framework.sh integration
./tests/test_framework.sh e2e

# Run specific test files
./tests/unit/test_catred_cli.sh
./tests/unit/test_health_check.sh  
./tests/unit/test_theme_system.sh
./tests/integration/test_install_uninstall.sh

# Run Docker-based cross-platform tests
./tests/run_docker_tests.sh all
```

### Configuration Management
```bash
# Main CLI interface
./scripts/catred help                    # Show all commands
./scripts/catred health                  # System health check
./scripts/catred theme [name]            # Switch themes or show current
./scripts/catred update                  # Update all components
./scripts/catred sync                    # Sync configs back to repo
./scripts/catred install                 # Run installation
./scripts/catred uninstall               # Remove everything

# Direct script execution
./scripts/config/switch-theme.sh [theme]     # Switch themes
./scripts/maintenance/health-check.sh        # Validate installation
./scripts/maintenance/update-all.sh          # Update all components
./scripts/maintenance/sync-configs.sh        # Sync configs
./scripts/maintenance/backup-settings.sh     # Backup settings
```

### Installation Commands
```bash
# Bootstrap installation (detects OS automatically)
./scripts/install/bootstrap.sh

# Platform-specific installation
./scripts/install/macos-install.sh
./scripts/install/linux-install.sh
./scripts/install/windows-install.ps1
```

## Architecture

### Core System Design
Catred Config implements a **unified management layer** over platform-specific tools:
- **Single repository** containing all configurations, scripts, and management tools
- **GNU Stow** for symlink-based configuration management
- **Centralized CLI** (`./scripts/catred`) that delegates to specialized scripts
- **Platform detection** with automatic OS-specific behavior
- **Unified theme system** with cross-application coordination

### CLI Architecture Workflow
The `./scripts/catred` command acts as a dispatcher:
1. **Command parsing** determines which subcommand to execute
2. **Validation** ensures required scripts exist and are executable
3. **Delegation** to specialized scripts in `scripts/` subdirectories
4. **Error handling** with consistent user feedback and exit codes

### Platform Support Matrix
| Platform | Window Manager | Status Bar | Launcher | Terminal |
|----------|---------------|------------|----------|----------|
| macOS | yabai + skhd | SketchyBar | Raycast | Ghostty/Warp |
| Linux | i3/sway | polybar | rofi | Ghostty/Warp |
| Windows | komorebi + whkd | yasb | Flow Launcher | Ghostty/Warp |

**Common Components**:
- **Shell**: Fish with modern features, aliases, and functions
- **Primary Editor**: Neovim with lazy.nvim plugin management
- **Secondary Editor**: Zed for debugging and quick edits
- **Terminals**: Ghostty (primary), Warp, Kitty, Alacritty support

### Theme System Architecture
The theme system achieves cross-application consistency through:
- **Centralized color definitions** in `configs/{theme}/colors.yaml`
- **Application-specific theme files** in `configs/{app}/{theme}.ext`
- **Coordinated switching** via `./scripts/config/switch-theme.sh`
- **State tracking** through `~/.config/catred_config/current_theme`

**Theme Switching Process**:
1. **Theme validation** against `AVAILABLE_THEMES` array
2. **State update** in `~/.config/catred_config/current_theme`
3. **Multi-application coordination**:
   - Terminal themes (Ghostty, Warp, Kitty, Alacritty)
   - Editor themes (Neovim, Zed)
   - Window manager themes (platform-specific)
   - Status bar themes (platform-specific)
4. **Application reload** for immediate theme application

### Configuration Management Workflow
- **Source-controlled configs** in `configs/` directory
- **GNU Stow symlinks** to appropriate locations (`~/.config/`, etc.)
- **Platform-specific templates** for OS variations
- **Backup system** creates safety copies before changes
- **Health validation** ensures configuration integrity

### Installation Bootstrap Process
`./scripts/install/bootstrap.sh` orchestrates the entire setup:
1. **OS detection** via `uname -s`
2. **Platform-specific delegation** to appropriate installer
3. **Dependency installation** via system package managers
4. **Configuration deployment** using GNU Stow
5. **Theme application** using the unified theme system
6. **Validation** through health checks

## Development Workflow

### Testing Requirements
- **All changes must include tests** - unit, integration, or e2e
- **Tests must pass** before PR approval
- **Run tests locally** before pushing changes
- **CI/CD validation** via GitHub Actions

### Testing Framework Architecture
The custom test framework (`tests/test_framework.sh`) provides:
- **Assertion library** with functions like `assert_equals`, `assert_file_exists`, `assert_command_exists`
- **Test isolation** using temporary directories for each test
- **Colored output** with pass/fail/skip indicators
- **Test categorization** into unit, integration, and e2e
- **Docker-based testing** for cross-platform validation
- **Performance monitoring** with timeout limits

### Code Quality
- **ShellCheck** linting for all shell scripts
- **YAML/JSON validation** for configuration files
- **Security scanning** for common vulnerabilities
- **Performance testing** with timeout limits

### Theme Development
When adding new themes:
1. Create color definition in `configs/{theme}/colors.yaml`
2. Create theme files for each supported application
3. Update `AVAILABLE_THEMES` array in `scripts/config/switch-theme.sh`
4. Add theme loading logic to Fish config and other applications
5. Test theme switching across all platforms

### Configuration Changes
When modifying configurations:
1. Update source files in `configs/` directory
2. Test across all supported platforms
3. Validate with `./scripts/catred health`
4. Run comprehensive test suite
5. Update documentation if needed

## File Organization

### Critical Files
- `scripts/catred` - Main CLI interface and command dispatcher
- `scripts/config/switch-theme.sh` - Theme switching system with multi-app coordination
- `scripts/maintenance/health-check.sh` - System validation with comprehensive checks
- `tests/test_framework.sh` - Custom test framework with assertion library
- `configs/nvim/init.lua` - Neovim configuration entry point
- `configs/fish/config.fish` - Fish shell configuration with theme loading

### Theme Files Location
- Color definitions: `configs/{theme}/colors.yaml`
- Terminal themes: `configs/terminals/{terminal}/{theme}.{ext}`
- Editor themes: Applied via theme switching logic
- Window manager themes: Integrated into platform-specific configs

### Test Organization
- `tests/unit/` - Unit tests for individual components (CLI, theme system, health checks)
- `tests/integration/` - Integration tests for workflows (install/uninstall, theme switching)
- `tests/e2e/` - End-to-end tests for complete user workflows
- `tests/docker/` - Docker-based cross-platform tests

## CI/CD Pipeline

The `.github/workflows/test.yml` runs:
- **ShellCheck** linting on all shell scripts
- **Unit tests** for core components (49+ individual tests)
- **Integration tests** for installation/uninstall workflows
- **Cross-platform tests** on Ubuntu, macOS, Windows
- **Configuration validation** for YAML/JSON files
- **Theme consistency** checking across all applications
- **Security scanning** for vulnerabilities
- **Performance testing** with timeouts
- **Documentation completeness** validation

### Platform-Specific Implementation Details
- **macOS**: Uses `uname -s` detection, may require SIP adjustments for yabai
- **Linux**: Supports both X11 (i3) and Wayland (sway), uses `apt` for dependencies
- **Windows**: Uses PowerShell execution policy bypass, `winget` + Chocolatey for packages

## Important Notes

### Testing Procedures
When making changes, always run the test suite locally:
```bash
./tests/test_framework.sh
```

After pushing changes, monitor GitHub Actions workflows to ensure all checks pass.

### Security
- No hardcoded credentials in configurations
- Secure file permissions for sensitive data
- Regular security updates for all tools
- Execution policy considerations for Windows scripts

### Platform Considerations
- **macOS**: May require SIP adjustments for yabai
- **Linux**: Supports both X11 (i3) and Wayland (sway)
- **Windows**: Requires execution policy changes for PowerShell scripts

## Troubleshooting

### Common Issues
1. **Symlink failures**: Check GNU Stow installation and permissions
2. **Theme not applying**: Verify theme files exist and are readable
3. **Health check failures**: Review component installations
4. **Test failures**: Check platform-specific dependencies

### Debugging
- Use `./scripts/catred health` for system validation
- Check log files in `tests/test_results.log`
- Review CI/CD pipeline outputs for detailed errors
- Verify theme files exist for all supported applications

## Quick Reference for Future Claude Instances

### Entry Points
- **Main CLI**: `./scripts/catred` - Command dispatcher and primary interface
- **Theme System**: `./scripts/config/switch-theme.sh` - Multi-application theme coordination
- **Testing**: `./tests/test_framework.sh` - Custom test framework with comprehensive coverage
- **Installation**: `./scripts/install/bootstrap.sh` - OS detection and platform-specific setup

### Key Workflows
- **Theme Switching**: Validates theme → Updates state file → Applies to all applications → Reloads services
- **CLI Command Flow**: Parse command → Validate script exists → Delegate to specialized script → Handle errors
- **Bootstrap Installation**: Detect OS → Run platform installer → Deploy configs via Stow → Apply theme → Validate
- **Testing**: Isolate environment → Run assertions → Categorize results → Report with colored output

### Critical Understanding
- The system is a **unified management layer** over platform-specific tools
- Theme consistency is achieved through **centralized coordination** across all applications
- GNU Stow provides **symlink-based configuration management** from a single source
- The CLI uses a **delegation pattern** rather than implementing functionality directly
- Testing uses **custom framework** with Docker-based cross-platform validation
- **AI agent files** are ignored via .gitignore patterns (`*.ai.md`, `*.agent.md`, etc.)

### Development Notes
- AI agent files (planning, notes, etc.) use `.ai.md` extension and are gitignored
- Development artifacts like `release-plan.md` are renamed to `release-plan.ai.md`
- The .gitignore includes comprehensive patterns for OS files, editors, and build artifacts
- SPECIFICATION.md remains tracked as it's referenced in CI workflows