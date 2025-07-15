# Fish Shell Configuration
# Modern, user-friendly shell with sensible defaults

# Set greeting
set fish_greeting ""

# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"

# Path additions
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin
fish_add_path ~/.npm-global/bin

# Development environment variables
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx GPG_TTY (tty)

# Rust environment
set -gx RUSTUP_HOME ~/.rustup
set -gx CARGO_HOME ~/.cargo

# Go environment
set -gx GOPATH ~/go
set -gx GOPROXY https://proxy.golang.org,direct
set -gx GOSUMDB sum.golang.org

# Node.js environment
set -gx NODE_OPTIONS "--max-old-space-size=4096"
set -gx NPM_CONFIG_PREFIX ~/.npm-global

# Python environment
set -gx PYTHONDONTWRITEBYTECODE 1
set -gx PYTHONUNBUFFERED 1

# Theme configuration - Load theme based on system preference
if test -f ~/.config/catred_config/current_theme
    set CATRED_THEME (cat ~/.config/catred_config/current_theme)
else
    set CATRED_THEME "catppuccin-macchiato"
end

# Load theme-specific colors
switch $CATRED_THEME
    case "catppuccin-macchiato"
        source ~/.config/fish/themes/catppuccin-macchiato.fish
    case "gruvbox"
        source ~/.config/fish/themes/gruvbox.fish
    case "tokyo-night-storm"
        source ~/.config/fish/themes/tokyo-night-storm.fish
    case "*"
        source ~/.config/fish/themes/catppuccin-macchiato.fish
end

# Aliases - using fallbacks if tools not installed
alias vim="nvim"
alias vi="nvim"

# Modern CLI tools with fallbacks
if command -v bat >/dev/null
    alias cat="bat"
end

if command -v exa >/dev/null
    alias ls="exa --icons"
    alias ll="exa -la --icons"
    alias la="exa -la --icons"
    alias tree="exa --tree --icons"
else
    alias ll="ls -la"
    alias la="ls -la"
end

if command -v rg >/dev/null
    alias grep="rg"
end

if command -v fd >/dev/null
    alias find="fd"
end

if command -v procs >/dev/null
    alias ps="procs"
end

if command -v dust >/dev/null
    alias du="dust"
end

if command -v duf >/dev/null
    alias df="duf"
end

if command -v btop >/dev/null
    alias top="btop"
    alias htop="btop"
end

# Git aliases
alias g="git"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gco="git checkout"
alias gcb="git checkout -b"

# Development aliases
alias c="code"
alias z="zed"
alias serve="python -m http.server"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias timestamp="date +%s"
alias datetime="date '+%Y-%m-%d %H:%M:%S'"

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias home="cd ~"

# System information
alias sysinfo="neofetch"
alias weather="curl -s wttr.in"
alias ip="curl -s ifconfig.me"
alias localip="ipconfig getifaddr en0"

# Package manager shortcuts
if command -v brew >/dev/null
    alias update="brew update && brew upgrade"
    alias cleanup="brew cleanup"
end

if command -v apt >/dev/null
    alias update="sudo apt update && sudo apt upgrade"
    alias install="sudo apt install"
end

if command -v pacman >/dev/null
    alias update="sudo pacman -Syu"
    alias install="sudo pacman -S"
end

# Development shortcuts
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrt="npm run test"
alias nrl="npm run lint"

alias prd="poetry run dev"
alias prb="poetry run build"
alias prs="poetry run start"
alias prt="poetry run test"

alias crd="cargo run --release"
alias cb="cargo build"
alias ct="cargo test"
alias cc="cargo check"

# Docker shortcuts
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcb="docker compose build"
alias dcp="docker compose pull"

# Kubernetes shortcuts
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"

# Interactive functions
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function extract
    if test -f $argv[1]
        switch $argv[1]
            case "*.tar.bz2"
                tar xjf $argv[1]
            case "*.tar.gz"
                tar xzf $argv[1]
            case "*.bz2"
                bunzip2 $argv[1]
            case "*.rar"
                unrar x $argv[1]
            case "*.gz"
                gunzip $argv[1]
            case "*.tar"
                tar xf $argv[1]
            case "*.tbz2"
                tar xjf $argv[1]
            case "*.tgz"
                tar xzf $argv[1]
            case "*.zip"
                unzip $argv[1]
            case "*.Z"
                uncompress $argv[1]
            case "*.7z"
                7z x $argv[1]
            case "*"
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

function backup
    if test (count $argv) -eq 0
        echo "Usage: backup <file>"
        return 1
    end
    cp $argv[1] $argv[1].backup.(date +%Y%m%d%H%M%S)
end

function weather
    if test (count $argv) -eq 0
        curl -s wttr.in
    else
        curl -s wttr.in/$argv[1]
    end
end

# Theme switching function
function theme
    if test (count $argv) -eq 0
        echo "Current theme: $CATRED_THEME"
        echo "Available themes: catppuccin-macchiato, gruvbox, tokyo-night-storm"
        return 0
    end
    
    switch $argv[1]
        case "catppuccin-macchiato" "gruvbox" "tokyo-night-storm"
            echo $argv[1] > ~/.config/catred_config/current_theme
            source ~/.config/fish/themes/$argv[1].fish
            set -g CATRED_THEME $argv[1]
            echo "Theme switched to $argv[1]"
            echo "Restart your terminal or run 'exec fish' to apply changes"
        case "*"
            echo "Unknown theme: $argv[1]"
            echo "Available themes: catppuccin-macchiato, gruvbox, tokyo-night-storm"
    end
end

# Load local configuration if it exists
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# Initialize tools if available
if command -v starship >/dev/null
    starship init fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
end

if command -v fzf >/dev/null
    fzf --fish | source
end

# Enable syntax highlighting
if test -f ~/.config/fish/conf.d/fish-syntax-highlighting.fish
    source ~/.config/fish/conf.d/fish-syntax-highlighting.fish
end

# Git prompt configuration
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1
set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

# Disable default fish prompt if using starship
if not command -v starship >/dev/null
    function fish_prompt
        set -l last_status $status
        
        # User and hostname
        set_color $fish_color_user
        echo -n (whoami)
        set_color normal
        echo -n "@"
        set_color $fish_color_host
        echo -n (hostname -s)
        set_color normal
        echo -n ":"
        
        # Current directory
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal
        
        # Git status
        echo -n (__fish_git_prompt)
        
        # Prompt character
        if test $last_status -eq 0
            set_color green
        else
            set_color red
        end
        echo -n " ❯ "
        set_color normal
    end
end