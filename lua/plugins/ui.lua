--[[
  UI & Theme Configuration

  This file configures the visual appearance of Neovim:
  1. Nord colorscheme
  2. Lualine status line
  3. Indent-blankline (indent guides)
  4. Noice (enhanced UI for messages, cmdline, popupmenu)
  5. Notify (notification manager)
  6. Dressing (better UI for inputs/selects)

  The Nord theme provides a beautiful arctic-inspired color palette
  that works well with Fira Code iScript font.
--]]

return {
  -- ============================================================================
  -- NORD COLORSCHEME
  -- ============================================================================
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000, -- Load before other plugins
    config = function()
      -- Nord configuration
      vim.g.nord_contrast = true           -- Better contrast
      vim.g.nord_borders = false           -- No borders for floating windows
      vim.g.nord_disable_background = false -- Use Nord background
      vim.g.nord_italic = true             -- Enable italics (works well with Fira Code iScript)
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false

      -- Load the colorscheme (also set in init.lua)
      -- vim.cmd.colorscheme("nord")
    end,
  },

  -- ============================================================================
  -- LUALINE: STATUS LINE
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      return {
        options = {
          theme = "nord",
          globalstatus = true, -- Single statusline for all windows
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
          },
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = icons.git,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = icons.diagnostics,
            },
            {
              "filename",
              path = 1, -- 0: Just filename, 1: Relative path, 2: Absolute path
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              },
            },
          },
          lualine_x = {
            {
              function()
                local ok, copilot = pcall(require, "copilot.api")
                if ok and copilot.status.data.status == "Normal" then
                  return " "
                end
                return ""
              end,
              cond = function()
                local ok, _ = pcall(require, "copilot.api")
                return ok
              end,
            },
            {
              function()
                return "󱃖 "
              end,
              cond = function()
                local ok, _ = pcall(require, "codeium")
                return ok
              end,
            },
            "encoding",
            {
              "fileformat",
              symbols = {
                unix = "", --
                dos = "", --
                mac = "", --
              },
            },
            "filetype",
          },
          lualine_y = {
            "progress",
          },
          lualine_z = {
            "location",
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {
          "neo-tree",
          "lazy",
          "mason",
          "fugitive",
        },
      }
    end,
  },

  -- ============================================================================
  -- INDENT-BLANKLINE: INDENT GUIDES
  -- ============================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = true,
        highlight = { "Function", "Label" },
        priority = 500,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- ============================================================================
  -- NOICE: ENHANCED UI FOR MESSAGES, CMDLINE, POPUPMENU
  -- ============================================================================
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true, -- Set to false if you prefer the classic UI
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        -- Skip noice.nvim lazyredraw warning
        {
          filter = {
            event = "notify",
            find = "lazyredraw",
          },
          opts = { skip = true },
        },
        -- Skip LSP deprecation warnings
        {
          filter = {
            event = "notify",
            kind = "warn",
            any = {
              { find = "lspconfig" },
              { find = "deprecated" },
            },
          },
          opts = { skip = true },
        },
        -- Skip Neo-tree warnings
        {
          filter = {
            event = "notify",
            kind = "warn",
            find = "Neo%-tree",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,         -- Use classic bottom search
        command_palette = true,       -- Position cmdline and popupmenu together
        long_message_to_split = true, -- Long messages sent to split
        inc_rename = false,           -- Enables input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- Add border to hover/signature help
      },
    },
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
  },

  -- ============================================================================
  -- NVIM-NOTIFY: NOTIFICATION MANAGER
  -- ============================================================================
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      -- Use nvim-notify as default notification handler
      vim.notify = require("notify")
    end,
  },

  -- ============================================================================
  -- DRESSING: BETTER UI FOR VIM.UI.SELECT AND VIM.UI.INPUT
  -- ============================================================================
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        win_options = {
          winblend = 0,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        telescope = require("telescope.themes").get_dropdown(),
      },
    },
  },

  -- ============================================================================
  -- BUFFERLINE: BUFFER TABS (Modern IDE Style)
  -- ============================================================================
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    enabled = true, -- Visual tab bar at the top
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      -- Navigate between tabs
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer tab", mode = "n" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer tab", mode = "n" },

      -- Jump to specific buffer by number
      { "<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
      { "<C-6>", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
      { "<C-7>", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
      { "<C-8>", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
      { "<C-9>", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
      { "<C-0>", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "Go to last buffer" },

      -- Move buffers
      { "<A-<>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "<A->>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },

      -- Close buffers
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer to switch" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant", -- "slant" | "slope" | "thick" | "thin"
        always_show_bufferline = true, -- Always show tab bar
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,

        -- Show LSP diagnostics in tabs
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,

        -- Mouse support
        left_mouse_command = "buffer %d", -- Left click to switch
        right_mouse_command = "bdelete! %d", -- Right click to close
        middle_mouse_command = nil,

        -- Custom filter (hide certain filetypes)
        custom_filter = function(buf_number)
          -- Don't show certain filetypes in tabs
          local filetype = vim.bo[buf_number].filetype
          if filetype == "qf" or filetype == "help" then
            return false
          end
          return true
        end,

        -- Offset for file explorer
        offsets = {
          {
            filetype = "neo-tree",
            text = "📁 File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },

        -- Styling
        indicator = {
          style = "underline", -- "icon" | "underline" | "none"
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
      },
    },
  },

  -- ============================================================================
  -- DASHBOARD / ALPHA (Optional startup screen)
  -- ============================================================================
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = false, -- Set to true if you want a startup dashboard
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                     ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        [[                                                     ]],
        [[                  [ GOD MODE ]                      ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },
}
