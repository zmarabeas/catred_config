# Unified Keybinding Specification

## Overview

This document defines a unified keybinding scheme that works consistently across macOS, Windows, and Linux with their respective window managers (yabai, komorebi, and i3/sway). The design prioritizes muscle memory and workflow consistency over platform-specific conventions.

## Design Principles

### 1. Primary Modifier Key
- **Alt** is used as the primary modifier key across all platforms
- Avoids conflicts with system shortcuts (Windows key, Cmd key)
- Consistent with i3 default behavior
- Works reliably across all window managers

### 2. Navigation Pattern
- **hjkl** movement pattern (Vim-style navigation)
- **Consistent directional mapping**: h=left, j=down, k=up, l=right
- **Logical extension** to window management operations

### 3. Modifier Combinations
- **Alt + key**: Basic operations (focus, switch)
- **Alt + Shift + key**: Advanced operations (move, create)
- **Alt + Ctrl + key**: System operations (reload, quit)

## Core Keybinding Reference

### Window Focus and Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + h` | Focus left | Move focus to window on the left |
| `Alt + j` | Focus down | Move focus to window below |
| `Alt + k` | Focus up | Move focus to window above |
| `Alt + l` | Focus right | Move focus to window on the right |
| `Alt + Tab` | Focus next | Cycle through windows |
| `Alt + Shift + Tab` | Focus previous | Reverse cycle through windows |

### Window Movement

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + h` | Move left | Move window to the left |
| `Alt + Shift + j` | Move down | Move window down |
| `Alt + Shift + k` | Move up | Move window up |
| `Alt + Shift + l` | Move right | Move window to the right |

### Window Layout Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + v` | Split vertical | Split container vertically |
| `Alt + b` | Split horizontal | Split container horizontally |
| `Alt + s` | Stacking layout | Stack windows in container |
| `Alt + w` | Tabbed layout | Tab windows in container |
| `Alt + e` | Toggle split | Toggle split orientation |
| `Alt + f` | Fullscreen | Toggle fullscreen mode |
| `Alt + Shift + Space` | Toggle floating | Toggle floating mode |

### Window Resizing

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + r` | Resize mode | Enter resize mode |
| `Alt + r, h` | Resize left | Shrink window width |
| `Alt + r, j` | Resize down | Grow window height |
| `Alt + r, k` | Resize up | Shrink window height |
| `Alt + r, l` | Resize right | Grow window width |
| `Alt + r, Escape` | Exit resize | Exit resize mode |

### Workspace Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + 1` | Workspace 1 | Switch to workspace 1 |
| `Alt + 2` | Workspace 2 | Switch to workspace 2 |
| `Alt + 3` | Workspace 3 | Switch to workspace 3 |
| `Alt + 4` | Workspace 4 | Switch to workspace 4 |
| `Alt + 5` | Workspace 5 | Switch to workspace 5 |
| `Alt + 6` | Workspace 6 | Switch to workspace 6 |
| `Alt + 7` | Workspace 7 | Switch to workspace 7 |
| `Alt + 8` | Workspace 8 | Switch to workspace 8 |
| `Alt + 9` | Workspace 9 | Switch to workspace 9 |
| `Alt + 0` | Workspace 10 | Switch to workspace 10 |

### Window to Workspace Movement

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + 1` | Send to workspace 1 | Move window to workspace 1 |
| `Alt + Shift + 2` | Send to workspace 2 | Move window to workspace 2 |
| `Alt + Shift + 3` | Send to workspace 3 | Move window to workspace 3 |
| `Alt + Shift + 4` | Send to workspace 4 | Move window to workspace 4 |
| `Alt + Shift + 5` | Send to workspace 5 | Move window to workspace 5 |
| `Alt + Shift + 6` | Send to workspace 6 | Move window to workspace 6 |
| `Alt + Shift + 7` | Send to workspace 7 | Move window to workspace 7 |
| `Alt + Shift + 8` | Send to workspace 8 | Move window to workspace 8 |
| `Alt + Shift + 9` | Send to workspace 9 | Move window to workspace 9 |
| `Alt + Shift + 0` | Send to workspace 10 | Move window to workspace 10 |

### Application Launching

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + d` | Application launcher | Open application launcher |
| `Alt + Return` | Terminal | Open terminal |
| `Alt + Shift + Return` | Floating terminal | Open floating terminal |

### Window Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + q` | Close window | Close focused window |
| `Alt + Shift + Space` | Toggle floating | Toggle floating mode |
| `Alt + Shift + Minus` | Minimize | Minimize window |
| `Alt + Shift + Plus` | Maximize | Maximize window |

