--[[
  Lazy.nvim Plugin Manager Setup

  This file bootstraps lazy.nvim (auto-installs if missing) and configures
  plugin loading. All plugins are defined in separate files under lua/plugins/

  lazy.nvim features:
  - Automatic lazy-loading for fast startup
  - Plugin management (install, update, clean)
  - Lockfile for reproducible builds
  - UI for managing plugins (:Lazy)

  Documentation: https://github.com/folke/lazy.nvim
--]]

-- ============================================================================
-- BOOTSTRAP LAZY.NVIM
-- ============================================================================

-- Path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed
if not vim.loop.fs_stat(lazypath) then
  -- Clone lazy.nvim from GitHub if not found
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none", -- Clone without file history for faster download
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use latest stable release
    lazypath,
  })
end

-- Add lazy.nvim to runtime path so we can require it
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- LAZY.NVIM CONFIGURATION
-- ============================================================================

require("lazy").setup({
  -- Import all plugin specs from lua/plugins/*.lua
  -- Each file should return a table of plugin specifications
  { import = "plugins" },
}, {
  -- Configuration options for lazy.nvim itself

  -- UI customization
  ui = {
    -- Use Nerd Font icons (requires Fira Code iScript or similar)
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },

  -- Performance optimizations
  performance = {
    cache = {
      enabled = true, -- Enable bytecode cache
    },
    rtp = {
      -- Disable some built-in plugins you probably don't use
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin", -- We use neo-tree instead
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- Automatically check for plugin updates (optional)
  checker = {
    enabled = true,
    notify = false, -- Don't spam with notifications
    frequency = 3600, -- Check every hour
  },

  -- Automatically install missing plugins on startup
  install = {
    missing = true,
    colorscheme = { "nord" }, -- Try loading nord theme during install
  },

  change_detection = {
    enabled = true,
    notify = false, -- Don't notify when config files change
  },
})

-- ============================================================================
-- KEYMAPS FOR LAZY.NVIM
-- ============================================================================

-- Open lazy.nvim plugin manager UI
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
