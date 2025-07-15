# Catred Config - Quick Start Guide

## After Installation

Congratulations! You've successfully installed Catred Config. Here's how to get your environment up and running.

## 1. Start Your Environment

**The fastest way to get started:**

```bash
catred run
```

This command will:
- Detect your operating system
- Start the appropriate window manager, status bar, and other components
- Provide helpful feedback about what's starting

### Platform-Specific Components

**macOS:**
- **yabai** - Tiling window manager
- **skhd** - Hotkey daemon for keyboard shortcuts  
- **SketchyBar** - Customizable status bar
- **Raycast** - Application launcher (if installed)

**Linux:**
- **i3** or **sway** - Tiling window manager
- **polybar** - Status bar
- **rofi** - Application launcher (use Alt+d)

**Windows:**
- **komorebi** - Tiling window manager
- **yasb** - Status bar
- **Flow Launcher** - Application launcher

## 2. Essential Commands

```bash
# Check system health
catred health

# Switch themes
catred theme gruvbox
catred theme tokyo-night-storm  
catred theme catppuccin-macchiato

# Stop environment
catred stop

# Update everything
catred update

# Get help
catred help
```

## 3. Key Bindings

All platforms use **Alt** as the primary modifier key for consistency:

### Window Management
- `Alt + h/j/k/l` - Move focus between windows (vim-style)
- `Alt + Shift + h/j/k/l` - Move windows
- `Alt + Shift + q` - Close window
- `Alt + f` - Toggle fullscreen
- `Alt + Return` - Open terminal

### Workspaces
- `Alt + 1-9` - Switch to workspace 1-9
- `Alt + Shift + 1-9` - Move window to workspace
- `Alt + Tab` - Switch between recent workspaces

### Application Launcher
- `Alt + d` - Open application launcher
- `Alt + Shift + r` - Restart window manager

## 4. Default Applications

**Shell:** Fish with modern features and theme integration
**Primary Editor:** Neovim with lazy.nvim plugin manager
**Secondary Editor:** Zed for debugging and quick edits  
**Terminals:** Ghostty (primary), Warp, Kitty, Alacritty

## 5. Theme System

Catred Config includes three beautiful themes:

1. **catppuccin-macchiato** (default) - Warm, low-contrast colors
2. **gruvbox** - Retro, warm colors with high contrast
3. **tokyo-night-storm** - Cool, vibrant colors with modern feel

Switch themes instantly:
```bash
catred theme gruvbox
```

Themes apply to all components: terminals, editors, window managers, and status bars.

## 6. Troubleshooting

### Components Not Starting?

1. **Check if tools are installed:**
   ```bash
   catred health
   ```

2. **View detailed status:**
   ```bash
   catred run
   # Look for warning messages about missing tools
   ```

3. **Install missing components:**
   - **macOS:** Use the provided brew install commands
   - **Linux:** Use your package manager
   - **Windows:** Follow the provided installation links

### Configuration Issues?

1. **Reset to defaults:**
   ```bash
   catred theme catppuccin-macchiato
   ```

2. **Update configurations:**
   ```bash
   catred update
   ```

### Still Having Issues?

- Check the main [README.md](../README.md) for detailed documentation
- Review [SPECIFICATION.md](../SPECIFICATION.md) for technical details
- Run `catred health` to identify specific problems

## 7. What's Next?

- **Customize keybindings** in your window manager config
- **Add your own applications** to the launcher
- **Explore themes** and switch between them
- **Learn the unified keybindings** for maximum productivity

## 8. Daily Workflow

1. **Start your session:**
   ```bash
   catred run
   ```

2. **Open applications:**
   - Terminal: `Alt + Return`
   - Launcher: `Alt + d`

3. **Manage windows:**
   - Navigate: `Alt + h/j/k/l`
   - Move: `Alt + Shift + h/j/k/l`

4. **Switch workspaces:**
   - Go to workspace: `Alt + 1-9`
   - Move window: `Alt + Shift + 1-9`

5. **End your session:**
   ```bash
   catred stop
   ```

---

**Enjoy your new development environment!** 🚀

For more detailed information, see the full documentation in the [docs/](.) directory.