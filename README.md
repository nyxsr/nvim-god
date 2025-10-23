# Neovim GOD Configuration

A complete, modern Neovim configuration optimized for web development (JavaScript/TypeScript/PHP) and systems programming (Rust/Go). Features LSP, AI-powered coding assistants, debugging, and a beautiful **Nord theme** with **Fira Code iScript** font.

**✨ Highlights**: Visual tab bar (like VSCode), instant keymap discovery (`?`), AI chat integration, DAP debugging, and blazing-fast startup (~50-80ms).

```
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗     ██████╗  ██████╗ ██████╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║    ██╔════╝ ██╔═══██╗██╔══██╗
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    ██║  ███╗██║   ██║██║  ██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    ██║   ██║██║   ██║██║  ██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║    ╚██████╔╝╚██████╔╝██████╔╝
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝     ╚═════╝  ╚═════╝ ╚═════╝
```

## Features

### Core Development Tools
- **LSP Support**: Automatic language server installation (JavaScript, TypeScript, PHP, Rust, Go, Lua)
- **Code Completion**: Intelligent completion with nvim-cmp + LSP + snippets
- **Syntax Highlighting**: Advanced parsing with Treesitter
- **Fuzzy Finding**: Blazing fast search with Telescope
- **File Explorer**: Modern file tree with Neo-tree

### AI-Powered Coding
- **GitHub Copilot**: AI pair programmer (requires subscription)
- **Codeium**: Free AI completion alternative
- **CodeCompanion**: AI chat interface (supports OpenAI, Anthropic, Ollama)

### Debugging & Testing
- **DAP Integration**: Debug Go and Rust applications
- **Breakpoints**: Visual debugger with UI
- **REPL**: Interactive debugging console

### Git Integration
- **Gitsigns**: Inline git blame, hunk operations
- **Fugitive**: Full Git workflow
- **Diffview**: Enhanced diff viewing

### UI & Theme
- **Nord Theme**: Beautiful arctic-inspired colors
- **Lualine**: Informative status line
- **Bufferline**: Visual tab bar showing all open files (like VSCode)
- **Which-key**: Interactive keymap guide with instant help
- **Noice**: Enhanced UI for messages and cmdline

### Editor Enhancements
- **Smart Comments**: Context-aware commenting
- **Auto-pairs**: Automatic bracket/quote pairing
- **Surround**: Easily surround text with quotes/brackets
- **Todo Comments**: Highlight TODO/FIXME/NOTE
- **Color Preview**: See colors inline

## Prerequisites

### Required
- **Neovim** >= 0.9.0
- **Git**
- **Node.js** >= 18 (for LSP servers)
- **ripgrep** (for Telescope live grep)

