# Windows Installation Guide

## Overview

This guide covers the complete installation and configuration of the i3-style tiling window manager setup on Windows using komorebi, yasb, and Flow Launcher with unified gruvbox theming.

## Prerequisites

- **Windows 10 version 1903** or later (Windows 11 recommended)
- **Administrator privileges** for installation
- **PowerShell 5.1** or later (PowerShell 7+ recommended)
- **Windows Terminal** (recommended) or Command Prompt
- **Stable internet connection** for downloads

## Important: PowerShell Execution Policy

Windows may block script execution by default. Set the execution policy to allow scripts:

```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Installation Steps

### 1. Install Package Managers

#### Install winget (if not present)
```powershell
# Check if winget is available
winget --version

# If not available, install from Microsoft Store or GitHub
# Download from: https://github.com/microsoft/winget-cli/releases
```

#### Install Chocolatey (Alternative Package Manager)
```powershell
# Run as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 2. Install Core Dependencies

```powershell
# Install window manager
winget install LGUG2Z.komorebi

# Install hotkey daemon
winget install LGUG2Z.whkd

# Install status bar
winget install --id=AmN.yasb -e

# Install application launcher
winget install Flow-Launcher.Flow-Launcher

# Install terminal
winget install Warp.Warp

# Install Git (if not present)
winget install Git.Git

# Install configuration management
winget install twpayne.chezmoi

# Install fonts via chocolatey
choco install nerd-fonts-jetbrainsmono -y
```

### 3. Configure komorebi

Create komorebi configuration with gruvbox theming:

```powershell
# Create config directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\komorebi" -Force

# Create komorebi configuration
@"
{
  "float_rules": [
    {
      "kind": "exe",
      "id": "explorer.exe",
      "matching_strategy": "Legacy"
    },
    {
      "kind": "exe",
      "id": "winlogon.exe",
      "matching_strategy": "Legacy"
    },
    {
      "kind": "class",
      "id": "TaskManagerWindow",
      "matching_strategy": "Legacy"
    },
    {
      "kind": "class",
      "id": "CabinetWClass",
      "matching_strategy": "Legacy"
    },
    {
      "kind": "class",
      "id": "EVERYTHING",
      "matching_strategy": "Legacy"
    }
  ],
  "workspace_rules": [
    {
      "monitor": 0,
      "workspace": 0,
      "initial_workspace_rules": [
        {
          "kind": "exe",
          "id": "firefox.exe",
          "matching_strategy": "Legacy"
        }
      ]
    }
  ],
  "monitors": [
    {
      "workspaces": [
        {
          "name": "1",
          "layout": "BSP"
        },
        {
          "name": "2", 
          "layout": "BSP"
        },
        {
          "name": "3",
          "layout": "BSP"
        },
        {
          "name": "4",
          "layout": "BSP"
        },
        {
          "name": "5",
          "layout": "BSP"
        }
      ]
    }
  ],
  "window_hiding_behaviour": "Cloak",
  "cross_monitor_move_behaviour": "Insert",
  "default_workspace_padding": 10,
  "default_container_padding": 10,
  "border": true,
  "border_width": 4,
  "border_offset": -1,
  "active_window_border_colour": "#689d6a",
  "inactive_window_border_colour": "#3c3836",
  "border_implementation": "Komorebi",
  "animation": {
    "enabled": true,
    "duration": 250,
    "fps": 60
  },
  "transparency": false,
  "transparency_alpha": 240,
  "theme": {
    "name": "gruvbox",
    "palette": {
      "base": "#282828",
      "surface": "#3c3836",
      "overlay": "#665c54",
      "muted": "#928374",
      "subtle": "#a89984",
      "text": "#ebdbb2",
      "love": "#cc241d",
      "gold": "#d79921",
      "rose": "#b16286",
      "pine": "#98971a",
      "foam": "#689d6a",
      "iris": "#458588",
      "highlight_low": "#504945",
      "highlight_med": "#665c54",
      "highlight_high": "#7c6f64"
    }
  }
}
"@ | Out-File -FilePath "$env:USERPROFILE\.config\komorebi\komorebi.json" -Encoding UTF8
```

### 4. Configure whkd (Hotkey Daemon)

