--[[
  Editor Utilities Configuration

  This file sets up essential editing enhancements:
  1. Comment.nvim: Smart commenting
  2. nvim-autopairs: Automatic bracket/quote pairing
  3. which-key.nvim: Keymap helper and documentation
  4. nvim-surround: Surround text with quotes/brackets/tags
  5. vim-sleuth: Auto-detect indentation
  6. nvim-ts-autotag: Auto-close/rename HTML tags

  These plugins enhance the editing experience with minimal configuration.
--]]

return {
  -- ============================================================================
  -- COMMENT.NVIM: SMART COMMENTING
  -- ============================================================================
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring", -- Context-aware comments
    },
    opts = function()
      return {
        -- Add a space between comment and line
        padding = true,

        -- Ignore empty lines
        ignore = "^$",

        -- Keybindings (in NORMAL mode)
        toggler = {
          line = "gcc",  -- Line-comment toggle
          block = "gbc", -- Block-comment toggle
        },

        -- Keybindings (in VISUAL mode)
        opleader = {
          line = "gc",  -- Line-comment operator
          block = "gb", -- Block-comment operator
        },

        -- Extra keybindings
        extra = {
          above = "gcO", -- Add comment on line above
          below = "gco", -- Add comment on line below
          eol = "gcA",   -- Add comment at end of line
        },

        -- Enable treesitter integration for context-aware commenting
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  -- ============================================================================
  -- NVIM-AUTOPAIRS: AUTOMATIC BRACKET/QUOTE PAIRING
  -- ============================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      autopairs.setup({
        check_ts = true, -- Enable treesitter
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false, -- Don't use treesitter for Java
        },

        -- Disable for certain filetypes
        disable_filetype = { "TelescopePrompt", "vim" },

        -- Don't add pairs if next char is alphanumeric
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,

        -- Fast wrap feature
        fast_wrap = {
          map = "<M-e>", -- Alt+e to wrap
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },

        -- Map <CR> to confirm completion
        map_cr = true,
        map_bs = true,   -- Map backspace to delete pairs
        map_c_h = false, -- Map <C-h> to delete pairs
        map_c_w = false, -- Map <C-w> to delete pairs
      })

      -- Integration with nvim-cmp
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ============================================================================
  -- WHICH-KEY: KEYMAP HELPER
  -- ============================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register group names for better organization (new spec format)
      wk.add({
        -- Prefix groups
        { "g", group = "goto", mode = { "n", "v" } },
        { "]", group = "next", mode = { "n", "v" } },
        { "[", group = "prev", mode = { "n", "v" } },

        -- Leader key groups
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>h", group = "help" },
        { "<leader>s", group = "search" },
        { "<leader>sn", group = "noice" },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>a", group = "ai" },
        { "<leader><tab>", group = "tabs" },
      })
    end,
  },

  -- ============================================================================
  -- NVIM-SURROUND: SURROUND TEXT WITH QUOTES/BRACKETS/TAGS
  -- ============================================================================
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      -- Configuration here, or leave empty to use defaults
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },

  -- ============================================================================
  -- VIM-SLEUTH: AUTO-DETECT INDENTATION
  -- ============================================================================
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- ============================================================================
  -- NVIM-TS-AUTOTAG: AUTO-CLOSE/RENAME HTML TAGS
  -- ============================================================================
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      opts = {
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      per_filetype = {
        ["html"] = {
          enable_close = true,
        },
      },
    },
  },

  -- ============================================================================
  -- MINI.AI: ENHANCED TEXT OBJECTS
  -- ============================================================================
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    enabled = false, -- Set to true if you want mini.ai (alternative to treesitter textobjects)
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  -- ============================================================================
  -- NVIM-COLORIZER: COLOR HIGHLIGHTER
  -- ============================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = {
        "*", -- Enable for all filetypes
        css = { css = true },
        scss = { css = true },
      },
      user_default_options = {
        RGB = true,       -- #RGB hex codes
        RRGGBB = true,    -- #RRGGBB hex codes
        names = false,    -- "Name" codes like Blue
        RRGGBBAA = true,  -- #RRGGBBAA hex codes
        rgb_fn = true,    -- CSS rgb() and rgba() functions
        hsl_fn = true,    -- CSS hsl() and hsla() functions
        css = false,      -- Enable all CSS features
        css_fn = false,   -- Enable all CSS *functions*
        mode = "background", -- Set the display mode (foreground/background)
      },
    },
  },

  -- ============================================================================
  -- TODO-COMMENTS: HIGHLIGHT TODO/FIXME/NOTE COMMENTS
  -- ============================================================================
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      {
        "<leader>ft",
        "<cmd>TodoTelescope<cr>",
        desc = "Find Todos",
      },
    },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },

  -- ============================================================================
  -- TROUBLE: DIAGNOSTICS & QUICKFIX LIST
  -- ============================================================================
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {
      use_diagnostic_signs = true,
    },
  },
}
