# Catppuccin Macchiato theme for Fish shell

# Color definitions
set -gx CATPPUCCIN_ROSEWATER "f4dbd6"
set -gx CATPPUCCIN_FLAMINGO "f0c6c6"
set -gx CATPPUCCIN_PINK "f5bde6"
set -gx CATPPUCCIN_MAUVE "c6a0f6"
set -gx CATPPUCCIN_RED "ed8796"
set -gx CATPPUCCIN_MAROON "ee99a0"
set -gx CATPPUCCIN_PEACH "f5a97f"
set -gx CATPPUCCIN_YELLOW "eed49f"
set -gx CATPPUCCIN_GREEN "a6da95"
set -gx CATPPUCCIN_TEAL "8bd5ca"
set -gx CATPPUCCIN_SKY "91d7e3"
set -gx CATPPUCCIN_SAPPHIRE "7dc4e4"
set -gx CATPPUCCIN_BLUE "8aadf4"
set -gx CATPPUCCIN_LAVENDER "b7bdf8"
set -gx CATPPUCCIN_TEXT "cad3f5"
set -gx CATPPUCCIN_SUBTEXT1 "b8c0e0"
set -gx CATPPUCCIN_SUBTEXT0 "a5adcb"
set -gx CATPPUCCIN_OVERLAY2 "939ab7"
set -gx CATPPUCCIN_OVERLAY1 "8087a2"
set -gx CATPPUCCIN_OVERLAY0 "6e738d"
set -gx CATPPUCCIN_SURFACE2 "5b6078"
set -gx CATPPUCCIN_SURFACE1 "494d64"
set -gx CATPPUCCIN_SURFACE0 "363a4f"
set -gx CATPPUCCIN_BASE "24273a"
set -gx CATPPUCCIN_MANTLE "1e2030"
set -gx CATPPUCCIN_CRUST "181926"

# Fish color scheme
set -U fish_color_normal $CATPPUCCIN_TEXT
set -U fish_color_command $CATPPUCCIN_BLUE
set -U fish_color_keyword $CATPPUCCIN_MAUVE
set -U fish_color_quote $CATPPUCCIN_GREEN
set -U fish_color_redirection $CATPPUCCIN_PINK
set -U fish_color_end $CATPPUCCIN_PEACH
set -U fish_color_error $CATPPUCCIN_RED
set -U fish_color_param $CATPPUCCIN_ROSEWATER
set -U fish_color_comment $CATPPUCCIN_OVERLAY0
set -U fish_color_selection --background=$CATPPUCCIN_SURFACE0
set -U fish_color_search_match --background=$CATPPUCCIN_SURFACE0
set -U fish_color_operator $CATPPUCCIN_SKY
set -U fish_color_escape $CATPPUCCIN_PINK
set -U fish_color_autosuggestion $CATPPUCCIN_OVERLAY0
set -U fish_color_cancel -r
set -U fish_color_cwd $CATPPUCCIN_YELLOW
set -U fish_color_cwd_root $CATPPUCCIN_RED
set -U fish_color_host $CATPPUCCIN_BLUE
set -U fish_color_host_remote $CATPPUCCIN_GREEN
set -U fish_color_status $CATPPUCCIN_RED
set -U fish_color_user $CATPPUCCIN_TEAL
set -U fish_color_valid_path --underline

# Completion pager colors
set -U fish_pager_color_progress $CATPPUCCIN_OVERLAY0
set -U fish_pager_color_background
set -U fish_pager_color_prefix $CATPPUCCIN_PINK
set -U fish_pager_color_completion $CATPPUCCIN_TEXT
set -U fish_pager_color_description $CATPPUCCIN_OVERLAY0
set -U fish_pager_color_selected_background --background=$CATPPUCCIN_SURFACE0
set -U fish_pager_color_selected_prefix $CATPPUCCIN_PINK
set -U fish_pager_color_selected_completion $CATPPUCCIN_TEXT
set -U fish_pager_color_selected_description $CATPPUCCIN_OVERLAY0

# Git prompt colors
set -g __fish_git_prompt_color_branch $CATPPUCCIN_MAUVE
set -g __fish_git_prompt_color_cleanstate $CATPPUCCIN_GREEN
set -g __fish_git_prompt_color_dirtystate $CATPPUCCIN_YELLOW
set -g __fish_git_prompt_color_invalidstate $CATPPUCCIN_RED
set -g __fish_git_prompt_color_merging $CATPPUCCIN_YELLOW
set -g __fish_git_prompt_color_stagedstate $CATPPUCCIN_GREEN
set -g __fish_git_prompt_color_untrackedfiles $CATPPUCCIN_RED
set -g __fish_git_prompt_color_upstream $CATPPUCCIN_BLUE