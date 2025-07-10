# Catred Config Workflow Guide

This guide provides an overview of the day-to-day workflow for the Catred Config environment. It covers the keybinding philosophy and common tasks for window management, application launching, and development.

## Keybinding Philosophy

The entire system is built around a consistent, `i3`-style, `Alt`-based keybinding system. The `Alt` key is the primary modifier for all window management actions, providing a unified experience whether you are on macOS, Linux, or Windows.

- **Navigation**: `Alt + h/j/k/l` is used to focus windows, just like Vim.
- **Movement**: `Alt + Shift + h/j/k/l` moves the focused window.
- **Workspaces**: `Alt + [1-9]` switches workspaces, and `Alt + Shift + [1-9]` moves windows to them.

## Core Workflows

### Window & Workspace Management

- **Focusing Windows**: `Alt + h/j/k/l`
- **Moving Windows**: `Alt + Shift + h/j/k/l`
- **Splitting Windows**: The window manager defaults to a binary space partitioning layout. New windows will automatically create a split.
- **Changing Layout**: Refer to the platform-specific documentation for changing between tiling, stacking, and floating layouts.
- **Switching Workspaces**: `Alt + 1-9`
- **Moving Window to Workspace**: `Alt + Shift + 1-9`

### Application & Theme Management

- **Open Terminal**: `Alt + Enter` (opens Ghostty or your configured default)
- **Open App Launcher**: `Alt + d` (opens Raycast, Rofi, or Flow Launcher)
- **Close Window**: `Alt + Shift + q`
- **Switch System Theme**: Use the unified `catred` CLI command:
  ```bash
  # Show current theme and available options
  catred theme
  
  # Switch to a specific theme
  catred theme gruvbox
  catred theme tokyo-night-storm
  catred theme catppuccin-macchiato
  ```

### System Management

The `catred` command provides unified management for your development environment:

- **Check System Health**: `catred health` - Validates all components are installed and configured correctly
- **Update All Components**: `catred update` - Updates system packages, Neovim plugins, and other components
- **Sync Configuration**: `catred sync` - Syncs local configuration changes back to the repository
- **Reinstall Everything**: `catred install` - Runs the full installation process
- **Remove All Components**: `catred uninstall` - Cleanly removes all installed components

### Alternative: Direct Script Usage

If you prefer to run scripts directly:
```bash
# Theme switching
./scripts/config/switch-theme.sh [theme-name]

# System health check
./scripts/maintenance/health-check.sh

# Update all components
./scripts/maintenance/update-all.sh
```

## Development Workflow

### The Editors: Neovim & Zed

This environment is configured with two powerful editors, each with a specific purpose.

- **Neovim (Primary Editor)**: Your day-to-day editor for all coding tasks. It's configured to be a lightweight, fast, and full-featured IDE.
  - **Finding Files**: Use Telescope with `Space + fw` (find files) or `Space + fg` (find text in files).
  - **LSP**: Language server features like diagnostics, code actions (`Space + ca`), and renaming (`Space + rn`) are available out of the box.
  - **File Tree**: Toggle the file tree with `Space + e`.

- **Zed (Secondary Editor)**: Use Zed when you need a more graphical interface, especially for complex debugging or collaboration.
  - **Switching**: Simply open your project in Zed (`zed .`). The configuration and themes are already consistent with the rest of the system.

### The Shell: Fish

The Fish shell provides a modern, user-friendly experience out of the box.

- **Autosuggestions**: Start typing a command, and Fish will suggest the rest of it based on your history. Press the right arrow key (`→`) to accept.
- **Tab Completion**: Use the `Tab` key to complete commands, arguments, and file paths with helpful descriptions.
- **No Configuration Needed**: All the powerful features work immediately without needing to edit a complex configuration file.

This workflow is designed to be efficient, consistent, and keyboard-driven, allowing you to focus on your code with minimal distraction.
