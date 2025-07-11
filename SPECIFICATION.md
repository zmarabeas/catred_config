# Cross-Platform i3-Style Dotfiles Specification

## Project Overview

This specification defines a comprehensive cross-platform development environment that achieves **80-90% workflow consistency** across macOS (M1), Windows, and Ubuntu Linux. The system combines i3-style tiling window management with unified keybindings and gruvbox theming for a cohesive, keyboard-driven experience.

## Core Principles

### 1. Workflow Consistency
- **Unified keybinding patterns** using Alt as the primary modifier
- **Consistent hjkl navigation** across all applications
- **Identical workspace management** on all platforms
- **Cross-platform launcher behavior** with matching shortcuts

### 2. Visual Consistency
- **Gruvbox color scheme** across all applications
- **JetBrains Mono Nerd Font** for consistent typography
- **Unified status bar layouts** with matching information display
- **Consistent terminal theming** across all platforms

### 3. Technical Foundation
- **chezmoi for dotfile management** with platform-specific templating
- **Single source of truth** for all configuration files
- **Automated installation** and theme application
- **Health checking** and maintenance scripts

## Platform-Specific Tool Selection

### macOS (M1)
- **Window Manager**: yabai + skhd
- **Status Bar**: SketchyBar
- **Application Launcher**: Raycast
- **Terminal**: Warp Terminal / Ghostty
- **Package Manager**: Homebrew

**Rationale**: yabai provides the most i3-like experience on macOS with binary space partitioning. SketchyBar offers excellent customization for status display. Raycast provides powerful search and automation capabilities.

### Windows
- **Window Manager**: komorebi + whkd
- **Status Bar**: yasb
- **Application Launcher**: Flow Launcher
- **Terminal**: Warp Terminal / Ghostty
- **Package Manager**: winget + Chocolatey

**Rationale**: komorebi delivers authentic i3 experience with Rust performance. yasb provides customizable status display. Flow Launcher offers extensible search functionality.

### Ubuntu Linux
- **Window Manager**: i3 (X11) / sway (Wayland)
- **Status Bar**: polybar
- **Application Launcher**: rofi
- **Terminal**: Warp Terminal / Ghostty
- **Package Manager**: apt

**Rationale**: i3 is the gold standard for tiling window managers. sway provides drop-in Wayland replacement. polybar offers extensive customization options. Ghostty provides a lightweight, fast terminal alternative to Warp.

## Unified Keybinding Specification

### Primary Modifier
- **Alt key** used as primary modifier across all platforms
- Avoids conflicts with Windows key on Windows
- Consistent with i3 default conventions
- Works reliably across all applications

### Core Keybindings

#### Window Management
- `Alt + h/j/k/l` - Move focus between windows
- `Alt + Shift + h/j/k/l` - Move windows
- `Alt + r` - Resize mode
- `Alt + Shift + q` - Close window
- `Alt + f` - Toggle fullscreen
- `Alt + Shift + Space` - Toggle floating

#### Workspace Management
- `Alt + 1-9` - Switch to workspace
- `Alt + Shift + 1-9` - Move window to workspace
- `Alt + Tab` - Switch between recent workspaces

#### Application Launching
- `Alt + d` - Application launcher
- `Alt + Return` - Terminal
- `Alt + Shift + c` - Reload configuration
- `Alt + Shift + r` - Restart window manager

#### Layout Management
- `Alt + v` - Vertical split
- `Alt + b` - Horizontal split
- `Alt + s` - Stacking layout
- `Alt + w` - Tabbed layout
- `Alt + e` - Toggle split orientation

## Gruvbox Color Specification

### Color Palette
```
# Background colors
bg:        #282828  # Main background
bg0_h:     #1d2021  # Hard background
bg0_s:     #32302f  # Soft background
bg1:       #3c3836  # Darker background
bg2:       #504945  # Selection background
bg3:       #665c54  # Status line background
bg4:       #7c6f64  # Line numbers

# Foreground colors
fg:        #ebdbb2  # Main foreground
fg0:       #fbf1c7  # Light foreground
fg1:       #ebdbb2  # Default foreground
fg2:       #d5c4a1  # Comments
fg3:       #bdae93  # Darker foreground
fg4:       #a89984  # Dark foreground

# Accent colors
red:       #cc241d  # Variables, errors
green:     #98971a  # Strings, success
yellow:    #d79921  # Classes, warnings
blue:      #458588  # Functions, info
purple:    #b16286  # Keywords, purple
aqua:      #689d6a  # Regex, cyan
orange:    #d65d0e  # Numbers, orange
gray:      #928374  # Comments, disabled
```