### System Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + c` | Reload config | Reload window manager config |
| `Alt + Shift + r` | Restart WM | Restart window manager |
| `Alt + Shift + e` | Exit WM | Exit window manager |
| `Alt + Shift + l` | Lock screen | Lock the screen |

## Platform-Specific Implementations

### macOS (yabai + skhd)

```bash
# ~/.config/skhd/skhdrc
# Focus window
alt - h : yabai -m window --focus west
alt - j : yabai -m window --focus south
alt - k : yabai -m window --focus north
alt - l : yabai -m window --focus east

# Move window
alt + shift - h : yabai -m window --warp west
alt + shift - j : yabai -m window --warp south
alt + shift - k : yabai -m window --warp north
alt + shift - l : yabai -m window --warp east

# Switch workspace
alt - 1 : yabai -m space --focus 1
alt - 2 : yabai -m space --focus 2
alt - 3 : yabai -m space --focus 3
alt - 4 : yabai -m space --focus 4
alt - 5 : yabai -m space --focus 5

# Move window to workspace
alt + shift - 1 : yabai -m window --space 1
alt + shift - 2 : yabai -m window --space 2
alt + shift - 3 : yabai -m window --space 3
alt + shift - 4 : yabai -m window --space 4
alt + shift - 5 : yabai -m window --space 5

# Layout management
alt - v : yabai -m window --insert south
alt - b : yabai -m window --insert east
alt - f : yabai -m window --toggle zoom-fullscreen
alt + shift - space : yabai -m window --toggle float

# Application launching
alt - d : open -n /Applications/Raycast.app
alt - return : open -n /Applications/Warp.app

# Window management
alt + shift - q : yabai -m window --close
alt + shift - c : launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
alt + shift - r : launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
```

### Windows (komorebi + whkd)

```yaml
# ~/.config/whkd/whkdrc
# Focus window
alt h: komorebic focus left
alt j: komorebic focus down
alt k: komorebic focus up
alt l: komorebic focus right

# Move window
alt shift h: komorebic move left
alt shift j: komorebic move down
alt shift k: komorebic move up
alt shift l: komorebic move right

# Switch workspace
alt 1: komorebic focus-workspace 0
alt 2: komorebic focus-workspace 1
alt 3: komorebic focus-workspace 2
alt 4: komorebic focus-workspace 3
alt 5: komorebic focus-workspace 4

# Move window to workspace
alt shift 1: komorebic move-to-workspace 0
alt shift 2: komorebic move-to-workspace 1
alt shift 3: komorebic move-to-workspace 2
alt shift 4: komorebic move-to-workspace 3
alt shift 5: komorebic move-to-workspace 4

# Layout management
alt v: komorebic flip-layout vertical
alt b: komorebic flip-layout horizontal
alt f: komorebic toggle-maximize
alt shift space: komorebic toggle-float

# Application launching
alt d: pwsh -Command "Start-Process 'flow-launcher://'"
alt return: wt

# Window management
alt shift q: komorebic close
alt shift c: komorebic reload-configuration
alt shift r: komorebic restart
```

### Linux (i3/sway)

```bash
# ~/.config/i3/config or ~/.config/sway/config
# Focus window
bindsym Alt+h focus left
bindsym Alt+j focus down
bindsym Alt+k focus up
bindsym Alt+l focus right

# Move window
bindsym Alt+Shift+h move left
bindsym Alt+Shift+j move down
bindsym Alt+Shift+k move up
bindsym Alt+Shift+l move right

# Switch workspace
bindsym Alt+1 workspace number 1
bindsym Alt+2 workspace number 2
bindsym Alt+3 workspace number 3
bindsym Alt+4 workspace number 4
bindsym Alt+5 workspace number 5

# Move window to workspace
bindsym Alt+Shift+1 move container to workspace number 1
bindsym Alt+Shift+2 move container to workspace number 2
bindsym Alt+Shift+3 move container to workspace number 3
bindsym Alt+Shift+4 move container to workspace number 4
bindsym Alt+Shift+5 move container to workspace number 5

# Layout management
bindsym Alt+v split v
bindsym Alt+b split h
bindsym Alt+s layout stacking
bindsym Alt+w layout tabbed
bindsym Alt+e layout toggle split
bindsym Alt+f fullscreen toggle
bindsym Alt+Shift+space floating toggle

# Application launching
bindsym Alt+d exec rofi -show drun
bindsym Alt+Return exec warp-terminal

# Window management
bindsym Alt+Shift+q kill
bindsym Alt+Shift+c reload
bindsym Alt+Shift+r restart
```

## Advanced Keybindings

