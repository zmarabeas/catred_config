# macOS Installation Guide

## Overview

This guide covers the complete installation and configuration of the i3-style tiling window manager setup on macOS using yabai, SketchyBar, and Raycast with unified gruvbox theming.

## Prerequisites

- **macOS 12.0 (Monterey)** or later
- **Administrator privileges** for system modifications
- **Xcode Command Line Tools** installed
- **Homebrew** package manager
- **Stable internet connection** for downloads

## Important: SIP (System Integrity Protection) Considerations

### Full yabai Functionality (Recommended)

For complete i3-like functionality, you'll need to partially disable SIP:

1. **Restart into Recovery Mode**:
   - **Intel Mac**: Hold `Cmd + R` during startup
   - **Apple Silicon Mac**: Hold power button until options appear, select Options

2. **Open Terminal** in Recovery Mode

3. **Disable SIP for yabai**:
   ```bash
   csrutil disable --without fs --without debug --without nvram
   ```

4. **Restart normally**

5. **Verify SIP status**:
   ```bash
   csrutil status
   ```

### Alternative: SIP-Compatible Mode

If you prefer to keep SIP enabled, yabai will work with limited functionality:
- No window stacking or tabbing
- No window insertion/movement in some applications
- Limited control over system windows

## Installation Steps

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Core Dependencies

```bash
# Install window manager and hotkey daemon
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# Install status bar
brew install FelixKratz/formulae/sketchybar

# Install application launcher
brew install --cask raycast

# Install terminal
brew install --cask warp

# Install configuration management
brew install chezmoi

# Install fonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font
```

### 3. Configure yabai

Create yabai configuration with gruvbox theming:

```bash
# Create config directory
mkdir -p ~/.config/yabai

# Create yabai configuration
cat > ~/.config/yabai/yabairc << 'EOF'
#!/usr/bin/env sh

# Load gruvbox colors
source ~/.config/gruvbox/colors.sh

# Global settings
yabai -m config mouse_follows_focus          off
yabai -m config focus_follows_mouse          off
yabai -m config window_origin_display        default
yabai -m config window_placement             second_child
yabai -m config window_topmost               off
yabai -m config window_shadow                on
yabai -m config window_opacity               off
yabai -m config window_opacity_duration      0.0
yabai -m config active_window_opacity        1.0
yabai -m config normal_window_opacity        0.90
yabai -m config window_border                on
yabai -m config window_border_width          4
yabai -m config active_window_border_color   0xff689d6a
yabai -m config normal_window_border_color   0xff3c3836
yabai -m config insert_feedback_color        0xffd79921
yabai -m config split_ratio                  0.50
yabai -m config auto_balance                 off
yabai -m config mouse_modifier               fn
yabai -m config mouse_action1                move
yabai -m config mouse_action2                resize
yabai -m config mouse_drop_action            swap

# General space settings
yabai -m config layout                       bsp
yabai -m config top_padding                  50
yabai -m config bottom_padding               10
yabai -m config left_padding                 10
yabai -m config right_padding                10
yabai -m config window_gap                   10

# Disable management for specific apps
yabai -m rule --add app="^System Preferences$" manage=off
yabai -m rule --add app="^Archive Utility$" manage=off
yabai -m rule --add app="^Warp$" manage=off
yabai -m rule --add app="^Raycast$" manage=off
yabai -m rule --add app="^Finder$" manage=off
yabai -m rule --add app="^AppStore$" manage=off
yabai -m rule --add app="^Activity Monitor$" manage=off
yabai -m rule --add app="^Calculator$" manage=off
yabai -m rule --add app="^Digital Color Meter$" manage=off

echo "yabai configuration loaded.."
EOF

# Make executable
chmod +x ~/.config/yabai/yabairc
```

### 4. Configure skhd (Hotkey Daemon)

