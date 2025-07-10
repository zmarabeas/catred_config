#!/bin/bash
# Gruvbox Dark color palette - Shell format
# Source: https://github.com/morhetz/gruvbox

# Background colors
export GRUVBOX_BG="#282828"              # Main background
export GRUVBOX_BG0_H="#1d2021"          # Hard background  
export GRUVBOX_BG0_S="#32302f"          # Soft background
export GRUVBOX_BG1="#3c3836"            # Darker background
export GRUVBOX_BG2="#504945"            # Selection background
export GRUVBOX_BG3="#665c54"            # Status line background
export GRUVBOX_BG4="#7c6f64"            # Line numbers

# Foreground colors
export GRUVBOX_FG="#ebdbb2"             # Main foreground
export GRUVBOX_FG0="#fbf1c7"            # Light foreground
export GRUVBOX_FG1="#ebdbb2"            # Default foreground
export GRUVBOX_FG2="#d5c4a1"            # Comments
export GRUVBOX_FG3="#bdae93"            # Darker foreground
export GRUVBOX_FG4="#a89984"            # Dark foreground

# Accent colors
export GRUVBOX_RED="#cc241d"            # Variables, errors
export GRUVBOX_GREEN="#98971a"          # Strings, success
export GRUVBOX_YELLOW="#d79921"         # Classes, warnings
export GRUVBOX_BLUE="#458588"           # Functions, info
export GRUVBOX_PURPLE="#b16286"         # Keywords, purple
export GRUVBOX_AQUA="#689d6a"           # Regex, cyan
export GRUVBOX_ORANGE="#d65d0e"         # Numbers, orange
export GRUVBOX_GRAY="#928374"           # Comments, disabled

# Bright colors
export GRUVBOX_RED_BRIGHT="#fb4934"     # Bright red
export GRUVBOX_GREEN_BRIGHT="#b8bb26"   # Bright green
export GRUVBOX_YELLOW_BRIGHT="#fabd2f"  # Bright yellow
export GRUVBOX_BLUE_BRIGHT="#83a598"    # Bright blue
export GRUVBOX_PURPLE_BRIGHT="#d3869b"  # Bright purple
export GRUVBOX_AQUA_BRIGHT="#8ec07c"    # Bright aqua
export GRUVBOX_ORANGE_BRIGHT="#fe8019"  # Bright orange

# Special purpose colors
export GRUVBOX_NEUTRAL_RED="#cc241d"
export GRUVBOX_NEUTRAL_GREEN="#98971a"
export GRUVBOX_NEUTRAL_YELLOW="#d79921"
export GRUVBOX_NEUTRAL_BLUE="#458588"
export GRUVBOX_NEUTRAL_PURPLE="#b16286"
export GRUVBOX_NEUTRAL_AQUA="#689d6a"
export GRUVBOX_NEUTRAL_ORANGE="#d65d0e"

# Faded colors
export GRUVBOX_FADED_RED="#9d0006"
export GRUVBOX_FADED_GREEN="#79740e"
export GRUVBOX_FADED_YELLOW="#b57614"
export GRUVBOX_FADED_BLUE="#076678"
export GRUVBOX_FADED_PURPLE="#8f3f71"
export GRUVBOX_FADED_AQUA="#427b58"
export GRUVBOX_FADED_ORANGE="#af3a03"

# Hex values without # prefix for some applications
export GRUVBOX_BG_HEX="282828"
export GRUVBOX_FG_HEX="ebdbb2"
export GRUVBOX_RED_HEX="cc241d"
export GRUVBOX_GREEN_HEX="98971a"
export GRUVBOX_YELLOW_HEX="d79921"
export GRUVBOX_BLUE_HEX="458588"
export GRUVBOX_PURPLE_HEX="b16286"
export GRUVBOX_AQUA_HEX="689d6a"
export GRUVBOX_ORANGE_HEX="d65d0e"
export GRUVBOX_GRAY_HEX="928374"

# RGB values for applications requiring RGB format
export GRUVBOX_BG_RGB="40,40,40"
export GRUVBOX_FG_RGB="235,219,178"
export GRUVBOX_RED_RGB="204,36,29"
export GRUVBOX_GREEN_RGB="152,151,26"
export GRUVBOX_YELLOW_RGB="215,153,33"
export GRUVBOX_BLUE_RGB="69,133,136"
export GRUVBOX_PURPLE_RGB="177,98,134"
export GRUVBOX_AQUA_RGB="104,157,106"
export GRUVBOX_ORANGE_RGB="214,93,14"
export GRUVBOX_GRAY_RGB="146,131,116"

# Platform-specific prefixes
case "$(uname)" in
    Darwin)
        # macOS SketchyBar format (0xff prefix)
        export GRUVBOX_BG_SKETCH="0xff282828"
        export GRUVBOX_FG_SKETCH="0xffebdbb2"
        export GRUVBOX_YELLOW_SKETCH="0xffd79921"
        export GRUVBOX_AQUA_SKETCH="0xff689d6a"
        export GRUVBOX_RED_SKETCH="0xffcc241d"
        export GRUVBOX_GREEN_SKETCH="0xff98971a"
        ;;
    Linux)
        # Linux i3/polybar format (# prefix)
        export GRUVBOX_BG_I3="#282828"
        export GRUVBOX_FG_I3="#ebdbb2"
        export GRUVBOX_YELLOW_I3="#d79921"
        export GRUVBOX_AQUA_I3="#689d6a"
        export GRUVBOX_RED_I3="#cc241d"
        export GRUVBOX_GREEN_I3="#98971a"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        # Windows format (# prefix)
        export GRUVBOX_BG_WIN="#282828"
        export GRUVBOX_FG_WIN="#ebdbb2"
        export GRUVBOX_YELLOW_WIN="#d79921"
        export GRUVBOX_AQUA_WIN="#689d6a"
        export GRUVBOX_RED_WIN="#cc241d"
        export GRUVBOX_GREEN_WIN="#98971a"
        ;;
esac

# Set theme loaded flag
export GRUVBOX_THEME_LOADED=1

# Function to display color palette
show_gruvbox_palette() {
    echo "Gruvbox Dark Color Palette"
    echo "========================="
    echo "Background: $GRUVBOX_BG"
    echo "Foreground: $GRUVBOX_FG"
    echo "Red:        $GRUVBOX_RED"
    echo "Green:      $GRUVBOX_GREEN"
    echo "Yellow:     $GRUVBOX_YELLOW"
    echo "Blue:       $GRUVBOX_BLUE"
    echo "Purple:     $GRUVBOX_PURPLE"
    echo "Aqua:       $GRUVBOX_AQUA"
    echo "Orange:     $GRUVBOX_ORANGE"
    echo "Gray:       $GRUVBOX_GRAY"
}

# Function to validate color format
validate_gruvbox_colors() {
    local errors=0
    
    # Check if all required colors are set
    required_colors=(
        "GRUVBOX_BG" "GRUVBOX_FG" "GRUVBOX_RED" "GRUVBOX_GREEN"
        "GRUVBOX_YELLOW" "GRUVBOX_BLUE" "GRUVBOX_PURPLE" "GRUVBOX_AQUA"
    )
    
    for color in "${required_colors[@]}"; do
        if [[ -z "${!color}" ]]; then
            echo "Error: $color is not set"
            ((errors++))
        fi
    done
    
    return $errors
}

# Export function for use in other scripts
export -f show_gruvbox_palette
export -f validate_gruvbox_colors