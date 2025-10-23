--[[
  General Vim Options

  This file sets up sensible defaults for Neovim behavior, appearance,
  indentation, search, and more. All options are documented inline.

  Documentation: :help options
--]]

local opt = vim.opt

-- ============================================================================
-- GENERAL BEHAVIOR
-- ============================================================================

-- Enable mouse support in all modes
opt.mouse = "a"

-- Use system clipboard for all yank/delete/paste operations
-- Requires xclip/xsel (Linux) or pbcopy (macOS)
opt.clipboard = "unnamedplus"

-- Set default file encoding (commented out - fileencoding is buffer-local and auto-detected)
-- opt.fileencoding = "utf-8"  -- This causes E21 error with non-modifiable buffers

-- Disable swap files (we have undo files instead)
opt.swapfile = false

-- Enable persistent undo (survives restart)
opt.undofile = true
opt.undolevels = 10000

-- Don't create backup files
opt.backup = false
opt.writebackup = false

-- Allow hidden buffers (switch buffers without saving)
opt.hidden = true

-- Faster completion (default is 4000ms)
opt.updatetime = 250

-- Time to wait for mapped sequence (default 1000ms)
opt.timeoutlen = 300

-- ============================================================================
-- UI & APPEARANCE
-- ============================================================================

-- Show relative line numbers (current line shows absolute)
opt.number = true
opt.relativenumber = true

-- Highlight current line
opt.cursorline = true

-- Always show sign column (prevents text shifting when diagnostics appear)
opt.signcolumn = "yes"

-- Show column at 80 characters (code style guide)
opt.colorcolumn = "80"

-- Minimal number of screen lines above/below cursor
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Show whitespace characters
opt.list = true
opt.listchars = {
	tab = "→ ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "␣",
}

-- Enable 24-bit RGB color (required for modern themes)
opt.termguicolors = true

-- Command line height (0 = hide when not in use, requires Neovim 0.8+)
opt.cmdheight = 1

-- Show matching brackets when cursor is over them
opt.showmatch = true

-- Don't show mode in command line (we have lualine)
opt.showmode = false

-- Configure completion menu
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10 -- Max items in popup menu

-- Split windows behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right

-- Wrap long lines at word boundaries
opt.wrap = true
opt.linebreak = true

-- ============================================================================
-- INDENTATION & FORMATTING
-- ============================================================================

-- Number of spaces for a tab character
opt.tabstop = 2

-- Number of spaces for indentation
opt.shiftwidth = 2

-- Use spaces instead of tabs
opt.expandtab = true

-- Smart indentation (auto-indent new lines)
opt.smartindent = true
opt.autoindent = true

-- Round indent to multiple of shiftwidth
opt.shiftround = true

-- ============================================================================
-- SEARCH
-- ============================================================================

-- Highlight all search matches
opt.hlsearch = true

-- Show search matches as you type
opt.incsearch = true

-- Case-insensitive search unless uppercase letters are used
opt.ignorecase = true
opt.smartcase = true

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

-- Reduce redraw frequency for macros
opt.lazyredraw = true

-- Don't pass messages to completion menu
opt.shortmess:append("c")

-- ============================================================================
-- LANGUAGE & SPELL CHECK
-- ============================================================================

-- Set spell check language (disabled by default, toggle with :set spell)
opt.spelllang = "en_us"
opt.spell = false

-- ============================================================================
-- FOLDING (using Treesitter)
-- ============================================================================

-- Enable folding based on Treesitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Don't fold by default when opening files
opt.foldenable = false

-- Maximum nested folds
opt.foldlevel = 99

-- ============================================================================
-- NEOVIM-SPECIFIC OPTIONS
-- ============================================================================

-- Enable filetype detection, plugins, and indent
vim.cmd([[filetype plugin indent on]])

-- Automatically read file when changed outside Neovim
opt.autoread = true

-- Disable intro message
opt.shortmess:append("I")

-- Session options
opt.sessionoptions = {
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"help",
	"globals",
	"skiprtp",
	"folds",
}

-- ============================================================================
-- FONT CONFIGURATION (for GUI clients like Neovide)
-- ============================================================================

-- Set font for GUI clients (not needed for terminal Neovim)
if vim.g.neovide then
	vim.o.guifont = "Fira Code IScript"
	-- Neovide-specific settings
	vim.g.neovide_cursor_animation_length = 0.03
	vim.g.neovide_cursor_trail_size = 0.5
	vim.g.neovide_remember_window_size = true
end
