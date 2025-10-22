--[[
  Global Keymaps

  This file defines general keybindings for window navigation, buffer management,
  and common operations. Plugin-specific keymaps are defined in their respective
  plugin configuration files (lua/plugins/*.lua).

  Leader key: <Space>
  Local leader: <Space> (same as leader)

  Tip: Use :map to see all keymaps, or install which-key.nvim to see them interactively
--]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- LEADER KEY
-- ============================================================================

-- Leader key is set in init.lua before plugins load
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- ============================================================================
-- GENERAL
-- ============================================================================

-- Better escape (jk or kj to exit insert mode)
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Save file
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- ============================================================================
-- HELP & KEYMAP DISCOVERY
-- ============================================================================

-- Show all keymaps (which-key)
keymap("n", "?", function()
  require("which-key").show({ global = true })
end, { desc = "Show all keymaps (which-key)" })

-- Alternative help keymaps
keymap("n", "<leader>?", function()
  require("which-key").show({ global = true })
end, { desc = "Show all keymaps" })

keymap("n", "<leader>hk", function()
  require("which-key").show({ global = true })
end, { desc = "Show all keymaps" })

-- Search keymaps with Telescope (already defined in telescope.lua as <leader>fk)
-- Just adding a comment here for reference

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================

-- Navigate between windows with Ctrl + hjkl
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Split windows
keymap("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
keymap("n", "<leader>-", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- Close current window
keymap("n", "<leader>wd", "<C-w>q", { desc = "Close window" })

-- ============================================================================
-- BUFFER NAVIGATION
-- ============================================================================

-- Navigate between buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Close current buffer
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Force delete buffer" })

-- Close all buffers except current
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Delete other buffers" })

-- ============================================================================
-- TAB NAVIGATION
-- ============================================================================

-- Navigate between tabs
keymap("n", "<leader><tab>l", "<cmd>tablast<CR>", { desc = "Last tab" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<CR>", { desc = "First tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- ============================================================================
-- TEXT EDITING
-- ============================================================================

-- Stay in indent mode when indenting visual selections
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move selected lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better paste (don't replace clipboard when pasting over selection)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Join lines but keep cursor position
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })

-- Keep search results centered
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- ============================================================================
-- LINE NUMBERS
-- ============================================================================

-- Toggle line numbers
keymap("n", "<leader>un", "<cmd>set number!<CR>", { desc = "Toggle line numbers" })
keymap("n", "<leader>ur", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })

-- ============================================================================
-- TERMINAL
-- ============================================================================

-- Open terminal in split
keymap("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Terminal horizontal split" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vertical split" })

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- Exit terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- QUICKFIX & LOCATION LIST
-- ============================================================================

-- Quickfix list navigation
keymap("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap("n", "<leader>xQ", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })

-- Location list navigation
keymap("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Open location list" })
keymap("n", "<leader>xL", "<cmd>lclose<CR>", { desc = "Close location list" })
keymap("n", "[l", "<cmd>lprev<CR>", { desc = "Previous location item" })
keymap("n", "]l", "<cmd>lnext<CR>", { desc = "Next location item" })

-- ============================================================================
-- DIAGNOSTIC NAVIGATION
-- ============================================================================

-- Diagnostic keymaps (LSP errors/warnings)
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
keymap("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

-- ============================================================================
-- MISCELLANEOUS
-- ============================================================================

-- Toggle spell check
keymap("n", "<leader>us", "<cmd>setlocal spell!<CR>", { desc = "Toggle spell check" })

-- Toggle word wrap
keymap("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })

-- Increment/decrement numbers
keymap("n", "+", "<C-a>", { desc = "Increment number" })
keymap("n", "-", "<C-x>", { desc = "Decrement number" })

-- Better command line editing
keymap("c", "<C-a>", "<Home>", { noremap = true, desc = "Move to start of line" })
keymap("c", "<C-e>", "<End>", { noremap = true, desc = "Move to end of line" })

-- Disable arrow keys in normal mode (learn hjkl!)
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)
keymap("n", "<Left>", "<Nop>", opts)
keymap("n", "<Right>", "<Nop>", opts)
