--[[
  Treesitter Configuration

  nvim-treesitter provides advanced syntax highlighting, code folding,
  incremental selection, and more. It parses code into syntax trees,
  enabling better understanding of code structure.

  Features enabled:
  - Syntax highlighting
  - Incremental selection
  - Indentation
  - Rainbow parentheses (via rainbow-delimiters)
  - Context-aware comments (via ts-context-commentstring)

  Auto-installed parsers:
  JavaScript, TypeScript, JSX/TSX, Lua, Rust, Go, PHP, Python,
  HTML, CSS, JSON, YAML, Markdown, Bash, and more.
--]]

return {
  -- ============================================================================
  -- NVIM-TREESITTER: SYNTAX PARSING & HIGHLIGHTING
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Use latest commit instead of tagged releases
    build = ":TSUpdate", -- Run :TSUpdate after installation
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Advanced text objects
      "HiPhish/rainbow-delimiters.nvim",             -- Rainbow parentheses
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    opts = {
      -- ======================================================================
      -- PARSER INSTALLATION
      -- ======================================================================

      -- List of parsers to always install
      ensure_installed = {
        -- Web development
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        -- Note: JSX is handled by 'javascript' parser, not a separate 'jsx' parser
        "json",
        "jsonc",

        -- Systems programming
        "rust",
        "go",
        "c",
        "cpp",

        -- Backend
        "php",
        "python",

        -- Scripting & config
        "lua",
        "vim",
        "vimdoc",
        "bash",

        -- Markup & data
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",

        -- Git
        "gitignore",
        "git_config",
        "git_rebase",
        "gitcommit",

        -- Query language for Treesitter itself
        "query",

        -- Other useful parsers
        "regex",
        "dockerfile",
        "sql",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      -- Ignore these parsers
      ignore_install = {},

      -- ======================================================================
      -- SYNTAX HIGHLIGHTING
      -- ======================================================================

      highlight = {
        enable = true, -- Enable Treesitter-based highlighting

        -- Disable for large files (size in bytes)
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Use traditional syntax highlighting for these languages
        -- disable = { "c", "rust" },

        -- Enable vim regex highlighting in addition to Treesitter
        additional_vim_regex_highlighting = false,
      },

      -- ======================================================================
      -- INDENTATION
      -- ======================================================================

      indent = {
        enable = true,
        -- Disable for these languages if causing issues
        disable = {},
      },

      -- ======================================================================
      -- INCREMENTAL SELECTION
      -- ======================================================================

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",    -- Start selection
          node_incremental = "<C-space>",  -- Expand selection
          scope_incremental = false,       -- Disabled
          node_decremental = "<bs>",       -- Shrink selection
        },
      },

      -- ======================================================================
      -- TEXT OBJECTS
      -- ======================================================================

      textobjects = {
        -- Syntax-aware text objects (select functions, classes, etc.)
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to matching text object

          keymaps = {
            -- Function text objects
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            -- Class text objects
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",

            -- Parameter/argument text objects
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",

            -- Block text objects
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",

            -- Conditional text objects
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",

            -- Loop text objects
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },

        -- Move to next/previous function, class, etc.
        move = {
          enable = true,
          set_jumps = true, -- Add to jumplist

          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },

          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },

          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },

          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },

        -- Swap parameters/arguments
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- ======================================================================
      -- RAINBOW DELIMITERS
      -- ======================================================================

      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}
