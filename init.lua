--[[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗     ██████╗  ██████╗ ██╗██████╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║    ██╔════╝ ██╔═══██╗██║██╔══██╗
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    ██║  ███╗██║   ██║██║██║  ██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    ██║   ██║██║   ██║██║██║  ██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║    ╚██████╔╝╚██████╔╝██║██████╔╝
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝     ╚═════╝  ╚═════╝ ╚═╝╚═════╝

  Modern Neovim Configuration
  Author: Your Name
  Repository: https://github.com/yourusername/nvim-god

  A complete, modular Neovim setup with LSP, AI tools, debugging, and more.
  Optimized for web development (JS/TS/PHP) and systems programming (Rust/Go).
--]]

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

-- Set <space> as the leader key early (before lazy.nvim loads)
-- NOTE: Must be set before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- BOOTSTRAP LAZY.NVIM
-- ============================================================================

-- Load lazy.nvim plugin manager (auto-installs if not present)
require("config.lazy")

-- ============================================================================
-- CORE CONFIGURATION
-- ============================================================================

-- Load general vim options (line numbers, tabs, search, etc.)
require("config.options")

-- Load global keymaps (window navigation, buffer management, etc.)
require("config.keymaps")

-- ============================================================================
-- PLUGIN CONFIGURATION
-- ============================================================================

-- All plugins are automatically loaded via lazy.nvim from lua/plugins/*.lua
-- Each file in lua/plugins/ returns a table of plugin specifications
-- See: lua/plugins/ directory for individual plugin configurations

-- ============================================================================
-- POST-INITIALIZATION
-- ============================================================================

-- Set colorscheme (after plugins are loaded)
vim.cmd.colorscheme("nord")

-- Print welcome message on startup (optional - remove if you prefer clean startup)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      -- Only show message if no files were opened
      vim.notify("🚀 Neovim GOD loaded successfully!", vim.log.levels.INFO)
    end
  end,
})
