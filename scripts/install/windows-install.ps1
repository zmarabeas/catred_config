#
# Comprehensive Windows Installation Script for Catred Config
#
# This script bootstraps a complete, themed development environment on a fresh
# Windows system using PowerShell.
#

# --- Configuration & Helpers ---
$RepoDir = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
$BackupDir = "$env:USERPROFILE\.config-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$LogFile = "$env:USERPROFILE\catred_install.log"

# Logging function
function Log-Message {
    param ([string]$Level, [string]$Message)
    $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $LogEntry = "[$Timestamp] [$Level] $Message"
    $LogEntry | Out-File -FilePath $LogFile -Append
    Write-Host $LogEntry
}

# --- Pre-flight Checks ---
function Test-Prerequisites {
    Log-Message "INFO" "Starting pre-flight checks..."
    $winget_exists = (Get-Command winget -ErrorAction SilentlyContinue)
    $choco_exists = (Get-Command choco -ErrorAction SilentlyContinue)
    if (-not $winget_exists -and -not $choco_exists) {
        Log-Message "ERROR" "Winget or Chocolatey is required. Please install one and try again."
        exit 1
    }
    Log-Message "SUCCESS" "Pre-flight checks passed."
}

# --- Backup ---
function Backup-ExistingConfigs {
    Log-Message "INFO" "Backing up existing configurations to $BackupDir..."
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    
    $configsToBackup = @(
        "$env:USERPROFILE\.config\nvim",
        "$env:USERPROFILE\.config\fish",
        "$env:USERPROFILE\.config\zed",
        "$env:USERPROFILE\.config\komorebi",
        "$env:USERPROFILE\.config\whkd",
        "$env:USERPROFILE\.config\yasb"
    )

    foreach ($config in $configsToBackup) {
        if (Test-Path $config) {
            Log-Message "INFO" "Backing up $config..."
            Move-Item -Path $config -Destination $BackupDir
        }
    }
    Log-Message "SUCCESS" "Backup complete."
}

# --- Installation ---
function Install-Packages {
    Log-Message "INFO" "Installing packages..."
    
    # Core Utils
    winget install --id JanDeDobbeleer.OhMyPosh -e --accept-package-agreements
    winget install --id 7zip.7zip -e
    choco install -y stow neovim fish zed

    # Tiling WM
    winget install --id LGUG2Z.komorebi -e
    winget install --id LGUG2Z.whkd -e

    # Status Bar & Launcher
    winget install --id AmN.yasb -e
    winget install --id Flow-Launcher.Flow-Launcher -e

    # Terminals
    winget install --id 9N0DX20HK701 # Windows Terminal from Store
    winget install --id Warp.Warp -e
    winget install --id Ghostty.Ghostty -e

    # Nerd Fonts (requires manual step)
    Log-Message "WARNING" "Please install JetBrains Mono Nerd Font manually from: https://www.nerdfonts.com/font-downloads"

    Log-Message "SUCCESS" "Package installation complete."
}

# --- Configuration Symlinking ---
function Symlink-Configs {
    Log-Message "INFO" "Symlinking configuration files..."
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config" | Out-Null
    
    # Stow requires Git Bash or similar environment on Windows. Manual symlinking is more reliable here.
    $configItems = @("nvim", "fish", "zed", "komorebi", "whkd", "yasb")
    foreach ($item in $configItems) {
        $source = "$RepoDir\configs\$item"
        $destination = "$env:USERPROFILE\.config\$item"
        if (Test-Path $source) {
            New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
        }
    }
    Log-Message "SUCCESS" "Configuration files symlinked."
}

# --- System & Shell Setup ---
function Configure-System {
    Log-Message "INFO" "Configuring system and shell..."

    # Neovim plugins
    Log-Message "INFO" "Bootstrapping Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa

    Log-Message "INFO" "Please configure your default terminal to be Fish shell manually in Windows Terminal settings."
    Log-Message "SUCCESS" "System and shell configuration complete."
}

# --- Theming ---
function Apply-DefaultTheme {
    Log-Message "INFO" "Applying default theme (Catppuccin Macchiato)..."
    # Assumes bash is available via Git for Windows or WSL
    bash -c "$RepoDir/scripts/config/switch-theme.sh catppuccin-macchiato"
    Log-Message "SUCCESS" "Default theme applied."
}

# --- Post-Install ---
function Create-UninstallScript {
    Log-Message "INFO" "Creating uninstall script..."
    $uninstallScriptPath = "$RepoDir\uninstall.ps1"
    $uninstallScriptContent = @"
Write-Host 'This will uninstall Catred Config and its components.'
Read-Host -Prompt 'Press Enter to continue or Ctrl+C to cancel'

Write-Host 'Removing symlinks...'
\$configItems = @("nvim", "fish", "zed", "komorebi", "whkd", "yasb")
foreach (\$item in \$configItems) {
    Remove-Item -Path "\$env:USERPROFILE\.config\\\$item" -Force
}

Write-Host 'Uninstalling packages...'
winget uninstall --id LGUG2Z.komorebi
winget uninstall --id LGUG2Z.whkd
winget uninstall --id AmN.yasb
winget uninstall --id Flow-Launcher.Flow-Launcher
choco uninstall -y stow neovim fish zed

Write-Host "Uninstall complete. You may need to manually restore backups from $BackupDir"
"@
    $uninstallScriptContent | Out-File -FilePath $uninstallScriptPath -Encoding utf8
    Log-Message "SUCCESS" "Uninstall script created at $uninstallScriptPath"
}

# --- Main Execution ---
function Install-CatredCLI {
    Log-Message "INFO" "Installing catred CLI command..."
    
    $catredScript = Join-Path $RepoDir "scripts\catred"
    if (Test-Path $catredScript) {
        # For Windows, we'll create a batch wrapper
        $batchWrapper = @"
@echo off
bash "$catredScript" %*
"@
        $batchPath = "C:\ProgramData\chocolatey\bin\catred.bat"
        $batchWrapper | Out-File -FilePath $batchPath -Encoding ASCII
        Log-Message "SUCCESS" "catred CLI command installed globally"
    } else {
        Log-Message "WARNING" "catred CLI script not found, skipping CLI installation"
    }
}

function Main {
    Remove-Item -Path $LogFile -ErrorAction SilentlyContinue
    Log-Message "INFO" "Starting Catred Config Windows installation..."
    
    Test-Prerequisites
    Backup-ExistingConfigs
    Install-Packages
    Symlink-Configs
    Configure-System
    Apply-DefaultTheme
    Install-CatredCLI
    Create-UninstallScript

    Log-Message "SUCCESS" "Installation finished! See log at $LogFile"
    Log-Message "INFO" "Please restart your machine to apply all changes."
}

Main
