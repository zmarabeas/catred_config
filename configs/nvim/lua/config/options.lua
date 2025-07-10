-- Neovim Options Configuration
-- Clean, sensible defaults for modern development

local opt = vim.opt

-- General
opt.mouse = "a"                          -- Enable mouse support
opt.clipboard = "unnamedplus"            -- Use system clipboard
opt.swapfile = false                     -- Disable swap files
opt.completeopt = "menu,menuone,noselect" -- Better completion

-- UI
opt.number = true                        -- Show line numbers
opt.relativenumber = true                -- Show relative line numbers
opt.cursorline = true                    -- Highlight current line
opt.termguicolors = true                 -- Enable 24-bit RGB colors
opt.background = "dark"                  -- Dark background
opt.signcolumn = "yes"                   -- Always show sign column
opt.cmdheight = 1                        -- Command line height
opt.scrolloff = 8                        -- Lines of context
opt.sidescrolloff = 8                    -- Columns of context
opt.pumheight = 10                       -- Popup menu height

-- Folding
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Indentation
opt.expandtab = true                     -- Use spaces instead of tabs
opt.shiftwidth = 2                       -- Size of an indent
opt.tabstop = 2                          -- Number of spaces tabs count for
opt.smartindent = true                   -- Smart auto-indenting

-- Search
opt.ignorecase = true                    -- Ignore case in search
opt.smartcase = true                     -- Smart case sensitivity
opt.hlsearch = true                      -- Highlight search results
opt.incsearch = true                     -- Incremental search

-- Splits
opt.splitbelow = true                    -- New horizontal splits below
opt.splitright = true                    -- New vertical splits to the right

-- Performance
opt.updatetime = 200                     -- Faster completion
opt.timeoutlen = 300                     -- Time to wait for mapped sequence

-- Backup and undo
opt.backup = false                       -- Disable backup files
opt.writebackup = false                  -- Disable backup before write
opt.undofile = true                      -- Enable persistent undo
opt.undolevels = 10000                   -- Maximum number of undos

-- Wildmenu
opt.wildmode = "longest:full,full"       -- Command-line completion mode
opt.wildignore:append { "*.o", "*.obj", ".git", "node_modules", ".DS_Store" }

-- Formatting
opt.wrap = false                         -- Disable line wrap
opt.linebreak = true                     -- Break lines at word boundaries
opt.breakindent = true                   -- Preserve indentation in wrapped text

-- Window options
opt.winminwidth = 5                      -- Minimum window width
opt.winwidth = 10                        -- Minimum current window width

-- Neovim specific
if vim.fn.has("nvim-0.9.0") == 1 then
  opt.shortmess:append({ W = true, I = true, c = true, C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0