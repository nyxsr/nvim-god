--[[
  Git Integration Configuration

  This file configures Git-related plugins:
  1. gitsigns.nvim: Git decorations (signs, blame, hunk operations)
  2. vim-fugitive: Full-featured Git client

  Gitsigns Features:
  - Git signs in the sign column (added/modified/removed)
  - Inline git blame
  - Hunk navigation and operations (stage, reset, preview)
  - Line-based git operations

  Fugitive Features:
  - Full Git workflow (:Git commands)
  - Merge conflict resolution
  - Git history and browsing
  - Git blame

  Keybindings (Gitsigns):
  - <leader>gB: Git blame line (inline)
  - <leader>gp: Preview hunk
  - <leader>gr: Reset hunk
  - <leader>gR: Reset buffer
  - <leader>gs: Stage hunk
  - <leader>gu: Undo stage hunk
  - <leader>gd: Diff this
  - [h: Previous hunk
  - ]h: Next hunk

  Keybindings (Fugitive):
  - <leader>gg: Git status
  - <leader>gc: Git commit
  - <leader>gp: Git push
  - <leader>gP: Git pull
  - <leader>gL: Git log
--]]

return {
  -- ============================================================================
  -- GITSIGNS: GIT DECORATIONS AND HUNK OPERATIONS
  -- ============================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- ======================================================================
      -- SIGNS CONFIGURATION
      -- ======================================================================

      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },

      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

      -- ======================================================================
      -- BLAME CONFIGURATION
      -- ======================================================================

      current_line_blame = true, -- Show blame for current line
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500,           -- Delay before showing blame (ms)
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

      -- ======================================================================
      -- DISPLAY OPTIONS
      -- ======================================================================

      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },

      attach_to_untracked = true,
      sign_priority = 6,

      update_debounce = 100,

      status_formatter = nil, -- Use default

      max_file_length = 40000, -- Disable for files longer than this

      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      -- ======================================================================
      -- KEYMAPS
      -- ======================================================================

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })

        -- Actions
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>gB", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame line" })
        map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>gD", function()
          gs.diffthis("~")
        end, { desc = "Diff this ~" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
      end,
    },
  },

  -- ============================================================================
  -- VIM-FUGITIVE: COMPREHENSIVE GIT CLIENT
  -- ============================================================================
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    keys = {
      {
        "<leader>gg",
        "<cmd>Git<cr>",
        desc = "Git Status",
      },
      {
        "<leader>gC",
        "<cmd>Git commit<cr>",
        desc = "Git Commit",
      },
      {
        "<leader>gP",
        "<cmd>Git push<cr>",
        desc = "Git Push",
      },
      {
        "<leader>gL",
        "<cmd>Git log<cr>",
        desc = "Git Log",
      },
      {
        "<leader>gl",
        "<cmd>Git pull<cr>",
        desc = "Git Pull",
      },
      {
        "<leader>gf",
        "<cmd>Git fetch<cr>",
        desc = "Git Fetch",
      },
    },
  },

  -- ============================================================================
  -- GIT-BLAME (Alternative inline blame viewer)
  -- ============================================================================
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    enabled = false, -- Disabled by default (gitsigns provides blame)
    opts = {
      enabled = true,
      message_template = " <summary> • <date> • <author>",
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 1,
    },
  },

  -- ============================================================================
  -- DIFFVIEW: ENHANCED DIFF VIEWER
  -- ============================================================================
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      {
        "<leader>gv",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diff View",
      },
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "File History",
      },
      {
        "<leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Branch History",
      },
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = true,
      use_icons = true,
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      keymaps = {
        view = {
          ["<tab>"]      = "select_next_entry",
          ["<s-tab>"]    = "select_prev_entry",
          ["gf"]         = "goto_file",
          ["<C-w><C-f>"] = "goto_file_split",
          ["<C-w>gf"]    = "goto_file_tab",
          ["<leader>e"]  = "focus_files",
          ["<leader>b"]  = "toggle_files",
        },
        file_panel = {
          ["j"]             = "next_entry",
          ["k"]             = "prev_entry",
          ["<cr>"]          = "select_entry",
          ["o"]             = "select_entry",
          ["-"]             = "toggle_stage_entry",
          ["S"]             = "stage_all",
          ["U"]             = "unstage_all",
          ["X"]             = "restore_entry",
          ["R"]             = "refresh_files",
          ["<tab>"]         = "select_next_entry",
          ["<s-tab>"]       = "select_prev_entry",
          ["gf"]            = "goto_file",
          ["<C-w><C-f>"]    = "goto_file_split",
          ["<C-w>gf"]       = "goto_file_tab",
          ["i"]             = "listing_style",
          ["f"]             = "toggle_flatten_dirs",
          ["<leader>e"]     = "focus_files",
          ["<leader>b"]     = "toggle_files",
        },
        file_history_panel = {
          ["g!"]            = "options",
          ["<C-A-d>"]       = "open_in_diffview",
          ["y"]             = "copy_hash",
          ["L"]             = "open_commit_log",
          ["zR"]            = "open_all_folds",
          ["zM"]            = "close_all_folds",
          ["j"]             = "next_entry",
          ["k"]             = "prev_entry",
          ["<cr>"]          = "select_entry",
          ["o"]             = "select_entry",
          ["<tab>"]         = "select_next_entry",
          ["<s-tab>"]       = "select_prev_entry",
          ["gf"]            = "goto_file",
          ["<C-w><C-f>"]    = "goto_file_split",
          ["<C-w>gf"]       = "goto_file_tab",
          ["<leader>e"]     = "focus_files",
          ["<leader>b"]     = "toggle_files",
        },
      },
    },
  },

  -- ============================================================================
  -- NEOGIT: MAGIT-LIKE GIT CLIENT (Optional alternative to Fugitive)
  -- ============================================================================
  {
    "NeogitOrg/neogit",
    enabled = false, -- Set to true if you prefer Neogit over Fugitive
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      {
        "<leader>gn",
        "<cmd>Neogit<cr>",
        desc = "Neogit",
      },
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
}
