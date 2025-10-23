--[[
  AI-Powered Tools Configuration

  This file sets up AI-powered coding assistants:
  1. GitHub Copilot: AI pair programmer (requires subscription)
  2. Codeium: Free AI completion alternative
  3. CodeCompanion: AI chat interface (supports OpenAI, Anthropic, Ollama)

  SETUP INSTRUCTIONS:

  GitHub Copilot:
  - Requires GitHub Copilot subscription
  - Run :Copilot auth after installation
  - Use :Copilot enable/disable to toggle

  Codeium:
  - Free alternative to Copilot
  - Run :Codeium Auth after installation
  - Get API key from https://codeium.com

  CodeCompanion:
  - Set up API keys in environment variables:
    export OPENAI_API_KEY="your-key"
    export ANTHROPIC_API_KEY="your-key"
  - Or configure in opts.adapters below
  - Can use local Ollama models (free)

  Keybindings:
  - <leader>ai: Toggle AI suggestions on/off
  - <leader>aa: Open AI chat
  - <leader>ap: Chat with selection (visual mode)
  - <leader>ac: Add code to chat buffer
  - <Tab>: Accept AI suggestion (insert mode)
--]]

return {
  -- ============================================================================
  -- GITHUB COPILOT (Paid Service)
  -- ============================================================================
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    enabled = true, -- Set to false if you only want Codeium
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end,
  },

  -- ============================================================================
  -- CODEIUM (Free Alternative to Copilot)
  -- ============================================================================
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    enabled = true, -- Set to false if you only want Copilot
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        -- Enable/disable codeium
        enable_chat = true,

        -- Virtual text configuration
        virtual_text = {
          enabled = true,
          manual = false,
          filetypes = {
            markdown = false,
            help = false,
          },
          key_bindings = {
            -- Use <Tab> for Copilot, so map Codeium to different keys
            accept = "<M-Tab>",   -- Alt+Tab to accept
            next = "<M-]>",
            prev = "<M-[>",
            clear = "<M-c>",
          },
        },
      })
    end,
  },

  -- ============================================================================
  -- CODECOMPANION: AI CHAT INTERFACE
  -- ============================================================================
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat<cr>",
        desc = "AI Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "Add to AI Chat",
        mode = "v",
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionActions<cr>",
        desc = "AI Actions",
        mode = { "n", "v" },
      },
      {
        "<leader>at",
        "<cmd>CodeCompanionToggle<cr>",
        desc = "Toggle AI Chat",
      },
    },
    config = function()
      require("codecompanion").setup({
        -- ======================================================================
        -- ADAPTERS (AI Providers)
        -- ======================================================================

        adapters = {
          -- OpenAI (ChatGPT)
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "OPENAI_API_KEY", -- Set this environment variable
              },
              schema = {
                model = {
                  default = "gpt-4o-mini",
                  -- Options: gpt-4o, gpt-4-turbo, gpt-3.5-turbo
                },
              },
            })
          end,

          -- Anthropic (Claude)
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_API_KEY", -- Set this environment variable
              },
              schema = {
                model = {
                  default = "claude-3-5-sonnet-20241022",
                  -- Options: claude-3-opus, claude-3-sonnet, claude-3-haiku
                },
              },
            })
          end,

          -- Ollama (Local/Free - requires Ollama installed)
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "llama3.2:latest",
                  -- Options: codellama, mistral, deepseek-coder, etc.
                },
              },
            })
          end,
        },

        -- ======================================================================
        -- STRATEGIES
        -- ======================================================================

        strategies = {
          chat = {
            adapter = "openai", -- Change to "openai", "anthropic", or "ollama"
            roles = {
              llm = "CodeCompanion",
              user = "You",
            },
            slash_commands = {
              ["buffer"] = {
                callback = "strategies.chat.slash_commands.buffer",
                description = "Insert open buffers",
                opts = {
                  contains_code = true,
                  provider = "telescope",
                },
              },
              ["file"] = {
                callback = "strategies.chat.slash_commands.file",
                description = "Insert a file",
                opts = {
                  contains_code = true,
                  max_lines = 1000,
                  provider = "telescope",
                },
              },
              ["help"] = {
                callback = "strategies.chat.slash_commands.help",
                description = "Insert Neovim help tags",
                opts = {
                  contains_code = false,
                  provider = "telescope",
                },
              },
              ["now"] = {
                callback = "strategies.chat.slash_commands.now",
                description = "Insert current date and time",
                opts = {
                  contains_code = false,
                },
              },
            },
          },
          inline = {
            adapter = "openai", -- Change to match your preference
          },
          agent = {
            adapter = "openai",
          },
        },

        -- ======================================================================
        -- DISPLAY SETTINGS
        -- ======================================================================

        display = {
          action_palette = {
            width = 95,
            height = 10,
          },
          chat = {
            window = {
              layout = "vertical", -- vertical|horizontal|float
              width = 0.45,        -- % of editor width
              height = 0.8,        -- % of editor height
              relative = "editor",
              opts = {
                breakindent = true,
                cursorcolumn = false,
                cursorline = false,
                foldcolumn = "0",
                linebreak = true,
                list = false,
                signcolumn = "no",
                spell = false,
                wrap = true,
              },
            },
            separator = "─", -- Character to use for separation
            show_settings = true,
            show_token_count = true,
          },
        },

        -- ======================================================================
        -- PROMPT LIBRARY
        -- ======================================================================

        prompt_library = {
          ["Code Review"] = {
            strategy = "chat",
            description = "Review the selected code",
            opts = {
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are a senior software engineer reviewing code. Provide constructive feedback.",
              },
              {
                role = "user",
                content = "Please review this code:\n\n```\n{{selection}}\n```",
              },
            },
          },
          ["Explain Code"] = {
            strategy = "chat",
            description = "Explain how the selected code works",
            opts = {
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are a helpful coding tutor. Explain code clearly and concisely.",
              },
              {
                role = "user",
                content = "Please explain this code:\n\n```\n{{selection}}\n```",
              },
            },
          },
          ["Fix Code"] = {
            strategy = "inline",
            description = "Fix bugs in the selected code",
            opts = {
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are an expert debugger. Fix any bugs and improve the code.",
              },
              {
                role = "user",
                content = "Fix this code:\n\n```\n{{selection}}\n```",
              },
            },
          },
          ["Optimize Code"] = {
            strategy = "inline",
            description = "Optimize the selected code",
            opts = {
              modes = { "v" },
            },
            prompts = {
              {
                role = "system",
                content = "You are a performance optimization expert. Improve code efficiency.",
              },
              {
                role = "user",
                content = "Optimize this code:\n\n```\n{{selection}}\n```",
              },
            },
          },
        },

        -- ======================================================================
        -- OTHER SETTINGS
        -- ======================================================================

        opts = {
          log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
          send_code = true,    -- Send code context with prompts
          use_default_actions = true,
        },
      })
    end,
  },

  -- ============================================================================
  -- AI TOGGLE KEYMAP
  -- ============================================================================

  -- Keymap to toggle between Copilot and Codeium
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>ai"] = {
          function()
            -- Toggle Copilot and Codeium
            local copilot_enabled = vim.g.copilot_enabled ~= false
            if copilot_enabled then
              vim.cmd("Copilot disable")
              vim.notify("Copilot disabled", vim.log.levels.INFO)
            else
              vim.cmd("Copilot enable")
              vim.notify("Copilot enabled", vim.log.levels.INFO)
            end
          end,
          "Toggle AI Suggestions",
        },
      },
    },
  },
}