```powershell
# Create whkd configuration
@"
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

# Stack window
alt shift ctrl h: komorebic stack left
alt shift ctrl j: komorebic stack down
alt shift ctrl k: komorebic stack up
alt shift ctrl l: komorebic stack right

# Resize window
alt r: komorebic resize-axis horizontal increase
alt shift r: komorebic resize-axis horizontal decrease
alt t: komorebic resize-axis vertical increase
alt shift t: komorebic resize-axis vertical decrease

# Switch workspace
alt 1: komorebic focus-workspace 0
alt 2: komorebic focus-workspace 1
alt 3: komorebic focus-workspace 2
alt 4: komorebic focus-workspace 3
alt 5: komorebic focus-workspace 4
alt 6: komorebic focus-workspace 5
alt 7: komorebic focus-workspace 6
alt 8: komorebic focus-workspace 7
alt 9: komorebic focus-workspace 8

# Move window to workspace
alt shift 1: komorebic move-to-workspace 0
alt shift 2: komorebic move-to-workspace 1
alt shift 3: komorebic move-to-workspace 2
alt shift 4: komorebic move-to-workspace 3
alt shift 5: komorebic move-to-workspace 4
alt shift 6: komorebic move-to-workspace 5
alt shift 7: komorebic move-to-workspace 6
alt shift 8: komorebic move-to-workspace 7
alt shift 9: komorebic move-to-workspace 8

# Layout management
alt v: komorebic flip-layout vertical
alt b: komorebic flip-layout horizontal
alt f: komorebic toggle-maximize
alt shift space: komorebic toggle-float

# Window management
alt shift q: komorebic close
alt shift c: komorebic reload-configuration
alt shift r: komorebic restart

# Application launching
alt return: wt
alt d: pwsh -Command "Start-Process 'flow-launcher://'"
alt shift return: wt -d ~

# Toggle between workspaces
alt tab: komorebic cycle-focus next
alt shift tab: komorebic cycle-focus previous

# Manipulate windows
alt shift minus: komorebic minimize
alt shift equals: komorebic toggle-maximize

# Switch to monitor
alt ctrl 1: komorebic focus-monitor 0
alt ctrl 2: komorebic focus-monitor 1
alt ctrl 3: komorebic focus-monitor 2

# Move window to monitor
alt shift ctrl 1: komorebic move-to-monitor 0
alt shift ctrl 2: komorebic move-to-monitor 1
alt shift ctrl 3: komorebic move-to-monitor 2
"@ | Out-File -FilePath "$env:USERPROFILE\.config\whkd\whkdrc" -Encoding UTF8
```

### 5. Configure yasb (Status Bar)