```bash
# Create skhd configuration
cat > ~/.config/skhd/skhdrc << 'EOF'
# Change focus between windows
alt - h : yabai -m window --focus west
alt - j : yabai -m window --focus south
alt - k : yabai -m window --focus north
alt - l : yabai -m window --focus east

# Move windows
alt + shift - h : yabai -m window --warp west
alt + shift - j : yabai -m window --warp south
alt + shift - k : yabai -m window --warp north
alt + shift - l : yabai -m window --warp east

# Balance out tree of windows
alt + shift - e : yabai -m space --balance

# Make floating window fill screen
alt + shift - up : yabai -m window --grid 1:1:0:0:1:1

# Make floating window fill left-half of screen
alt + shift - left : yabai -m window --grid 1:2:0:0:1:1

# Make floating window fill right-half of screen
alt + shift - right : yabai -m window --grid 1:2:1:0:1:1

# Create desktop, move window and follow focus
alt + shift - n : yabai -m space --create && \
                  index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
                  yabai -m window --space "${index}" && \
                  yabai -m space --focus "${index}"

# Destroy desktop
alt + shift - w : yabai -m space --destroy

# Fast focus desktop
alt - 1 : yabai -m space --focus 1
alt - 2 : yabai -m space --focus 2
alt - 3 : yabai -m space --focus 3
alt - 4 : yabai -m space --focus 4
alt - 5 : yabai -m space --focus 5
alt - 6 : yabai -m space --focus 6
alt - 7 : yabai -m space --focus 7
alt - 8 : yabai -m space --focus 8
alt - 9 : yabai -m space --focus 9
alt - 0 : yabai -m space --focus 10

# Send window to desktop and follow focus
alt + shift - 1 : yabai -m window --space 1; yabai -m space --focus 1
alt + shift - 2 : yabai -m window --space 2; yabai -m space --focus 2
alt + shift - 3 : yabai -m window --space 3; yabai -m space --focus 3
alt + shift - 4 : yabai -m window --space 4; yabai -m space --focus 4
alt + shift - 5 : yabai -m window --space 5; yabai -m space --focus 5
alt + shift - 6 : yabai -m window --space 6; yabai -m space --focus 6
alt + shift - 7 : yabai -m window --space 7; yabai -m space --focus 7
alt + shift - 8 : yabai -m window --space 8; yabai -m space --focus 8
alt + shift - 9 : yabai -m window --space 9; yabai -m space --focus 9
alt + shift - 0 : yabai -m window --space 10; yabai -m space --focus 10

# Focus monitor
alt - tab : yabai -m display --focus recent
alt - 1 : yabai -m display --focus 1
alt - 2 : yabai -m display --focus 2
alt - 3 : yabai -m display --focus 3

# Send window to monitor and follow focus
alt + shift - tab : yabai -m window --display recent; yabai -m display --focus recent
alt + shift + ctrl - 1 : yabai -m window --display 1; yabai -m display --focus 1
alt + shift + ctrl - 2 : yabai -m window --display 2; yabai -m display --focus 2
alt + shift + ctrl - 3 : yabai -m window --display 3; yabai -m display --focus 3

# Move window
alt + shift + ctrl - h : yabai -m window --move rel:-20:0
alt + shift + ctrl - j : yabai -m window --move rel:0:20
alt + shift + ctrl - k : yabai -m window --move rel:0:-20
alt + shift + ctrl - l : yabai -m window --move rel:20:0

# Increase window size
alt + shift - h : yabai -m window --resize left:-20:0
alt + shift - j : yabai -m window --resize bottom:0:20
alt + shift - k : yabai -m window --resize top:0:-20
alt + shift - l : yabai -m window --resize right:20:0

# Decrease window size
alt + shift + cmd - h : yabai -m window --resize left:20:0
alt + shift + cmd - j : yabai -m window --resize bottom:0:-20
alt + shift + cmd - k : yabai -m window --resize top:0:20
alt + shift + cmd - l : yabai -m window --resize right:-20:0

# Set insertion point in focused container
alt + ctrl - h : yabai -m window --insert west
alt + ctrl - j : yabai -m window --insert south
alt + ctrl - k : yabai -m window --insert north
alt + ctrl - l : yabai -m window --insert east

# Toggle window zoom
alt - d : yabai -m window --toggle zoom-parent
alt - f : yabai -m window --toggle zoom-fullscreen

# Toggle window split type
alt - e : yabai -m window --toggle split

# Float / unfloat window and center on screen
alt + shift - space : yabai -m window --toggle float --grid 4:4:1:1:2:2

# Toggle sticky(+float), topmost, picture-in-picture
alt - p : yabai -m window --toggle sticky --toggle topmost --toggle pip

# Applications
alt - return : open -n /Applications/Warp.app
alt - d : open -n /Applications/Raycast.app

# Restart yabai
alt + shift - r : yabai --restart-service
alt + shift - c : yabai --restart-service

# Close window
alt + shift - q : yabai -m window --close
EOF
```

### 5. Configure SketchyBar

