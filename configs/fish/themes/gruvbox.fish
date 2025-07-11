# Gruvbox theme for Fish shell

# Color definitions
set -gx GRUVBOX_BG "282828"
set -gx GRUVBOX_FG "ebdbb2"
set -gx GRUVBOX_RED "cc241d"
set -gx GRUVBOX_GREEN "98971a"
set -gx GRUVBOX_YELLOW "d79921"
set -gx GRUVBOX_BLUE "458588"
set -gx GRUVBOX_PURPLE "b16286"
set -gx GRUVBOX_AQUA "689d6a"
set -gx GRUVBOX_ORANGE "d65d0e"
set -gx GRUVBOX_GRAY "928374"
set -gx GRUVBOX_BRIGHT_RED "fb4934"
set -gx GRUVBOX_BRIGHT_GREEN "b8bb26"
set -gx GRUVBOX_BRIGHT_YELLOW "fabd2f"
set -gx GRUVBOX_BRIGHT_BLUE "83a598"
set -gx GRUVBOX_BRIGHT_PURPLE "d3869b"
set -gx GRUVBOX_BRIGHT_AQUA "8ec07c"
set -gx GRUVBOX_BRIGHT_ORANGE "fe8019"
set -gx GRUVBOX_BG1 "3c3836"
set -gx GRUVBOX_BG2 "504945"
set -gx GRUVBOX_BG3 "665c54"
set -gx GRUVBOX_BG4 "7c6f64"
set -gx GRUVBOX_FG2 "d5c4a1"
set -gx GRUVBOX_FG3 "bdae93"
set -gx GRUVBOX_FG4 "a89984"

# Fish color scheme
set -U fish_color_normal $GRUVBOX_FG
set -U fish_color_command $GRUVBOX_BLUE
set -U fish_color_keyword $GRUVBOX_PURPLE
set -U fish_color_quote $GRUVBOX_GREEN
set -U fish_color_redirection $GRUVBOX_AQUA
set -U fish_color_end $GRUVBOX_ORANGE
set -U fish_color_error $GRUVBOX_RED
set -U fish_color_param $GRUVBOX_FG2
set -U fish_color_comment $GRUVBOX_GRAY
set -U fish_color_selection --background=$GRUVBOX_BG2
set -U fish_color_search_match --background=$GRUVBOX_BG2
set -U fish_color_operator $GRUVBOX_BRIGHT_AQUA
set -U fish_color_escape $GRUVBOX_PURPLE
set -U fish_color_autosuggestion $GRUVBOX_GRAY
set -U fish_color_cancel -r
set -U fish_color_cwd $GRUVBOX_YELLOW
set -U fish_color_cwd_root $GRUVBOX_RED
set -U fish_color_host $GRUVBOX_BLUE
set -U fish_color_host_remote $GRUVBOX_GREEN
set -U fish_color_status $GRUVBOX_RED
set -U fish_color_user $GRUVBOX_AQUA
set -U fish_color_valid_path --underline

# Completion pager colors
set -U fish_pager_color_progress $GRUVBOX_GRAY
set -U fish_pager_color_background
set -U fish_pager_color_prefix $GRUVBOX_PURPLE
set -U fish_pager_color_completion $GRUVBOX_FG
set -U fish_pager_color_description $GRUVBOX_GRAY
set -U fish_pager_color_selected_background --background=$GRUVBOX_BG2
set -U fish_pager_color_selected_prefix $GRUVBOX_PURPLE
set -U fish_pager_color_selected_completion $GRUVBOX_FG
set -U fish_pager_color_selected_description $GRUVBOX_GRAY

# Git prompt colors
set -g __fish_git_prompt_color_branch $GRUVBOX_PURPLE
set -g __fish_git_prompt_color_cleanstate $GRUVBOX_GREEN
set -g __fish_git_prompt_color_dirtystate $GRUVBOX_YELLOW
set -g __fish_git_prompt_color_invalidstate $GRUVBOX_RED
set -g __fish_git_prompt_color_merging $GRUVBOX_YELLOW
set -g __fish_git_prompt_color_stagedstate $GRUVBOX_GREEN
set -g __fish_git_prompt_color_untrackedfiles $GRUVBOX_RED
set -g __fish_git_prompt_color_upstream $GRUVBOX_BLUE