### Recommended
- **Fira Code iScript** font ([download here](https://github.com/kencrocken/FiraCodeiScript))
- **fd** (faster file finding for Telescope)
- **make** (for building Telescope fzf-native)

### Language-Specific
- **Go** (for Go development + debugging)
- **Rust** (for Rust development + debugging)
- **PHP** (for PHP development)

## Installation

### 1. Install Neovim

**macOS:**
```bash
brew install neovim
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install neovim
```

**Linux (Arch):**
```bash
sudo pacman -S neovim
```

### 2. Install Dependencies

**macOS:**
```bash
# Required
brew install git node ripgrep

# Recommended
brew install fd
brew install --cask font-fira-code

# Language-specific
brew install go rust php
```

**Linux (Ubuntu/Debian):**
```bash
# Required
sudo apt install git nodejs npm ripgrep

# Recommended
sudo apt install fd-find

# Install Fira Code iScript manually from GitHub

# Language-specific
sudo apt install golang rustc php
```

### 3. Install Fira Code iScript Font

Download from: https://github.com/kencrocken/FiraCodeiScript

**macOS:**
1. Download the font files
2. Double-click `.ttf` files and click "Install"
3. Set terminal font to "Fira Code iScript"

**Linux:**
1. Download the font files
2. Copy to `~/.local/share/fonts/`
3. Run `fc-cache -fv`
4. Set terminal font to "Fira Code iScript"

### 4. Clone This Configuration

**IMPORTANT:** This config is already installed at `~/.config/nvim-god`. To use it:

**Option A: Use as-is (already installed)**
```bash
# Launch Neovim from this directory
cd ~/.config/nvim-god
nvim
```

**Option B: Move to standard config location**
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Copy this config
cp -r ~/.config/nvim-god ~/.config/nvim

# Launch Neovim
nvim
```

### 5. First Launch

On first launch, lazy.nvim will automatically:
1. Install itself
2. Install all plugins
3. Compile Treesitter parsers
4. Set up LSP servers

**Wait for all installations to complete** (1-3 minutes).

### 6. Set Up AI Tools (Optional)

#### GitHub Copilot
```vim
:Copilot auth
```
Follow the browser prompts to authenticate.

#### Codeium
```vim
:Codeium Auth
```
Get a free API key from https://codeium.com

#### CodeCompanion (AI Chat)

Set environment variables in your shell config (`~/.zshrc` or `~/.bashrc`):

```bash
# OpenAI (ChatGPT)
export OPENAI_API_KEY="your-openai-key"

# Anthropic (Claude)
export ANTHROPIC_API_KEY="your-anthropic-key"
```

**Or use local/free Ollama:**
```bash
# Install Ollama
brew install ollama  # macOS
# or download from https://ollama.ai

# Pull a model
ollama pull llama3.2

# CodeCompanion will use Ollama automatically (no API key needed)
```

### 7. Install LSP Servers & Debuggers

LSP servers install automatically via Mason when you open a file. Manually install:

```vim
:Mason
```

Navigate and press `i` to install:
- **ts_ls** (JavaScript/TypeScript)
- **intelephense** (PHP)
- **rust-analyzer** (Rust)
- **gopls** (Go)
- **lua_ls** (Lua)
- **codelldb** (Rust debugger)
- **delve** (Go debugger)

### 8. Set Up Go Debugger

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

Ensure `$GOPATH/bin` is in your `$PATH`:
```bash
export PATH="$PATH:$(go env GOPATH)/bin"
```

---

## 🚀 Quick Start

After installation, open Neovim and try these essential features:

### Discover Keymaps
```vim
?                    " Press ? to see ALL keymaps instantly
<leader>fk           " Search keymaps (type "git", "buffer", etc.)
<leader>             " Wait 300ms to see available commands
```

### Navigate Files
```vim
<leader>e            " Toggle file explorer
<leader>ff           " Find files (fuzzy search)
<leader>fg           " Search text in files (live grep)
Tab / Shift-Tab      " Cycle through open file tabs
Alt+1-9              " Jump to specific tab
```

### Common Tasks
```vim
:Mason               " Install/manage LSP servers
:Copilot auth        " Set up GitHub Copilot (optional)
:Codeium Auth        " Set up Codeium (free AI, optional)
:checkhealth         " Verify everything works
```

You'll see a **tab bar at the top** showing all your open files - just like VSCode! 📑

---

## Configuration Structure

```
~/.config/nvim-god/
├── init.lua                      # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua             # Plugin manager setup
│   │   ├── options.lua          # Vim options
│   │   └── keymaps.lua          # Global keymaps
│   └── plugins/
│       ├── lsp.lua              # LSP configuration
│       ├── completion.lua       # nvim-cmp
│       ├── treesitter.lua       # Syntax highlighting
│       ├── telescope.lua        # Fuzzy finder
│       ├── neo-tree.lua         # File explorer
│       ├── ai.lua               # AI tools (Copilot, Codeium, CodeCompanion)
│       ├── dap.lua              # Debugging
│       ├── git.lua              # Git integration
│       ├── ui.lua               # Theme, Bufferline & UI
│       └── editor.lua           # Editing utilities
├── CLAUDE.md                     # AI assistant guidance
├── QUICK_FIXES.md                # Troubleshooting guide
└── README.md                     # This file
```

## Essential Keybindings

### General
- `<Space>` - Leader key
- `jk` or `kj` - Exit insert mode
- `<C-s>` - Save file
- `<Esc>` - Clear search highlights

### Help & Keymap Discovery 🔍
- `?` - **Show ALL keymaps instantly** (which-key popup)
- `<leader>?` - Show all keymaps (alternative)
- `<leader>fk` - **Search keymaps** with Telescope (fuzzy find)
- `<leader>hk` - Show keymap help
- `<leader>` (wait 300ms) - Auto-show available leader commands

### File Navigation
- `<leader>e` - **Toggle file explorer** (show/hide)
- `<leader>E` - Reveal current file in explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files

### LSP
- `gd` - Go to definition
- `gr` - Show references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format buffer
- `[d` / `]d` - Previous/next diagnostic

### AI Tools
- `<Tab>` - Accept **Copilot** suggestion (insert mode)
- `<Alt-Tab>` - Accept **Codeium** suggestion (insert mode)
- `<Alt-]>` / `<Alt-[>` - Next/previous AI suggestion
- `<leader>aa` - Open AI chat (CodeCompanion)
- `<leader>ap` - Add selection to AI chat (visual mode)
- `<leader>ac` - AI actions menu

### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/start debugging
- `<F5>` - Continue
- `<F10>` - Step over
- `<F11>` - Step into
- `<leader>du` - Toggle debug UI

### Git
- `<leader>gs` - Stage hunk
- `<leader>gr` - Reset hunk
- `<leader>gp` - Preview hunk
- `<leader>gb` - Toggle line blame
- `<leader>gg` - Git status (Fugitive)
- `]h` / `[h` - Next/previous hunk

### Window Management
- `<C-h/j/k/l>` - Navigate windows
- `<leader>|` - Vertical split
- `<leader>-` - Horizontal split
- `<leader>wd` - Close window

### Buffer Tabs (Visual Tab Bar) 📑
- `Tab` - Next buffer tab (in normal mode)
- `Shift+Tab` - Previous buffer tab
- `Alt+1` through `Alt+9` - Jump to buffer 1-9
- `Alt+$` - Jump to last buffer
- `<leader>bd` - Delete/close buffer
- `<leader>bc` - Pick buffer to close (interactive)
- `<leader>bp` - Pick buffer to switch (interactive)
- `<leader>bo` - Delete all other buffers
- `Shift+H` / `Shift+L` - Previous/next buffer (alternative)
- **Mouse**: Click tab to switch, right-click to close

### Comments
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` (visual) - Comment selection

### Surround
- `ysiw"` - Surround word with quotes
- `cs"'` - Change surrounding quotes to single quotes
- `ds"` - Delete surrounding quotes
- `S"` (visual) - Surround selection with quotes

### Telescope (In Telescope Window)
- `<C-n/p>` - Navigate results
- `<C-q>` - Send to quickfix
- `<Tab>` - Toggle selection
- Type to search/filter

### Neo-tree (File Explorer)
- `q` - Close explorer
- `?` - Show all neo-tree commands
- `<CR>` or `o` - Open file/folder
- `<Tab>` - Preview file
- `a` - Add file/directory
- `d` - Delete
- `r` - Rename

## Key Features Explained

### 📑 Buffer Tabs (Like VSCode)

You'll see a **visual tab bar** at the top showing all open files:

```
┌─────────────────────────────────────────────┐
│  init.lua  │  lsp.lua ✓  │  options.lua  │  ← Tab bar
├─────────────────────────────────────────────┤
│                                             │
│  Your code here...                          │
```

- **Tab** / **Shift-Tab** to cycle through tabs
- **Alt+1-9** to jump to specific tab
- **Click** tabs with mouse to switch
- **Right-click** to close a tab
- Shows LSP diagnostics (⚠️ errors) in tabs
- ✓ checkmark for saved files
- ● dot for modified files

### 🔍 Keymap Discovery System

Never forget a keymap again! **3 ways** to find them:

1. **Press `?`** - Instant popup showing ALL keymaps
2. **Press `<leader>fk`** - Searchable list (type "git", "buffer", etc.)
3. **Press `<leader>` and wait** - Auto-shows available commands

Example: Forgot how to close a buffer?
- Press `?` → Type `<leader>b` → See all buffer commands!

## Customization

### Change Colorscheme

Edit `lua/plugins/ui.lua`:
```lua
-- Replace nord.nvim with your preferred theme
{
  "your-favorite/theme.nvim",
  -- ... config
}
```

Update `init.lua`:
```lua
vim.cmd.colorscheme("your-theme")
```

### Add LSP Server

Edit `lua/plugins/lsp.lua`:

1. Add to `ensure_installed`:
```lua
ensure_installed = {
  "ts_ls",
  "rust_analyzer",
  "your-new-server", -- Add here
}
```

2. Add custom config (if needed):
```lua
lspconfig.your_server.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- Your settings
  },
})
```

### Disable Plugins

Set `enabled = false` in any plugin spec:
```lua
{
  "plugin-name/plugin.nvim",
  enabled = false, -- Disable this plugin
}
```

### Change Keybindings

Edit `lua/config/keymaps.lua` for global keymaps, or the respective plugin file for plugin-specific bindings.

## Troubleshooting

### Issue: Copilot not working
**Solution:**
```vim
:Copilot status
:Copilot auth
```

### Issue: LSP not starting
**Solution:**
```vim
:LspInfo
:Mason
```
Reinstall the LSP server in Mason.

### Issue: Treesitter errors
**Solution:**
```vim
:TSUpdate
:TSInstall <language>
```

### Issue: Icons not showing
**Solution:**
Install Fira Code iScript (or any Nerd Font) and set it in your terminal.

### Issue: Slow startup
**Solution:**
Check lazy-loading:
```vim
:Lazy profile
```

### Issue: Debugger not working
**Solution:**
- **Go**: Ensure `dlv` is installed: `which dlv`
- **Rust**: Check Mason installed `codelldb`: `:Mason`

### Issue: Git signs not showing
**Solution:**
Ensure you're in a git repository:
```bash
git init
```

## Commands

### Plugin Management
- `:Lazy` - Open plugin manager
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Sync plugins (install/update/clean)
- `:Mason` - Open Mason (LSP installer)

### LSP
- `:LspInfo` - Show LSP status
- `:LspRestart` - Restart LSP
- `:LspLog` - View LSP logs

### Treesitter
- `:TSUpdate` - Update parsers
- `:TSInstall <lang>` - Install parser
- `:TSBufToggle highlight` - Toggle highlighting

### Git
- `:Git` - Fugitive status
- `:Git commit` - Commit changes
- `:Git push` - Push to remote
- `:Gitsigns toggle_signs` - Toggle git signs

### Telescope
- `:Telescope` - List all pickers
- `:Telescope resume` - Resume last search

### Debugging
- `:DapContinue` - Start/continue debugging
- `:DapToggleBreakpoint` - Toggle breakpoint
- `:DapTerminate` - Stop debugging

## Performance

Expected startup time: **50-80ms** (lazy-loaded plugins)

Check your startup time:
```bash
nvim --startuptime startup.log
```

## Updates

Update all plugins:
```vim
:Lazy sync
```

Update Neovim config (if using Git):
```bash
cd ~/.config/nvim
git pull
```

## Uninstall

Remove config:
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

Restore backup (if made):
```bash
mv ~/.config/nvim.backup ~/.config/nvim
```

## Credits

Built with:
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [codeium.nvim](https://github.com/Exafunction/codeium.nvim) - Codeium AI
- [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) - AI chat
- [nord.nvim](https://github.com/shaunsingh/nord.nvim) - Nord theme

And many more amazing plugins!

## License

MIT License - Feel free to use and modify as you wish.

## Support

Having issues? Check:
1. **QUICK_FIXES.md** - Common issues and solutions
2. **CLAUDE.md** - Architecture guide for AI assistants
3. This README's troubleshooting section
4. Run `:checkhealth` for diagnostics
5. Plugin documentation (`:help plugin-name`)
6. Neovim help (`:help`)
7. Each plugin's GitHub issues

### Quick Health Check

```vim
:checkhealth                  " Full health check
:checkhealth vim.lsp          " LSP-specific check
:Lazy                         " Check plugin status
:Mason                        " Check LSP servers
```

---

**Happy Coding!** 🚀

**Pro Tip**: Press `?` anytime to see all available keymaps!