### Theme Application Strategy
- **Centralized color definitions** in multiple formats
- **Template-based application** across all tools
- **Consistent color mapping** for similar UI elements
- **Platform-specific format handling** (hex, RGB, etc.)

## Configuration Management

### chezmoi Architecture
- **Platform detection** through templates
- **Conditional configuration** based on OS
- **Secrets management** for sensitive data
- **Template inheritance** for shared configurations

### Repository Structure
```
dotfiles/
├── .chezmoi.yaml.tmpl           # Platform-specific configuration
├── dot_config/
│   ├── gruvbox/
│   │   ├── colors.sh           # Unified color definitions
│   │   ├── colors.json         # JSON format
│   │   └── colors.yaml         # YAML format
│   ├── i3/config.tmpl          # i3 configuration
│   ├── sway/config.tmpl        # Sway configuration
│   ├── yabai/yabairc.tmpl      # yabai configuration
│   ├── komorebi/komorebi.json.tmpl # komorebi configuration
│   └── [other configs...]
└── scripts/
    ├── install.sh              # Universal bootstrap
    ├── apply-gruvbox.sh        # Theme application
    └── health-check.sh         # System validation
```

## Installation Requirements

### System Dependencies
- **Git** for version control
- **curl** for downloading resources
- **Platform-specific package managers**
- **Nerd Font** for consistent typography

### Application Dependencies
#### macOS
- Homebrew
- yabai + skhd
- SketchyBar
- Raycast
- Warp Terminal

#### Windows
- winget + Chocolatey
- komorebi + whkd
- yasb
- Flow Launcher
- Warp Terminal

#### Linux
- apt/dnf/pacman
- i3 or sway
- polybar
- rofi
- Warp Terminal

## Performance Considerations

### Optimization Strategies
- **Lazy loading** of configuration components
- **Conditional loading** based on available tools
- **Efficient theme application** with caching
- **Minimal startup overhead** for window managers

### Resource Management
- **Memory usage optimization** for status bars
- **CPU usage monitoring** for tiling algorithms
- **Battery life considerations** on laptops
- **Network resource caching** for updates

## Maintenance and Updates

### Health Checking
- **Configuration validation** scripts
- **Theme consistency verification**
- **Keybinding conflict detection**
- **Performance monitoring**

### Update Strategy
- **Automated theme updates** from upstream
- **Configuration backup** before changes
- **Rollback capability** for failed updates
- **Cross-platform synchronization** validation

## Security Considerations

### Configuration Security
- **Secrets management** through chezmoi
- **No hardcoded credentials** in public configs
- **Secure file permissions** for sensitive data
- **Regular security updates** for all tools

### System Security
- **SIP considerations** for macOS yabai
- **Execution policy** for Windows scripts
- **File system permissions** for Linux configs
- **Network security** for theme downloads

## Testing and Validation

### Platform Testing
- **Virtual machine testing** for each platform
- **Hardware compatibility** verification
- **Performance benchmarking** across systems
- **User acceptance testing** for workflow consistency

### Integration Testing
- **Cross-platform synchronization** testing
- **Theme application** validation
- **Keybinding consistency** verification
- **Installation script** reliability testing

## Documentation Requirements

### User Documentation
- **Installation guides** for each platform
- **Keybinding reference** cards
- **Troubleshooting guides** for common issues
- **Customization instructions** for advanced users

### Technical Documentation
- **Architecture diagrams** for system design
- **API documentation** for custom scripts
- **Development guides** for contributors
- **Testing procedures** for validation

## Success Metrics

### Consistency Metrics
- **Keybinding consistency**: 95% identical shortcuts
- **Visual consistency**: 90% matching appearance
- **Workflow consistency**: 80% identical user experience
- **Performance consistency**: <10% variance across platforms

### User Experience Metrics
- **Installation time**: <30 minutes per platform
- **Configuration time**: <10 minutes for customization
- **Learning curve**: <1 week for cross-platform proficiency
- **Maintenance overhead**: <1 hour per month

## Future Considerations

### Extensibility
- **Plugin architecture** for custom tools
- **Theme system** for alternative color schemes
- **Keybinding customization** framework
- **Multi-monitor support** enhancements

### Platform Evolution
- **Wayland migration** path for Linux
- **Windows 11** specific optimizations
- **Apple Silicon** optimization for macOS
- **New tool integration** as they emerge

---

*This specification serves as the foundation for implementing a unified, cross-platform development environment that prioritizes consistency, performance, and user experience across all supported platforms.*