### Multi-Monitor Support

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + Ctrl + h` | Move to left monitor | Move window to left monitor |
| `Alt + Shift + Ctrl + j` | Move to bottom monitor | Move window to bottom monitor |
| `Alt + Shift + Ctrl + k` | Move to top monitor | Move window to top monitor |
| `Alt + Shift + Ctrl + l` | Move to right monitor | Move window to right monitor |

### Workspace Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Ctrl + h` | Previous workspace | Switch to previous workspace |
| `Alt + Ctrl + l` | Next workspace | Switch to next workspace |
| `Alt + Shift + Tab` | Recent workspace | Switch to most recent workspace |

### Power User Features

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + Shift + m` | Mark window | Mark window for later reference |
| `Alt + m` | Go to mark | Go to marked window |
| `Alt + Shift + p` | Sticky window | Make window sticky (all workspaces) |
| `Alt + Shift + i` | Window info | Show window information |

## Customization Guidelines

### Adding New Keybindings

When adding new keybindings, follow these principles:

1. **Consistency**: Use the same key combination across all platforms
2. **Logical grouping**: Group related functions with similar modifiers
3. **Conflict avoidance**: Check for conflicts with system shortcuts
4. **Documentation**: Always document new keybindings in this file

### Platform-Specific Considerations

#### macOS
- Avoid conflicts with system shortcuts (Cmd+Space, Cmd+Tab)
- Consider SIP restrictions for yabai functionality
- Test with both Intel and Apple Silicon Macs

#### Windows
- Be aware of Windows key conflicts
- Test with both Windows 10 and Windows 11
- Consider PowerShell execution policy restrictions

#### Linux
- Test with both X11 and Wayland
- Consider different desktop environments
- Verify compatibility with different display managers

## Testing and Validation

### Keybinding Testing Checklist

- [ ] All core keybindings work on each platform
- [ ] No conflicts with system shortcuts
- [ ] Consistent behavior across window managers
- [ ] Proper handling of multi-monitor setups
- [ ] Resize mode functions correctly
- [ ] Workspace switching is responsive
- [ ] Application launching works reliably

### Performance Considerations

- **Response time**: Keybindings should respond within 100ms
- **Resource usage**: Monitor CPU usage during heavy window operations
- **Memory consumption**: Ensure window manager memory usage is stable
- **Battery impact**: Consider power consumption on laptops

## Troubleshooting

### Common Issues

1. **Keybinding not working**
   - Check if the key combination conflicts with system shortcuts
   - Verify the window manager is running
   - Confirm the configuration file is properly formatted

2. **Inconsistent behavior**
   - Ensure all configuration files are synchronized
   - Check for platform-specific syntax differences
   - Verify the correct window manager is active

3. **Performance problems**
   - Monitor system resources during window operations
   - Check for memory leaks in the window manager
   - Optimize configuration for better performance

### Platform-Specific Debugging

#### macOS
- Use `yabai -m query --windows` to inspect window state
- Check System Preferences > Security & Privacy for accessibility permissions
- Monitor Console.app for yabai error messages

#### Windows
- Use `komorebic query windows` to inspect window state
- Check Windows Event Viewer for error messages
- Verify PowerShell execution policy allows scripts

#### Linux
- Use `i3-msg -t get_tree` to inspect window tree
- Check system logs with `journalctl -u display-manager`
- Verify X11/Wayland compatibility

## Migration Guide

### From Default i3 Keybindings

If you're migrating from default i3 keybindings (Mod4/Windows key), use this mapping:

| Old (Mod4) | New (Alt) | Action |
|------------|-----------|--------|
| `Mod4 + h` | `Alt + h` | Focus left |
| `Mod4 + j` | `Alt + j` | Focus down |
| `Mod4 + k` | `Alt + k` | Focus up |
| `Mod4 + l` | `Alt + l` | Focus right |

### From macOS Defaults

If you're migrating from macOS defaults (Cmd key), use this mapping:

| Old (Cmd) | New (Alt) | Action |
|-----------|-----------|--------|
| `Cmd + Tab` | `Alt + Tab` | Switch windows |
| `Cmd + Space` | `Alt + d` | Application launcher |
| `Cmd + Q` | `Alt + Shift + q` | Close window |

### From Windows Defaults

If you're migrating from Windows defaults (Win key), use this mapping:

| Old (Win) | New (Alt) | Action |
|-----------|-----------|--------|
| `Win + Tab` | `Alt + Tab` | Switch windows |
| `Win + R` | `Alt + d` | Application launcher |
| `Alt + F4` | `Alt + Shift + q` | Close window |

---

This keybinding specification ensures consistent muscle memory across all platforms while maintaining the efficiency and power of tiling window managers. Regular updates to this document will reflect changes and improvements to the unified keybinding scheme.