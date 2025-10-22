# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modern, modular Neovim configuration optimized for web development (JavaScript/TypeScript/PHP) and systems programming (Rust/Go). It uses lazy.nvim for plugin management and follows a clean separation of concerns with configuration split across multiple files.

## Architecture

### Bootstrap Flow

1. **init.lua** - Entry point that:
   - Sets leader key to `<Space>` (must be done before lazy.nvim loads)
   - Bootstraps lazy.nvim (auto-installs if missing)
   - Loads core config (`options.lua`, `keymaps.lua`)
   - Sets colorscheme to Nord
   - All plugin loading is handled automatically by lazy.nvim from `lua/plugins/*.lua`

2. **lua/config/** - Core configuration (not plugins):
   - `lazy.lua` - Plugin manager setup, auto-clones from GitHub if missing
   - `options.lua` - Vim options (UI, behavior, performance)
   - `keymaps.lua` - Global keymaps (not plugin-specific)

3. **lua/plugins/** - One file per feature area, each returns lazy.nvim plugin specs:
   - `lsp.lua` - Mason + nvim-lspconfig (tsserver, rust-analyzer, gopls, intelephense, lua_ls)
   - `completion.lua` - nvim-cmp with LSP, buffer, path, snippet sources
   - `treesitter.lua` - Syntax highlighting, text objects, rainbow delimiters
   - `telescope.lua` - Fuzzy finder with fzf-native extension
   - `neo-tree.lua` - File explorer with git integration
   - `ai.lua` - Copilot + Codeium + CodeCompanion (AI chat)
   - `dap.lua` - Debug Adapter Protocol (Go delve, Rust codelldb)
   - `git.lua` - Gitsigns + Fugitive + Diffview
   - `ui.lua` - Nord theme, Lualine, Noice, Bufferline (tab bar), Notify
   - `editor.lua` - Comment, autopairs, which-key, surround, todo-comments, Trouble

### Plugin Loading Strategy

- **Lazy loading** is used extensively via `event`, `cmd`, `keys`, `ft` triggers
- **Dependencies** are explicitly declared to ensure correct load order
- **Keys** tables define keymaps that also trigger plugin loading
- All plugins auto-install on first launch via lazy.nvim

### Configuration Patterns

When modifying this config, follow these patterns:

1. **LSP Servers** (`lua/plugins/lsp.lua`):
   - Add to `ensure_installed` list in mason-lspconfig
   - Add custom settings in the "CUSTOM LSP SERVER CONFIGURATIONS" section
   - Use `on_attach` for keymaps, `capabilities` for completion

2. **Keymaps**:
   - Global keymaps → `lua/config/keymaps.lua`
   - Plugin-specific keymaps → `keys` table in plugin spec
   - Which-key groups → `wk.add()` in `lua/plugins/editor.lua`

3. **Treesitter Parsers** (`lua/plugins/treesitter.lua`):
   - Add to `ensure_installed` list
   - Note: JSX is handled by `javascript` parser, not separate `jsx` parser

4. **Options**:
   - Buffer-local options (like `fileencoding`) cannot be set globally
   - Use `vim.opt` for global options, `vim.bo` for buffer-local

## Common Commands

### Plugin Management
```vim
:Lazy                    " Open plugin manager UI
:Lazy sync               " Install/update/clean plugins
:Lazy profile            " Check startup performance
:Mason                   " Manage LSP servers/formatters/linters
:MasonUpdate            " Update Mason registry
```

### LSP & Diagnostics
```vim
:LspInfo                " Show active LSP clients
:LspRestart             " Restart LSP for current buffer
:checkhealth            " Comprehensive health check
:checkhealth vim.lsp    " LSP-specific health check
```

### Treesitter
```vim
:TSUpdate               " Update all parsers
:TSInstall <lang>       " Install specific parser
:TSUpdateSync           " Synchronous update (blocks UI)
```

### AI Tools Setup
```vim
:Copilot auth           " Authenticate GitHub Copilot
:Codeium Auth           " Authenticate Codeium (free)
```

### Debugging (DAP)
```vim
:DapContinue            " Start/continue debugging
:DapToggleBreakpoint    " Toggle breakpoint
:DapTerminate           " Stop debugging
```

### Git
```vim
:Git                    " Fugitive status (like git status)
:Gitsigns toggle_signs  " Toggle git signs
:DiffviewOpen           " Open diff view
```

## Key Concepts

### Leader Key Pattern
- Leader is `<Space>` (set in init.lua before plugins load)
- All major features use `<leader>` prefix for discoverability
- Press `<leader>` and wait 300ms to see available commands via which-key

### Keymap Discovery
Users can find keymaps 3 ways:
1. Press `?` → Shows all keymaps via which-key
2. Press `<leader>fk` → Searchable keymap list in Telescope
3. Press `<leader>` and wait → Auto-shows which-key popup

### Tab vs Buffers
- **Bufferline** shows buffer tabs at top (like VSCode)
- `Tab` key cycles through buffers (not completion when in normal mode)
- `<leader>e` toggles Neo-tree file explorer (not just reveal)

### AI Tool Keybindings
- Copilot uses `<Tab>` to accept (conflicts handled in completion.lua)
- Codeium uses `<Alt-Tab>` to accept
- Both can be disabled by setting `enabled = false` in ai.lua

## Known Issues & Solutions

### E21 Error (Cannot make changes, 'modifiable' is off)
- Caused by setting buffer-local options globally (e.g., `fileencoding`)
- Solution: Comment out or remove the option, Neovim auto-detects it

### LSP Deprecation Warning
- `require('lspconfig')` pattern deprecated in nvim-lspconfig v3.0
- Current code works; migration to `vim.lsp.config` needed when v3.0 releases
- See comment in lsp.lua for migration reference

### JSX Parser Not Found
- There is no separate `jsx` parser in Treesitter
- JSX is handled by `javascript` and `tsx` parsers
- Do not add `jsx` to ensure_installed list

### Which-key Spec Warnings
- Use new `wk.add()` format instead of `wk.register()`
- Use `win` instead of `window` for configuration
- See lua/plugins/editor.lua for correct pattern

## Development Workflow

### Adding New LSP
1. Add server name to `ensure_installed` in lua/plugins/lsp.lua
2. Restart Neovim or run `:Mason` to install
3. Add custom settings if needed (see existing examples)
4. LSP will auto-start for matching filetypes

### Modifying Keymaps
1. Check if it's global (lua/config/keymaps.lua) or plugin-specific
2. For plugin keymaps, add to `keys` table in plugin spec
3. Update which-key groups if adding new `<leader>` prefix
4. Test with `?` or `<leader>fk` to verify discoverability

### Debugging Config Issues
1. Run `:checkhealth` for comprehensive diagnostics
2. Check `:Lazy` for plugin status
3. Check `:LspInfo` for LSP issues
4. Check `:messages` for error messages
5. Enable lazy.nvim profiling: `:Lazy profile`

### Performance Optimization
- Use `event`, `cmd`, `keys`, `ft` for lazy loading
- Check startup time with: `nvim --startuptime startup.log`
- Expected startup: 50-80ms with lazy loading
- Disable unused plugins by setting `enabled = false`

## File Encoding
- Neovim auto-detects file encoding (UTF-8, Latin1, etc.)
- Do not set `fileencoding` globally in options.lua
- Use `:set fileencoding=utf-8` per-buffer if needed

## External Dependencies
- **Required**: Neovim ≥0.9.0, Git, Node.js ≥18, ripgrep
- **Recommended**: fd (faster file search), make (fzf-native), Fira Code iScript font
- **Language-specific**: Go (gopls, delve), Rust (rust-analyzer, codelldb), PHP (intelephense)
- All LSP servers auto-install via Mason; external language runtimes needed for debugging
