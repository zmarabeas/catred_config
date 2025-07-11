# Tokyo Night Storm theme for Fish shell

# Color definitions
set -gx TOKYO_BG "24283b"
set -gx TOKYO_FG "c0caf5"
set -gx TOKYO_RED "f7768e"
set -gx TOKYO_ORANGE "ff9e64"
set -gx TOKYO_YELLOW "e0af68"
set -gx TOKYO_GREEN "9ece6a"
set -gx TOKYO_TEAL "73daca"
set -gx TOKYO_CYAN "b4f9f8"
set -gx TOKYO_BLUE "7aa2f7"
set -gx TOKYO_PURPLE "bb9af7"
set -gx TOKYO_MAGENTA "c678dd"
set -gx TOKYO_GRAY "565f89"
set -gx TOKYO_COMMENT "565f89"
set -gx TOKYO_DARK "1f2335"
set -gx TOKYO_HIGHLIGHT "292e42"
set -gx TOKYO_MENU "16161e"
set -gx TOKYO_VISUAL "33467c"
set -gx TOKYO_SEARCH "3d59a1"
set -gx TOKYO_BLACK "15161e"
set -gx TOKYO_WHITE "c0caf5"
set -gx TOKYO_BRIGHT_BLACK "414868"
set -gx TOKYO_BRIGHT_CYAN "7dcfff"

# Fish color scheme
set -U fish_color_normal $TOKYO_FG
set -U fish_color_command $TOKYO_BLUE
set -U fish_color_keyword $TOKYO_PURPLE
set -U fish_color_quote $TOKYO_GREEN
set -U fish_color_redirection $TOKYO_TEAL
set -U fish_color_end $TOKYO_ORANGE
set -U fish_color_error $TOKYO_RED
set -U fish_color_param $TOKYO_FG
set -U fish_color_comment $TOKYO_COMMENT
set -U fish_color_selection --background=$TOKYO_HIGHLIGHT
set -U fish_color_search_match --background=$TOKYO_SEARCH
set -U fish_color_operator $TOKYO_CYAN
set -U fish_color_escape $TOKYO_PURPLE
set -U fish_color_autosuggestion $TOKYO_GRAY
set -U fish_color_cancel -r
set -U fish_color_cwd $TOKYO_YELLOW
set -U fish_color_cwd_root $TOKYO_RED
set -U fish_color_host $TOKYO_BLUE
set -U fish_color_host_remote $TOKYO_GREEN
set -U fish_color_status $TOKYO_RED
set -U fish_color_user $TOKYO_TEAL
set -U fish_color_valid_path --underline

# Completion pager colors
set -U fish_pager_color_progress $TOKYO_GRAY
set -U fish_pager_color_background
set -U fish_pager_color_prefix $TOKYO_PURPLE
set -U fish_pager_color_completion $TOKYO_FG
set -U fish_pager_color_description $TOKYO_GRAY
set -U fish_pager_color_selected_background --background=$TOKYO_HIGHLIGHT
set -U fish_pager_color_selected_prefix $TOKYO_PURPLE
set -U fish_pager_color_selected_completion $TOKYO_FG
set -U fish_pager_color_selected_description $TOKYO_GRAY

# Git prompt colors
set -g __fish_git_prompt_color_branch $TOKYO_PURPLE
set -g __fish_git_prompt_color_cleanstate $TOKYO_GREEN
set -g __fish_git_prompt_color_dirtystate $TOKYO_YELLOW
set -g __fish_git_prompt_color_invalidstate $TOKYO_RED
set -g __fish_git_prompt_color_merging $TOKYO_YELLOW
set -g __fish_git_prompt_color_stagedstate $TOKYO_GREEN
set -g __fish_git_prompt_color_untrackedfiles $TOKYO_RED
set -g __fish_git_prompt_color_upstream $TOKYO_BLUE