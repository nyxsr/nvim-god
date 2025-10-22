--[[
  Telescope Fuzzy Finder Configuration

  Telescope is a powerful fuzzy finder for files, buffers, grep results,
  LSP symbols, and more. It's highly extensible and performant.

  Keybindings:
  - <leader>ff: Find files
  - <leader>fg: Live grep (search in files)
  - <leader>fb: Find buffers
  - <leader>fh: Find help tags
  - <leader>fr: Recent files
  - <leader>fw: Find word under cursor
  - <leader>fc: Find commands
  - <leader>fk: Find keymaps

  In Telescope:
  - <C-n>/<C-p>: Navigate results
  - <C-u>/<C-d>: Scroll preview
  - <C-q>: Send to quickfix list
  - <Tab>/<S-Tab>: Toggle selection
--]]

return {
  -- ============================================================================
  -- TELESCOPE: FUZZY FINDER
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- Use latest commit
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",

      -- FZF native extension for better performance
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      -- File pickers
      {
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files",
      },
      {
        "<leader>fr",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Recent Files",
      },
      {
        "<leader>fb",
        "<cmd>Telescope buffers<cr>",
        desc = "Find Buffers",
      },

      -- Search pickers
      {
        "<leader>fg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Live Grep",
      },
      {
        "<leader>fw",
        "<cmd>Telescope grep_string<cr>",
        desc = "Find Word Under Cursor",
      },

      -- Vim pickers
      {
        "<leader>fh",
        "<cmd>Telescope help_tags<cr>",
        desc = "Help Tags",
      },
      {
        "<leader>fc",
        "<cmd>Telescope commands<cr>",
        desc = "Commands",
      },
      {
        "<leader>fk",
        "<cmd>Telescope keymaps<cr>",
        desc = "Keymaps",
      },

      -- LSP pickers
      {
        "<leader>fs",
        "<cmd>Telescope lsp_document_symbols<cr>",
        desc = "Document Symbols",
      },
      {
        "<leader>fS",
        "<cmd>Telescope lsp_workspace_symbols<cr>",
        desc = "Workspace Symbols",
      },

      -- Git pickers
      {
        "<leader>gc",
        "<cmd>Telescope git_commits<cr>",
        desc = "Git Commits",
      },
      {
        "<leader>gs",
        "<cmd>Telescope git_status<cr>",
        desc = "Git Status",
      },
      {
        "<leader>gb",
        "<cmd>Telescope git_branches<cr>",
        desc = "Git Branches",
      },

      -- Diagnostics
      {
        "<leader>fd",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Diagnostics",
      },

      -- Resume last picker
      {
        "<leader>f<cr>",
        "<cmd>Telescope resume<cr>",
        desc = "Resume Last Telescope",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        -- ======================================================================
        -- DEFAULT CONFIGURATION
        -- ======================================================================
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },

          -- Sorting strategy
          sorting_strategy = "ascending",

          -- Layout configuration
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- Mappings
          mappings = {
            i = {
              -- Navigation
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- Scroll preview
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              -- Close telescope
              ["<C-c>"] = actions.close,
              ["<Esc>"] = actions.close,

              -- Send to quickfix
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              -- Toggle selection
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

              -- Cycle through history
              ["<Down>"] = actions.cycle_history_next,
              ["<Up>"] = actions.cycle_history_prev,
            },
            n = {
              -- Navigation
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- Scroll preview
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              -- Close telescope
              ["<Esc>"] = actions.close,
              ["q"] = actions.close,

              -- Send to quickfix
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              -- Toggle selection
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            },
          },

          -- File ignoring
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "target/",
            "vendor/",
            "%.lock",
          },

          -- Preview settings
          preview = {
            treesitter = true, -- Enable treesitter highlighting in preview
          },

          -- Performance
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",             -- Search hidden files
            "--glob=!.git/",        -- Exclude .git directory
          },
        },

        -- ======================================================================
        -- PICKER-SPECIFIC CONFIGURATION
        -- ======================================================================
        pickers = {
          find_files = {
            -- Use fd if available (faster than find)
            find_command = vim.fn.executable("fd") == 1
                and { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
                or nil,
            hidden = true, -- Show hidden files
          },

          buffers = {
            sort_mru = true,          -- Sort by most recently used
            ignore_current_buffer = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer, -- Delete buffer
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },

          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },

          git_files = {
            show_untracked = true,
          },
        },

        -- ======================================================================
        -- EXTENSIONS
        -- ======================================================================
        extensions = {
          fzf = {
            fuzzy = true,                   -- Enable fuzzy matching
            override_generic_sorter = true, -- Override generic sorter
            override_file_sorter = true,    -- Override file sorter
            case_mode = "smart_case",       -- Smart case matching
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ============================================================================
  -- TELESCOPE FZF NATIVE (Performance Extension)
  -- ============================================================================
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
