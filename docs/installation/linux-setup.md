# Linux Installation Guide

## Overview

This guide covers the complete installation and configuration of the i3-style tiling window manager setup on Ubuntu/Debian-based Linux distributions using i3/sway, polybar, and rofi with unified gruvbox theming.

## Prerequisites

- **Ubuntu 20.04 LTS** or later (or equivalent Debian-based distribution)
- **sudo privileges** for package installation
- **X11 or Wayland** display server
- **Internet connection** for package downloads
- **Git** for configuration management

## Distribution Support

This guide primarily focuses on Ubuntu/Debian, but includes notes for:
- **Arch Linux** (using pacman)
- **Fedora** (using dnf)
- **openSUSE** (using zypper)

## Installation Steps

### 1. Update System

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# Arch Linux
sudo pacman -Syu

# Fedora
sudo dnf update -y

# openSUSE
sudo zypper refresh && sudo zypper update
```

### 2. Install Core Dependencies

#### Ubuntu/Debian:
```bash
# Install window managers
sudo apt install -y i3 sway

# Install status bar
sudo apt install -y polybar

# Install application launcher
sudo apt install -y rofi

# Install terminal
# Download Warp for Linux
curl -fsSL https://releases.warp.dev/stable/linux/deb/warp-terminal_*_amd64.deb -o /tmp/warp.deb
sudo dpkg -i /tmp/warp.deb || sudo apt-get install -f -y

# Alternative terminals
sudo apt install -y kitty alacritty

# Install fonts
sudo apt install -y fonts-firacode fonts-font-awesome
# Install JetBrains Mono Nerd Font manually (see fonts section)

# Install configuration management
sudo snap install chezmoi --classic
# Or: curl -sfL https://git.io/chezmoi | sh

# Install additional tools
sudo apt install -y nitrogen feh compton picom
sudo apt install -y arandr pavucontrol blueman
sudo apt install -y dunst libnotify-bin
```

#### Arch Linux:
```bash
# Install window managers
sudo pacman -S i3-wm sway

# Install status bar
sudo pacman -S polybar

# Install application launcher
sudo pacman -S rofi

# Install terminals
sudo pacman -S kitty alacritty
# For Warp, use AUR: yay -S warp-terminal

# Install fonts
sudo pacman -S ttf-fira-code ttf-font-awesome
sudo pacman -S ttf-jetbrains-mono-nerd

# Install additional tools
sudo pacman -S nitrogen feh picom
sudo pacman -S arandr pavucontrol blueman
sudo pacman -S dunst libnotify
```

#### Fedora:
```bash
# Install window managers
sudo dnf install -y i3 sway

# Install status bar
sudo dnf install -y polybar

# Install application launcher
sudo dnf install -y rofi

# Install terminals
sudo dnf install -y kitty alacritty

# Install fonts
sudo dnf install -y fira-code-fonts fontawesome-fonts
sudo dnf install -y jetbrains-mono-fonts

