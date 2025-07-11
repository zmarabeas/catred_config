# YASB Launch Script for Windows
# Load theme and start YASB

# Get current theme
$themeFile = "$env:USERPROFILE\.config\catred_config\current_theme"
if (Test-Path $themeFile) {
    $currentTheme = Get-Content $themeFile -Raw
    $currentTheme = $currentTheme.Trim()
} else {
    $currentTheme = "catppuccin-macchiato"
}

# Generate theme-specific CSS variables
$cssVars = @"
/* Auto-generated theme variables */
:root {
"@

switch ($currentTheme) {
    "catppuccin-macchiato" {
        $cssVars += @"
  --bg-primary: #24273a;
  --bg-secondary: #1e2030;
  --fg-primary: #cad3f5;
  --fg-secondary: #a5adcb;
  --accent-blue: #8aadf4;
  --accent-green: #a6da95;
  --accent-yellow: #eed49f;
  --accent-orange: #f5a97f;
  --accent-red: #ed8796;
  --accent-purple: #c6a0f6;
"@
    }
    "gruvbox" {
        $cssVars += @"
  --bg-primary: #282828;
  --bg-secondary: #1d2021;
  --fg-primary: #ebdbb2;
  --fg-secondary: #bdae93;
  --accent-blue: #458588;
  --accent-green: #98971a;
  --accent-yellow: #d79921;
  --accent-orange: #d65d0e;
  --accent-red: #cc241d;
  --accent-purple: #b16286;
"@
    }
    "tokyo-night-storm" {
        $cssVars += @"
  --bg-primary: #24283b;
  --bg-secondary: #1f2335;
  --fg-primary: #c0caf5;
  --fg-secondary: #9aa5ce;
  --accent-blue: #7aa2f7;
  --accent-green: #9ece6a;
  --accent-yellow: #e0af68;
  --accent-orange: #ff9e64;
  --accent-red: #f7768e;
  --accent-purple: #bb9af7;
"@
    }
}

$cssVars += @"
}
"@

# Create theme-specific styles file
$stylesPath = "$env:USERPROFILE\.config\catred_config\configs\status-bars\yasb\styles-current.css"
$baseStyles = Get-Content "$env:USERPROFILE\.config\catred_config\configs\status-bars\yasb\styles.css" -Raw
$themedStyles = $cssVars + "`n`n" + $baseStyles

Set-Content -Path $stylesPath -Value $themedStyles

# Stop existing YASB instances
Get-Process yasb -ErrorAction SilentlyContinue | Stop-Process -Force

# Start YASB
Start-Process yasb -ArgumentList "--config", "$env:USERPROFILE\.config\catred_config\configs\status-bars\yasb\config.yaml"

Write-Host "YASB launched with $currentTheme theme"