```powershell
# Create yasb directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\yasb" -Force

# Create yasb configuration
@"
bars:
  status-bar:
    enabled: true
    screens: ['*']
    class_name: "yasb-bar"
    alignment: "top"
    blur_effect: false
    border_color: "#689d6a"
    border_width: 2
    height: 32
    opacity: 1.0
    widgets:
      left: ["komorebi_workspaces", "active_window"]
      center: ["clock"]
      right: ["cpu", "memory", "battery", "system_tray"]

widgets:
  komorebi_workspaces:
    type: "yasb.komorebi.workspaces.KomorebiWorkspacesWidget"
    options:
      label_offline: "Disconnected"
      label_workspace_btn: "{index}"
      label_default_name: "{index}"
      label_zero_index: false
      hide_empty_workspaces: false

  active_window:
    type: "yasb.active_window.ActiveWindowWidget" 
    options:
      label: "{win_title}"
      label_alt: "[class_name='{win_class}' exe='{win_exe}']"
      label_no_window: "Desktop"
      max_length: 48
      max_length_ellipsis: "..."

  clock:
    type: "yasb.clock.ClockWidget"
    options:
      label: "{%H:%M:%S}"
      label_alt: "{%A, %B %d, %Y}"
      update_interval: 1000

  cpu:
    type: "yasb.cpu.CpuWidget"
    options:
      label: "CPU: {cpu_percent}%"
      update_interval: 2000

  memory:
    type: "yasb.memory.MemoryWidget"
    options:
      label: "RAM: {virtual_mem_percent}%"
      update_interval: 2000

  battery:
    type: "yasb.battery.BatteryWidget"
    options:
      label: "{icon} {percent}%"
      label_alt: "{icon} {percent}% | {time_remaining}"

  system_tray:
    type: "yasb.system_tray.SystemTrayWidget"
    options:
      label: "{data}"
"@ | Out-File -FilePath "$env:USERPROFILE\.config\yasb\config.yaml" -Encoding UTF8

# Create yasb styles
@"
/* Gruvbox theme for yasb */
.yasb-bar {
    background-color: #282828;
    color: #ebdbb2;
    border-bottom: 2px solid #3c3836;
    font-family: "JetBrains Mono Nerd Font";
    font-size: 13px;
}

/* Komorebi workspaces */
.komorebi-workspaces .ws-btn {
    background-color: #3c3836;
    color: #928374;
    border: none;
    margin: 2px;
    padding: 4px 8px;
    border-radius: 4px;
    min-width: 24px;
    text-align: center;
}

.komorebi-workspaces .ws-btn.active {
    background-color: #d79921;
    color: #282828;
    font-weight: bold;
}

.komorebi-workspaces .ws-btn:hover {
    background-color: #504945;
    color: #ebdbb2;
}

/* Active window */
.active-window-widget {
    color: #ebdbb2;
    background-color: #3c3836;
    padding: 4px 8px;
    border-radius: 4px;
    margin: 0 8px;
    max-width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* Clock */
.clock-widget {
    color: #d79921;
    font-weight: bold;
    padding: 4px 8px;
    background-color: #3c3836;
    border-radius: 4px;
}

/* System widgets */
.cpu-widget {
    color: #98971a;
    padding: 2px 6px;
    background-color: #3c3836;
    border-radius: 3px;
    margin: 1px;
}

.memory-widget {
    color: #458588;
    padding: 2px 6px;
    background-color: #3c3836;
    border-radius: 3px;
    margin: 1px;
}

.battery-widget {
    color: #b16286;
    padding: 2px 6px;
    background-color: #3c3836;
    border-radius: 3px;
    margin: 1px;
}

.system-tray-widget {
    padding: 2px 6px;
    margin: 1px;
}

/* Generic widget styling */
.widget {
    padding: 2px 6px;
    margin: 1px;
    border-radius: 3px;
}

/* Hover effects */
.widget:hover {
    background-color: #504945;
}

/* Error states */
.widget.error {
    color: #cc241d;
    background-color: #3c3836;
}

/* Success states */
.widget.success {
    color: #98971a;
    background-color: #3c3836;
}

/* Warning states */
.widget.warning {
    color: #d79921;
    background-color: #3c3836;
}
"@ | Out-File -FilePath "$env:USERPROFILE\.config\yasb\styles.css" -Encoding UTF8
```

### 6. Configure Flow Launcher

```powershell
# Create Flow Launcher themes directory
New-Item -ItemType Directory -Path "$env:APPDATA\FlowLauncher\Themes" -Force

# Create gruvbox theme
@"
{
  "Name": "Gruvbox Dark",
  "Author": "Your Name",
  "Version": "1.0.0",
  "ThemeDescription": "Gruvbox color scheme for Flow Launcher",
  "QueryBoxFont": "JetBrains Mono Nerd Font",
  "QueryBoxFontSize": 18,
  "QueryBoxFontStretch": "Normal",
  "QueryBoxFontWeight": "Normal",
  "QueryBoxFontStyle": "Normal",
  "ResultFont": "JetBrains Mono Nerd Font", 
  "ResultFontSize": 14,
  "ResultFontStretch": "Normal",
  "ResultFontWeight": "Normal",
  "ResultFontStyle": "Normal",
  "WindowBorderColor": "#689d6a",
  "WindowBorderThickness": 2,
  "WindowCornerRadius": 8,
  "WindowBackground": "#282828",
  "QueryBoxBackground": "#3c3836",
  "QueryBoxForeground": "#ebdbb2",
  "QueryBoxSelectionColor": "#d79921",
  "ResultBackground": "#282828",
  "ResultBackgroundSelected": "#d79921",
  "ResultForeground": "#ebdbb2",
  "ResultForegroundSelected": "#282828",
  "ResultSubForeground": "#928374",
  "ResultSubForegroundSelected": "#1d2021",
  "ScrollBarColor": "#928374",
  "ScrollBarBackgroundColor": "#3c3836"
}
"@ | Out-File -FilePath "$env:APPDATA\FlowLauncher\Themes\Gruvbox-Dark.xaml" -Encoding UTF8
```

### 7. Configure Warp Terminal

```powershell
# Create Warp themes directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.warp\themes" -Force

# Create gruvbox theme
@"
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
"@ | Out-File -FilePath "$env:USERPROFILE\.warp\themes\gruvbox-dark.yaml" -Encoding UTF8
```