# Install additional tools
sudo dnf install -y nitrogen feh picom
sudo dnf install -y arandr pavucontrol blueman
sudo dnf install -y dunst libnotify
```

### 3. Install JetBrains Mono Nerd Font

```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download and install JetBrains Mono Nerd Font
cd /tmp
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/*.ttf ~/.local/share/fonts/

# Refresh font cache
fc-cache -fv

# Verify installation
fc-list | grep "JetBrains"
```

### 4. Configure i3

Create i3 configuration with gruvbox theming:

```bash
# Create i3 config directory
mkdir -p ~/.config/i3

# Create i3 configuration
cat > ~/.config/i3/config << 'EOF'
# i3 config file (v4)
# Load gruvbox colors
set $bg #282828
set $red #cc241d
set $green #98971a
set $yellow #d79921
set $blue #458588
set $purple #b16286
set $aqua #689d6a
set $gray #928374
set $darkgray #1d2021
set $white #ebdbb2

# Font for window titles and bar
font pango:JetBrains Mono Nerd Font 10

# Use Alt as modifier key
set $mod Mod1

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# Start a terminal
bindsym $mod+Return exec warp-terminal

# Kill focused window
bindsym $mod+Shift+q kill

# Start application launcher
bindsym $mod+d exec rofi -show drun -theme gruvbox-dark

# Change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Alternatively, you can use the cursor keys
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Alternatively, you can use the cursor keys
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Split in horizontal orientation
bindsym $mod+b split h

# Split in vertical orientation
bindsym $mod+v split v

# Enter fullscreen mode
bindsym $mod+f fullscreen toggle

# Change container layout
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# Toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# Change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# Focus the parent container
bindsym $mod+a focus parent

# Define names for default workspaces
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# Switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# Reload the configuration file
bindsym $mod+Shift+c reload

# Restart i3 inplace
bindsym $mod+Shift+r restart

# Exit i3
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# Resize window mode
mode "resize" {
    bindsym h resize shrink width 10 px or 10 ppt
    bindsym j resize grow height 10 px or 10 ppt
    bindsym k resize shrink height 10 px or 10 ppt
    bindsym l resize grow width 10 px or 10 ppt

    # Same bindings, but for the arrow keys
    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    # Back to normal: Enter or Escape or $mod+r
    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# Window colors
# class                 border  backgr. text    indicator child_border
client.focused          $aqua   $aqua   $bg     $yellow   $aqua
client.focused_inactive $gray   $gray   $white  $yellow   $gray
client.unfocused        $bg     $bg     $gray   $yellow   $bg
client.urgent           $red    $red    $white  $red      $red
client.placeholder      $gray   $bg     $white  $yellow   $gray

client.background       $white

# Window appearance
for_window [class=".*"] border pixel 2
gaps inner 10
gaps outer 5

# Autostart applications
exec --no-startup-id nitrogen --restore
exec --no-startup-id picom
exec --no-startup-id dunst
exec --no-startup-id ~/.config/polybar/launch.sh

# Application-specific rules
for_window [class="Arandr"] floating enable
for_window [class="Blueman-manager"] floating enable
for_window [class="Pavucontrol"] floating enable
for_window [title="File Transfer*"] floating enable
assign [class="firefox"] $ws2
assign [class="Code"] $ws3
EOF
```

### 5. Configure Sway (Wayland Alternative)

```bash
# Create sway config directory
mkdir -p ~/.config/sway

# Create sway configuration (similar to i3 but with Wayland specifics)
cat > ~/.config/sway/config << 'EOF'
# Sway config file
# Load gruvbox colors
set $bg #282828
set $red #cc241d
set $green #98971a
set $yellow #d79921
set $blue #458588
set $purple #b16286
set $aqua #689d6a
set $gray #928374
set $darkgray #1d2021
set $white #ebdbb2

# Font
font pango:JetBrains Mono Nerd Font 10

# Variables
set $mod Mod1
set $left h
set $down j
set $up k
set $right l
set $term warp-terminal
set $menu rofi -show drun -theme gruvbox-dark | xargs swaymsg exec --

# Output configuration
output * bg ~/.config/wallpapers/gruvbox-wallpaper.jpg fill

# Input configuration
input "type:keyboard" {
    xkb_layout us
    xkb_options caps:escape
}

# Key bindings
bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+d exec $menu

# Moving around
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

# Workspaces
bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10

bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

# Layout stuff
bindsym $mod+b splith
bindsym $mod+v splitv
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split
bindsym $mod+f fullscreen
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle

# Resizing containers
mode "resize" {
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

# System
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'

# Window colors
client.focused          $aqua $aqua $bg $yellow $aqua
client.focused_inactive $gray $gray $white $yellow $gray
client.unfocused        $bg $bg $gray $yellow $bg
client.urgent           $red $red $white $red $red

# Borders and gaps
default_border pixel 2
gaps inner 10
gaps outer 5

# Autostart
exec swayidle -w \
    timeout 300 'swaylock -f -c 282828' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock -f -c 282828'

exec_always ~/.config/waybar/launch.sh
exec_always ~/.config/sway/scripts/idle.sh

include /etc/sway/config.d/*
EOF
```

### 6. Configure polybar

```bash
# Create polybar directory
mkdir -p ~/.config/polybar

# Create polybar configuration
cat > ~/.config/polybar/config.ini << 'EOF'
[colors]
; Gruvbox color scheme
background = #282828
background-alt = #3c3836
foreground = #ebdbb2
primary = #d79921
secondary = #98971a
alert = #cc241d
disabled = #928374

[bar/main]
width = 100%
height = 32pt
radius = 0
background = ${colors.background}
foreground = ${colors.foreground}
line-size = 2pt
border-size = 2pt
border-color = #689d6a
padding-left = 1
padding-right = 1
module-margin = 1
separator = |
separator-foreground = ${colors.disabled}
font-0 = "JetBrains Mono Nerd Font:size=10;2"
modules-left = i3 xwindow
modules-center = date
modules-right = filesystem pulseaudio memory cpu wlan eth battery
cursor-click = pointer
cursor-scroll = ns-resize
enable-ipc = true
tray-position = right

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = true
wrapping-scroll = false
label-mode-padding = 2
label-mode-foreground = #000
label-mode-background = ${colors.primary}
label-focused = %index%
label-focused-background = ${colors.primary}
label-focused-foreground = #282828
label-focused-padding = 2
label-unfocused = %index%
label-unfocused-padding = 2
label-visible = %index%
label-visible-background = ${colors.background-alt}
label-visible-padding = ${self.label-focused-padding}
label-urgent = %index%
label-urgent-background = ${colors.alert}
label-urgent-padding = 2

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%
label-foreground = ${colors.foreground}

[module/filesystem]
type = internal/fs
interval = 25
mount-0 = /
label-mounted = %{F#689d6a}%mountpoint%%{F-} %percentage_used%%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio
format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>
label-volume = %percentage%%
label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock
label-layout = %layout%
label-layout-foreground = ${colors.primary}
label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-foreground = ${colors.background}
label-indicator-background = ${colors.secondary}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[module/network-base]
type = internal/network
interval = 5
format-connected = <label-connected>
format-disconnected = <label-disconnected>
label-disconnected = %{F#928374}%ifname% disconnected

[module/wlan]
inherit = network-base
interface-type = wireless
label-connected = %{F#689d6a}%ifname%%{F-} %essid% %local_ip%

[module/eth]
inherit = network-base
interface-type = wired
label-connected = %{F#689d6a}%ifname%%{F-} %local_ip%

[module/date]
type = internal/date
interval = 1
date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S
label = %date%
label-foreground = ${colors.primary}

[module/battery]
type = internal/battery
battery = BAT0
adapter = ADP1
full-at = 98
format-charging = <animation-charging> <label-charging>
format-discharging = <animation-discharging> <label-discharging>
format-full-prefix = "FULL "
format-full-prefix-foreground = ${colors.primary}
label-charging = %percentage%%
label-discharging = %percentage%%
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
animation-charging-foreground = ${colors.primary}
animation-charging-framerate = 750
animation-discharging-0 = 
animation-discharging-1 = 
animation-discharging-2 = 
animation-discharging-3 = 
animation-discharging-4 = 
animation-discharging-foreground = ${colors.primary}
animation-discharging-framerate = 750

[settings]
screenchange-reload = true
pseudo-transparency = true
EOF

# Create polybar launch script
cat > ~/.config/polybar/launch.sh << 'EOF'
#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
EOF

chmod +x ~/.config/polybar/launch.sh
```

### 7. Configure rofi

```bash
# Create rofi directory
mkdir -p ~/.config/rofi

# Create gruvbox theme for rofi
cat > ~/.config/rofi/gruvbox-dark.rasi << 'EOF'
* {
    bg: #282828;
    bg-alt: #3c3836;
    fg: #ebdbb2;
    fg-alt: #928374;
    
    red: #cc241d;
    green: #98971a;
    yellow: #d79921;
    blue: #458588;
    purple: #b16286;
    aqua: #689d6a;
    
    background-color: @bg;
    border: 0;
    margin: 0;
    padding: 0;
    spacing: 0;
}

window {
    width: 40%;
    background-color: @bg;
    border: 2px;
    border-color: @aqua;
    border-radius: 8px;
    location: center;
    anchor: center;
}

element {
    padding: 8 12;
    text-color: @fg;
}

element selected {
    text-color: @bg;
    background-color: @yellow;
}

element-text {
    background-color: inherit;
    text-color: inherit;
}

entry {
    background-color: @bg-alt;
    padding: 12;
    text-color: @fg;
    border-radius: 4px;
    margin: 8px;
}

inputbar {
    children: [prompt, entry];
    background-color: @bg;
}

listview {
    background-color: @bg;
    margin: 0 8 8 8;
    lines: 8;
}

prompt {
    background-color: @aqua;
    enabled: true;
    padding: 12 16;
    text-color: @bg;
    border-radius: 4px;
    margin: 8px 0 8px 8px;
}

scrollbar {
    width: 4px;
    border: 0;
    handle-color: @fg-alt;
    handle-width: 8px;
    padding: 0;
}
EOF

# Create rofi config
cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun,run,window";
    show-icons: true;
    terminal: "warp-terminal";
    drun-display-format: "{name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    sidebar-mode: false;
}

@theme "gruvbox-dark"
EOF
```

### 8. Configure Terminal Themes

#### For Warp Terminal:
```bash
# Create Warp themes directory
mkdir -p ~/.warp/themes

# Create gruvbox theme (already created in colors section)
cp ~/.config/gruvbox/colors.yaml ~/.warp/themes/gruvbox-dark.yaml
```

#### For Kitty:
```bash
# Create kitty config directory
mkdir -p ~/.config/kitty

# Create gruvbox theme for kitty
cat > ~/.config/kitty/gruvbox-dark.conf << 'EOF'
foreground            #ebdbb2
background            #282828
selection_foreground  #655b53
selection_background  #ebdbb2
url_color             #d65d0e

# Black
color0   #282828
color8   #928374

# Red  
color1   #cc241d
color9   #fb4934

# Green
color2   #98971a
color10  #b8bb26

# Yellow
color3   #d79921
color11  #fabd2f

# Blue
color4   #458588
color12  #83a598

# Magenta
color5   #b16286
color13  #d3869b

# Cyan
color6   #689d6a
color14  #8ec07c

# White
color7   #a89984
color15  #ebdbb2

# Tab bar
active_tab_foreground   #282828
active_tab_background   #d79921
inactive_tab_foreground #a89984
inactive_tab_background #3c3836

# Window
window_border_width 1
window_margin_width 0
window_padding_width 5
active_border_color #689d6a
inactive_border_color #3c3836

# Font
font_family JetBrains Mono Nerd Font
font_size 11.0
EOF

# Create kitty config
cat > ~/.config/kitty/kitty.conf << 'EOF'
include gruvbox-dark.conf

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Window settings
remember_window_size yes
initial_window_width 1024
initial_window_height 768
window_resize_step_cells 2
window_resize_step_lines 2

# Tab settings
tab_bar_edge bottom
tab_bar_style powerline
tab_powerline_style slanted

# Misc
enable_audio_bell no
visual_bell_duration 0.0
EOF
```

### 9. Set Up Display Manager

#### For LightDM:
```bash
# Create i3 desktop entry (if not exists)
sudo tee /usr/share/xsessions/i3-custom.desktop << 'EOF'
[Desktop Entry]
Name=i3 (Custom)
Comment=improved dynamic tiling window manager
Exec=i3
TryExec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOF
```

#### For GDM (GNOME):
```bash
# Enable Wayland for sway
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=true/' /etc/gdm3/custom.conf
```

### 10. Configure Autostart

Create autostart script:

```bash
# Create autostart directory
mkdir -p ~/.config/autostart

# Create autostart applications
cat > ~/.config/autostart/gruvbox-setup.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Gruvbox Setup
Exec=/home/$USER/.config/scripts/autostart.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Create autostart script
mkdir -p ~/.config/scripts
cat > ~/.config/scripts/autostart.sh << 'EOF'
#!/bin/bash

# Load gruvbox colors
source ~/.config/gruvbox/colors.sh

# Set wallpaper
nitrogen --set-scaled ~/.config/wallpapers/gruvbox-wallpaper.jpg

# Start compositor
picom -b

# Start notification daemon
dunst &

# Start network manager applet
nm-applet &

# Start bluetooth manager
blueman-applet &

# Set up audio
pulseaudio --start

echo "Gruvbox autostart complete"
EOF

chmod +x ~/.config/scripts/autostart.sh
```

## Testing and Validation

### Test Basic Functionality

1. **Log out and select i3** from the display manager
2. **Test keybindings**:
   - `Alt + Return` - Open terminal
   - `Alt + d` - Open rofi launcher
   - `Alt + 1-9` - Switch workspaces
   - `Alt + Shift + h/j/k/l` - Move windows

3. **Test applications**:
   - Open multiple terminals
   - Open web browser
   - Test workspace switching
   - Test window resizing (`Alt + r`)

### Troubleshooting

#### Common Issues:

1. **polybar not starting**:
   ```bash
   # Check polybar logs
   cat /tmp/polybar.log
   
   # Manually start polybar
   ~/.config/polybar/launch.sh
   ```

2. **Fonts not displaying correctly**:
   ```bash
   # Refresh font cache
   fc-cache -fv
   
   # Check if JetBrains Mono is installed
   fc-list | grep -i jetbrains
   ```

3. **rofi theme not applying**:
   ```bash
   # Test rofi configuration
   rofi -show drun -theme gruvbox-dark
   ```

4. **i3 not loading configuration**:
   ```bash
   # Check i3 configuration
   i3 --validate
   
   # View i3 logs
   journalctl -f | grep i3
   ```

## Performance Optimization

### Optimize i3 Performance

```bash
# Add to i3 config for better performance
echo '
# Disable window borders for single windows
smart_borders on

# Disable focus wrapping
focus_wrapping no

# Optimize for_window rules
for_window [class=".*"] border pixel 2
' >> ~/.config/i3/config
```

### Optimize polybar Performance

```bash
# Increase update intervals in polybar config
sed -i 's/interval = 1/interval = 5/' ~/.config/polybar/config.ini
sed -i 's/interval = 2/interval = 5/' ~/.config/polybar/config.ini
```

## Maintenance

### Update System and Packages

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# Update Warp manually when needed
curl -fsSL https://releases.warp.dev/stable/linux/deb/warp-terminal_*_amd64.deb -o /tmp/warp-new.deb
sudo dpkg -i /tmp/warp-new.deb
```

### Backup Configuration

```bash
# Create backup script
cat > ~/.config/scripts/backup-config.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="$HOME/backups/catred_config_$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Backup configurations
cp -r ~/.config/i3 "$BACKUP_DIR/"
cp -r ~/.config/sway "$BACKUP_DIR/"
cp -r ~/.config/polybar "$BACKUP_DIR/"
cp -r ~/.config/rofi "$BACKUP_DIR/"
cp -r ~/.config/kitty "$BACKUP_DIR/"
cp -r ~/.warp "$BACKUP_DIR/"
cp -r ~/.config/gruvbox "$BACKUP_DIR/"

echo "Backup created at $BACKUP_DIR"
EOF

chmod +x ~/.config/scripts/backup-config.sh
```

## Next Steps

1. **Configure additional workspaces** and application assignments
2. **Set up workspace-specific wallpapers**
3. **Configure additional polybar modules** (weather, music, etc.)
4. **Set up screen locking** with i3lock
5. **Configure notification themes** with dunst gruvbox colors

---

Your Linux setup is now complete! You have a fully functional i3-style tiling window manager with gruvbox theming and unified keybindings. The system provides excellent keyboard-driven workflow optimized for Linux development.