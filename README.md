# catred config

cross-platform development environment with i3-style tiling window management. provides consistent keyboard-driven workflow across macos, linux, and windows.

## architecture

single repository contains all configuration files, installation scripts, and management tools. uses gnu stow for symlink management and unified theme system across all components.

**platform support**
- macos: yabai + skhd + sketchybar + raycast
- linux: i3/sway + polybar + rofi  
- windows: komorebi + yasb + flow launcher

**theme system**
- catppuccin macchiato (default)
- gruvbox
- tokyo night storm

**core components**
- shell: fish with modern features
- primary editor: neovim with lazy.nvim
- secondary editor: zed for debugging
- terminals: ghostty, warp, kitty, alacritty

## installation

clone repository and run bootstrap script:

```bash
git clone https://github.com/yourusername/catred_config.git ~/catred_config
cd ~/catred_config
./scripts/install/bootstrap.sh
```

installer process:
- detects operating system automatically
- backs up existing configurations
- installs applications and fonts via system package manager
- creates symlinks using gnu stow
- installs global catred cli command
- applies default theme across all components

## usage

manage environment with catred command:

```bash
catred health              # validate system configuration
catred theme gruvbox       # switch themes
catred update             # update all components
catred sync               # sync local changes to repo
catred uninstall          # remove all components
```

## components

| platform | window manager | status bar | launcher | 
|----------|---------------|------------|----------|
| macos | yabai + skhd | sketchybar | raycast |
| linux | i3 / sway | polybar | rofi |
| windows | komorebi + whkd | yasb | flow launcher |

all platforms use fish shell, neovim, zed, and same terminal options.

## theme switching

change theme across all components:

```bash
catred theme                      # show current theme
catred theme gruvbox             # switch to gruvbox
catred theme tokyo-night-storm   # switch to tokyo night
catred theme catppuccin-macchiato # switch to default
```

applies theme to terminals, editors, window managers, status bars, and launchers.

## maintenance

```bash
catred health    # validate configuration
catred update    # update packages and plugins
catred sync      # sync local changes to repo
```

## manual scripts

direct script execution available:

```bash
./scripts/config/switch-theme.sh [theme-name]
./scripts/maintenance/health-check.sh
./scripts/maintenance/update-all.sh
./scripts/maintenance/backup-settings.sh
```

## documentation

- [workflow guide](docs/workflow.md) - keybindings and daily usage
- [specification](SPECIFICATION.md) - technical architecture

## Testing

Run the comprehensive test suite:
```bash
./tests/test_framework.sh
```

Run specific tests:
```bash
./tests/unit/test_catred_cli.sh
./tests/integration/test_install_uninstall.sh
```

Run Docker-based tests:
```bash
./tests/run_docker_tests.sh all
```