### 8. Start Services

```powershell
# Start komorebi
Start-Process -FilePath "komorebic.exe" -ArgumentList "start" -WindowStyle Hidden

# Start whkd
Start-Process -FilePath "whkd.exe" -WindowStyle Hidden

# Start yasb
Start-Process -FilePath "yasb.exe" -WindowStyle Hidden
```

### 9. Configure Startup

Create a startup script to automatically start all services:

```powershell
# Create startup script
@"
@echo off
echo Starting Catred Config services...

echo Starting komorebi...
start /min komorebic.exe start

echo Starting whkd...
start /min whkd.exe

echo Starting yasb...
start /min yasb.exe

echo All services started successfully!
"@ | Out-File -FilePath "$env:USERPROFILE\Start-CatredConfig.bat" -Encoding ASCII

# Create startup task
$action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Start-CatredConfig.bat"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "CatredConfig" -Action $action -Trigger $trigger -Settings $settings -Description "Start Catred Config services"
```

## Configuration

### Customize Flow Launcher

1. **Open Flow Launcher** (Alt + D)
2. **Settings** → **Theme** → Select "Gruvbox Dark"
3. **Settings** → **Hotkey** → Set to Alt + D
4. **Install plugins**:
   - Window Walker
   - Calculator
   - System Commands
   - Everything (if using Everything search)

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

1. **komorebi not starting**:
   - Check if Windows Defender is blocking execution
   - Verify PowerShell execution policy
   - Run as administrator: `komorebic start`

2. **Keybindings not working**:
   - Check if whkd is running: `Get-Process whkd`
   - Verify configuration file syntax
   - Run whkd with debugging: `whkd --debug`

3. **yasb not appearing**:
   - Check if yasb is running: `Get-Process yasb`
   - Verify configuration file format
   - Check yasb logs in `$env:USERPROFILE\.config\yasb\logs`

### Debugging Commands

```powershell
# Check running services
Get-Process | Where-Object {$_.ProcessName -match "komorebi|whkd|yasb"}

# Check komorebi state
komorebic.exe query windows

# Reload configurations
komorebic.exe reload-configuration
Stop-Process -Name "yasb" -Force; Start-Process "yasb.exe"
```

### Performance Optimization

1. **Disable animations** (if performance issues):
   ```json
   "animation": {
     "enabled": false
   }
   ```

2. **Reduce yasb update intervals**:
   ```yaml
   update_interval: 5000  # Increase from 2000
   ```

3. **Optimize window rules**:
   - Add more specific float rules for better performance
   - Use class names instead of executable names where possible

## Alternative Tools

### GlazeWM (Alternative to komorebi)

If you prefer a different approach:

```powershell
# Install GlazeWM
winget install glzr-io.glazewm

# Configure GlazeWM with similar settings
# Configuration goes in: $env:USERPROFILE\.glaze-wm\config.yaml
```

### PowerToys (Additional Utilities)

```powershell
# Install PowerToys for additional features
winget install Microsoft.PowerToys
```

## Maintenance

### Regular Updates

```powershell
# Update all packages
winget upgrade --all

# Update chocolatey packages
choco upgrade all -y

# Restart services after updates
komorebic.exe restart
Stop-Process -Name "whkd" -Force; Start-Process "whkd.exe"
Stop-Process -Name "yasb" -Force; Start-Process "yasb.exe"
```

### Backup Configuration

```powershell
# Create backup directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\backups\catred_config" -Force

# Backup configurations
Copy-Item -Path "$env:USERPROFILE\.config\komorebi" -Destination "$env:USERPROFILE\backups\catred_config\" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\.config\whkd" -Destination "$env:USERPROFILE\backups\catred_config\" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\.config\yasb" -Destination "$env:USERPROFILE\backups\catred_config\" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\.warp" -Destination "$env:USERPROFILE\backups\catred_config\" -Recurse -Force
```

## Next Steps

1. **Configure workspace-specific applications**
2. **Set up automated backups**
3. **Customize yasb with additional widgets**
4. **Configure Flow Launcher plugins**
5. **Set up automatic theme switching**

---

Your Windows setup is now complete! You have a fully functional i3-style tiling window manager with gruvbox theming and unified keybindings. The system provides excellent keyboard-driven workflow optimized for Windows.