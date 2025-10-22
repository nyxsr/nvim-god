--[[
  LSP Configuration

  This file sets up Language Server Protocol (LSP) support via:
  - mason.nvim: Automatic installation of LSP servers, formatters, linters
  - nvim-lspconfig: Configuration for individual LSP servers
  - mason-lspconfig: Bridge between Mason and lspconfig

  Preconfigured LSPs:
  - JavaScript/TypeScript: tsserver
  - PHP: intelephense
  - Rust: rust-analyzer
  - Go: gopls
  - Lua: lua_ls

  To add more LSPs, see the ADDING NEW LSP SERVERS section below.
--]]

return {
  -- ============================================================================
  -- MASON: LSP/FORMATTER/LINTER INSTALLER
  -- ============================================================================
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ============================================================================
  -- LSP CONFIGURATION
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source for nvim-cmp
    },
    config = function()
      -- NOTE: Using require("lspconfig") pattern which works with nvim-lspconfig v2.x
      -- This will be deprecated in v3.0.0 in favor of vim.lsp.config
      -- See: :help lspconfig-nvim-0.11 for migration guide when v3.0.0 is released
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- ======================================================================
      -- DIAGNOSTICS CONFIGURATION
      -- ======================================================================

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●", -- Could be '■', '▎', 'x'
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always", -- Show source of diagnostic
          header = "",
          prefix = "",
        },
      })

      -- ======================================================================
      -- LSP KEYMAPS (Applied when LSP attaches to buffer)
      -- ======================================================================

      local on_attach = function(client, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gr", vim.lsp.buf.references, "Show references")
        map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

        -- Documentation
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Code actions
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")

        -- Formatting
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")

        -- Workspace
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")

        -- Diagnostics (also defined in keymaps.lua, repeated here for completeness)
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        map("n", "<leader>xx", vim.diagnostic.setloclist, "Diagnostic list")

        -- Highlight references under cursor
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- ======================================================================
      -- LSP CAPABILITIES (Enhanced with nvim-cmp)
      -- ======================================================================

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

      -- Enable snippet support
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- ======================================================================
      -- MASON-LSPCONFIG: AUTOMATIC LSP INSTALLATION
      -- ======================================================================

      mason_lspconfig.setup({
        -- List of LSP servers to automatically install
        ensure_installed = {
          "ts_ls",       -- JavaScript/TypeScript (replaces tsserver)
          "intelephense",   -- PHP
          "rust_analyzer",  -- Rust
          "gopls",          -- Go
          "lua_ls",         -- Lua
        },
        -- Automatically install servers configured in lspconfig
        automatic_installation = true,
      })

      -- ======================================================================
      -- DEFAULT LSP SERVER SETUP
      -- ======================================================================

      -- Default configuration for all servers
      local default_setup = function(server)
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- ======================================================================
      -- CUSTOM LSP SERVER CONFIGURATIONS
      -- ======================================================================

      -- Lua Language Server (special config for Neovim development)
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT", -- Neovim uses LuaJIT
            },
            diagnostics = {
              globals = { "vim" }, -- Recognize 'vim' global
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- Make LSP aware of Neovim runtime
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
          },
        },
      })

      -- TypeScript/JavaScript Language Server
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Rust Analyzer
      lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy", -- Use clippy for linting
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      })

      -- Go Language Server
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      -- PHP Language Server (Intelephense)
      lspconfig.intelephense.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
          },
        },
      })

      -- ======================================================================
      -- ADDING NEW LSP SERVERS
      -- ======================================================================
      --[[
        To add a new LSP server:

        1. Add the server name to mason-lspconfig's ensure_installed list above
        2. Restart Neovim (or run :MasonInstall <server_name>)
        3. Add custom configuration below if needed, or it will use default_setup

        Example: Adding Python support (pyright)

        -- In ensure_installed:
        ensure_installed = {
          "ts_ls",
          "intelephense",
          "rust_analyzer",
          "gopls",
          "lua_ls",
          "pyright", -- Add this
        },

        -- Custom config (optional):
        lspconfig.pyright.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        })

        Find more servers at: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      --]]
    end,
  },

  -- ============================================================================
  -- MASON-LSPCONFIG: BRIDGE BETWEEN MASON AND LSPCONFIG
  -- ============================================================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