```bash
# Create SketchyBar directory
mkdir -p ~/.config/sketchybar/plugins

# Create colors configuration
cat > ~/.config/sketchybar/colors.sh << 'EOF'
#!/bin/bash

# Gruvbox color palette for SketchyBar
export BLACK=0xff282828
export WHITE=0xffebdbb2
export RED=0xffcc241d
export GREEN=0xff98971a
export BLUE=0xff458588
export YELLOW=0xffd79921
export ORANGE=0xffd65d0e
export MAGENTA=0xffb16286
export AQUA=0xff689d6a
export GREY=0xff928374
export DARK_GREY=0xff1d2021
export BG_ALT=0xff3c3836
export TRANSPARENT=0x00000000

# Bar specific colors
export BAR_COLOR=$BLACK
export ITEM_BG_COLOR=$BG_ALT
export ACCENT_COLOR=$YELLOW
export ICON_COLOR=$AQUA
export LABEL_COLOR=$WHITE
export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$AQUA
export SHADOW_COLOR=$BLACK
EOF

# Create main configuration
cat > ~/.config/sketchybar/sketchybarrc << 'EOF'
#!/bin/bash

# Load colors
source "$HOME/.config/sketchybar/colors.sh"

# Bar appearance
sketchybar --bar height=32 \
                 blur_radius=30 \
                 position=top \
                 sticky=off \
                 padding_left=10 \
                 padding_right=10 \
                 color=$BAR_COLOR \
                 border_width=2 \
                 border_color=$AQUA

# Default item settings
sketchybar --default icon.font="JetBrains Mono Nerd Font:Bold:14.0" \
                     icon.color=$ICON_COLOR \
                     label.font="JetBrains Mono Nerd Font:Bold:14.0" \
                     label.color=$LABEL_COLOR \
                     background.color=$ITEM_BG_COLOR \
                     background.corner_radius=5 \
                     background.height=24 \
                     padding_left=5 \
                     padding_right=5

# Left side items
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  sketchybar --add space space.$sid left \
             --set space.$sid space=$sid \
                              icon=${SPACE_ICONS[i]} \
                              icon.color=$GREY \
                              label.drawing=off \
                              script="$HOME/.config/sketchybar/plugins/space.sh" \
                              click_script="yabai -m space --focus $sid"
done

sketchybar --add item space_separator left \
           --set space_separator icon="❯" \
                                icon.color=$ACCENT_COLOR \
                                padding_left=10 \
                                padding_right=10 \
                                label.drawing=off

sketchybar --add item front_app left \
           --set front_app script="$HOME/.config/sketchybar/plugins/front_app.sh" \
                          icon.drawing=off \
                          label.color=$WHITE \
           --subscribe front_app front_app_switched

# Center items
sketchybar --add item clock center \
           --set clock update_freq=10 \
                      icon="🕐" \
                      icon.color=$ACCENT_COLOR \
                      script="$HOME/.config/sketchybar/plugins/clock.sh"

# Right side items
sketchybar --add item cpu right \
           --set cpu update_freq=2 \
                    icon="💻" \
                    icon.color=$GREEN \
                    script="$HOME/.config/sketchybar/plugins/cpu.sh"

sketchybar --add item battery right \
           --set battery update_freq=120 \
                        icon="🔋" \
                        icon.color=$MAGENTA \
                        script="$HOME/.config/sketchybar/plugins/battery.sh"

# Run the bar
sketchybar --update
EOF

# Create space plugin
cat > ~/.config/sketchybar/plugins/space.sh << 'EOF'
#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set $NAME background.drawing=on \
                   background.color=$ACCENT_COLOR \
                   icon.color=$BLACK \
                   label.color=$BLACK
else
  sketchybar --set $NAME background.drawing=off \
                   icon.color=$GREY \
                   label.color=$GREY
fi
EOF

# Create clock plugin
cat > ~/.config/sketchybar/plugins/clock.sh << 'EOF'
#!/bin/bash
sketchybar --set $NAME label="$(date '+%H:%M')"
EOF

# Create CPU plugin
cat > ~/.config/sketchybar/plugins/cpu.sh << 'EOF'
#!/bin/bash
CPU_PERCENT=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
sketchybar --set $NAME label="$CPU_PERCENT%"
EOF

# Create battery plugin
cat > ~/.config/sketchybar/plugins/battery.sh << 'EOF'
#!/bin/bash
BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [[ $CHARGING != "" ]]; then
    ICON="🔌"
else
    ICON="🔋"
fi

sketchybar --set $NAME icon="$ICON" label="$PERCENTAGE%"
EOF

# Create front app plugin
cat > ~/.config/sketchybar/plugins/front_app.sh << 'EOF'
#!/bin/bash
sketchybar --set $NAME label="$INFO"
EOF

# Make all plugins executable
chmod +x ~/.config/sketchybar/sketchybarrc
chmod +x ~/.config/sketchybar/plugins/*.sh
EOF
```

