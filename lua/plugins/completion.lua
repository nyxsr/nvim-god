--[[
  Code Completion Configuration

  This file sets up nvim-cmp, a powerful completion engine for Neovim.
  Completion sources include:
  - LSP (language server)
  - Buffer (words from current and other buffers)
  - Path (filesystem paths)
  - Snippets (via luasnip)

  Keybindings:
  - <C-n>/<C-p>: Navigate completion menu
  - <C-Space>: Trigger completion
  - <CR>: Confirm selection
  - <Tab>/<S-Tab>: Navigate and expand snippets
  - <C-b>/<C-f>: Scroll documentation
--]]

return {
  -- ============================================================================
  -- NVIM-CMP: COMPLETION ENGINE
  -- ============================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet engine (required for nvim-cmp to work)
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Completion sources
      "hrsh7th/cmp-nvim-lsp",     -- LSP completion
      "hrsh7th/cmp-buffer",       -- Buffer words
      "hrsh7th/cmp-path",         -- Filesystem paths
      "hrsh7th/cmp-cmdline",      -- Command-line completion

      -- Snippet collection (optional but recommended)
      "rafamadriz/friendly-snippets",

      -- Icons for completion menu
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- ======================================================================
      -- HELPER FUNCTIONS
      -- ======================================================================

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- ======================================================================
      -- NVIM-CMP SETUP
      -- ======================================================================

      cmp.setup({
        -- Snippet engine configuration
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Window appearance
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
        },

        -- Formatting (icons and source labels)
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- Show icon and text
            maxwidth = 50,        -- Prevent popup from being too wide
            ellipsis_char = "...", -- Truncation indicator
            show_labelDetails = true,

            -- Customize source labels
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
              cmdline = "[Cmd]",
            },

            -- Custom icons for specific items (optional)
            before = function(entry, vim_item)
              return vim_item
            end,
          }),
        },

        -- Keybindings
        mapping = cmp.mapping.preset.insert({
          -- Navigate completion menu
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

          -- Scroll documentation window
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Trigger completion
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Close completion menu
          ["<C-e>"] = cmp.mapping.abort(),

          -- Confirm selection
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),

          -- Tab/Shift-Tab: Navigate and expand snippets
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Completion sources (order matters - higher priority first)
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),

        -- Experimental features
        experimental = {
          ghost_text = {
            hl_group = "Comment", -- Show ghost text as comment
          },
        },
      })

      -- ======================================================================
      -- COMMAND-LINE COMPLETION
      -- ======================================================================

      -- `/` and `?` search completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` command-line completion
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" }, -- Ignore these commands
            },
          },
        }),
      })

      -- ======================================================================
      -- LUASNIP CONFIGURATION
      -- ======================================================================

      luasnip.config.set_config({
        history = true,              -- Keep last snippet local to cursor
        updateevents = "TextChanged,TextChangedI", -- Update snippets as you type
        enable_autosnippets = true,  -- Enable auto-triggered snippets
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = { { "●", "GruvboxOrange" } },
            },
          },
        },
      })

      -- ======================================================================
      -- CUSTOM SNIPPETS (Optional)
      -- ======================================================================

      -- You can add custom snippets here
      -- Example:
      -- local s = luasnip.snippet
      -- local t = luasnip.text_node
      -- local i = luasnip.insert_node
      --
      -- luasnip.add_snippets("lua", {
      --   s("req", {
      --     t('local '),
      --     i(1, "module"),
      --     t(' = require("'),
      --     i(2, "module"),
      --     t('")'),
      --   }),
      -- })
    end,
  },

  -- ============================================================================
  -- LUASNIP: SNIPPET ENGINE
  -- ============================================================================
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp", -- Optional: for advanced regex support
    dependencies = {
      "rafamadriz/friendly-snippets", -- Snippet collection
    },
  },
}
