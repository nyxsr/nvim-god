--[[
  Neo-tree File Explorer Configuration

  Neo-tree is a modern file explorer with Git integration, file operations,
  and a clean UI. It's more feature-rich and performant than nvim-tree.

  Keybindings:
  - <leader>e: Toggle file explorer
  - <leader>E: Toggle file explorer (current file focused)

  In Neo-tree:
  - <CR>: Open file/folder
  - <Tab>: Preview file
  - a: Add file/directory
  - d: Delete
  - r: Rename
  - x: Cut
  - c: Copy
  - p: Paste
  - R: Refresh
  - H: Toggle hidden files
  - /: Fuzzy search
  - ?: Show help
--]]

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle<cr>",
        desc = "Toggle File Explorer",
      },
      {
        "<leader>E",
        "<cmd>Neotree reveal<cr>",
        desc = "Reveal File in Explorer",
      },
      {
        "<leader>be",
        "<cmd>Neotree buffers<cr>",
        desc = "Buffer Explorer",
      },
      {
        "<leader>ge",
        "<cmd>Neotree git_status<cr>",
        desc = "Git Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- Auto-open neo-tree when opening a directory
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      -- ======================================================================
      -- GENERAL SETTINGS
      -- ======================================================================

      close_if_last_window = true, -- Close Neo-tree if it's the last window
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      -- ======================================================================
      -- DEFAULT COMPONENT CONFIGS
      -- ======================================================================

      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },

      -- ======================================================================
      -- WINDOW SETTINGS
      -- ======================================================================

      window = {
        position = "left",
        width = 35,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          -- Navigation
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["<tab>"] = "toggle_preview",
          ["l"] = "open",
          ["h"] = "close_node",

          -- File operations
          ["a"] = {
            "add",
            config = {
              show_path = "relative", -- "none", "relative", "absolute"
            },
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- Takes path, then paste to destination
          ["m"] = "move", -- Takes path, then paste to destination

          -- View options
          ["H"] = "toggle_hidden",
          ["."] = "set_root",
          ["R"] = "refresh",
          ["/"] = "fuzzy_finder",
          ["f"] = "filter_on_submit",
          ["<C-x>"] = "clear_filter",

          -- Split/vsplit
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",

          -- Other
          ["?"] = "show_help",
          ["q"] = "close_window",
        },
      },

      -- ======================================================================
      -- FILESYSTEM SOURCE
      -- ======================================================================

      filesystem = {
        filtered_items = {
          visible = false, -- Show hidden files (toggle with "H")
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".git",
            ".DS_Store",
          },
          hide_by_pattern = {
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = {
            ".gitignore",
            ".env",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = {
          enabled = true,         -- Find and focus the current file
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        use_libuv_file_watcher = true,         -- Auto-refresh on file changes (Linux/macOS)
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            -- ["gf"] = "find_in_dir",  -- Disabled: Invalid mapping in neo-tree v3.x
            ["ge"] = "fuzzy_finder_directory",
            ["f"] = "filter_on_submit",
            ["<C-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
        commands = {},
      },

      -- ======================================================================
      -- BUFFERS SOURCE
      -- ======================================================================

      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
          },
        },
      },

      -- ======================================================================
      -- GIT STATUS SOURCE
      -- ======================================================================

      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"]  = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },

      -- ======================================================================
      -- EVENT HANDLERS
      -- ======================================================================

      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            -- Auto-close neo-tree when opening a file
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd("highlight! Cursor blend=100")
          end,
        },
        {
          event = "neo_tree_buffer_leave",
          handler = function()
            vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
          end,
        },
      },
    },
  },
}