### 6. Configure Warp Terminal

```bash
# Create Warp themes directory
mkdir -p ~/.warp/themes

# Create gruvbox theme
cat > ~/.warp/themes/gruvbox-dark.yaml << 'EOF'
name: "Gruvbox Dark"
accent: "#d79921"
background: "#282828"
foreground: "#ebdbb2"
details: "darker"
terminal_colors:
  normal:
    black: "#282828"
    red: "#cc241d"
    green: "#98971a"
    yellow: "#d79921"
    blue: "#458588"
    magenta: "#b16286"
    cyan: "#689d6a"
    white: "#ebdbb2"
  bright:
    black: "#928374"
    red: "#fb4934"
    green: "#b8bb26"
    yellow: "#fabd2f"
    blue: "#83a598"
    magenta: "#d3869b"
    cyan: "#8ec07c"
    white: "#fbf1c7"
EOF
```

### 7. Start Services

```bash
# Start yabai
brew services start yabai

# Start skhd  
brew services start skhd

# Start SketchyBar
brew services start sketchybar
```

### 8. Grant Permissions

1. **Accessibility Access**:
   - Go to System Preferences → Security & Privacy → Privacy → Accessibility
   - Add and enable: yabai, skhd, Warp, and your terminal application

2. **Screen Recording** (for SketchyBar):
   - Go to System Preferences → Security & Privacy → Privacy → Screen Recording
   - Add and enable: SketchyBar

## Configuration

### Customize Raycast

1. **Open Raycast** (Alt + D)
2. **Configure hotkey**: Set to Alt + D in preferences
3. **Install extensions**:
   - Window Management
   - System
   - Clipboard History
   - Calculator

### Customize Warp Terminal

1. **Open Warp**
2. **Settings** → **Appearance** → **Theme**
3. **Select "Gruvbox Dark"**
4. **Configure font**: JetBrains Mono Nerd Font

### Test the Setup

1. **Open terminal** (Alt + Return)
2. **Switch workspaces** (Alt + 1-9)
3. **Move windows** (Alt + Shift + h/j/k/l)
4. **Open launcher** (Alt + D)
5. **Toggle fullscreen** (Alt + F)

## Troubleshooting

### Common Issues

1. **yabai not managing windows**:
   - Check SIP status: `csrutil status`
   - Verify accessibility permissions
   - Restart yabai: `brew services restart yabai`

2. **Keybindings not working**:
   - Check skhd is running: `brew services list | grep skhd`
   - Verify accessibility permissions for skhd
   - Test configuration: `skhd -t`

3. **SketchyBar not appearing**:
   - Check if running: `brew services list | grep sketchybar`
   - Verify screen recording permissions
   - Check configuration: `sketchybar --reload`

### Debugging Commands

```bash
# Check yabai status
yabai -m query --windows
yabai -m query --spaces

# Check skhd status
skhd -t

# Reload configurations
yabai --restart-service
skhd --restart-service
sketchybar --reload
```

### Performance Optimization

1. **Reduce yabai logging**:
   ```bash
   echo 'yabai -m config debug_output off' >> ~/.config/yabai/yabairc
   ```

2. **Optimize SketchyBar updates**:
   - Increase update intervals for CPU/battery widgets
   - Use static icons where possible

3. **Memory management**:
   - Monitor memory usage with Activity Monitor
   - Restart services if memory usage is high

## Maintenance

### Regular Updates

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update yabai and skhd
brew upgrade yabai skhd sketchybar

# Restart services after updates
brew services restart yabai
brew services restart skhd
brew services restart sketchybar
```

### Backup Configuration

```bash
# Create backup directory
mkdir -p ~/backups/catred_config

# Backup configurations
cp -r ~/.config/yabai ~/backups/catred_config/
cp -r ~/.config/skhd ~/backups/catred_config/
cp -r ~/.config/sketchybar ~/backups/catred_config/
cp -r ~/.warp ~/backups/catred_config/
```

## Next Steps

1. **Customize workspace names** in SketchyBar
2. **Add more SketchyBar plugins** (weather, music, etc.)
3. **Configure additional Raycast extensions**
4. **Set up automatic theme switching** (light/dark)
5. **Integrate with other macOS tools** (Alfred, Hammerspoon)

---

Your macOS setup is now complete! You have a fully functional i3-style tiling window manager with gruvbox theming and unified keybindings. The system provides excellent keyboard-driven workflow while maintaining macOS integration.