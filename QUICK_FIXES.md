# Quick Fixes for Healthcheck Issues

## ✅ Already Fixed

I've updated the following deprecation warnings:
- ✅ LSP diagnostic signs (now uses modern `vim.diagnostic.config`)
- ✅ which-key config (updated to new spec format)

**No restart needed** - changes will apply on next Neovim launch.

---

## 🔧 Optional: Authenticate AI Tools

### GitHub Copilot (Paid)
```vim
:Copilot auth
```
Then follow the browser prompts.

### Codeium (Free)
```vim
:Codeium Auth
```
Get a free API key at https://codeium.com

### Disable if not using
If you don't want AI tools, edit `lua/plugins/ai.lua` and set:
```lua
enabled = false,  -- For copilot.lua or codeium.nvim
```

---

## 🟡 Optional: Install PHP Support (Only if needed)

If you're working with PHP projects:

```bash
# macOS
brew install php composer

# Linux (Ubuntu/Debian)
sudo apt install php composer
```

Then restart Neovim and intelephense will work automatically.

---

## ⚪ Safe to Ignore

These warnings are **informational only** and don't affect functionality:

### 1. **luarocks not installed**
- ✅ **Action**: None needed
- **Why**: No plugins require it (Mason handles everything)

### 2. **wget not available**
- ✅ **Action**: None needed
- **Why**: curl is available and works fine

### 3. **tree-sitter CLI not found**
- ✅ **Action**: None needed
- **Why**: Only needed for `:TSInstallFromGrammar` (not `:TSInstall`)

### 4. **pip not available**
- ✅ **Action**: None needed (unless you want Python plugins)
- **Fix if needed**: `brew install python` or `apt install python3-pip`

### 5. **Java/javac not available**
- ✅ **Action**: None needed (unless you write Java)

### 6. **Julia not available**
- ✅ **Action**: None needed (unless you write Julia)

### 7. **Plugin deprecation warnings** (noice.nvim, nvim-treesitter)
- ✅ **Action**: None - these are plugin issues, not your config
- **Why**: Plugin authors will fix in future updates

### 8. **Keymap overlaps** (which-key warnings)
- ✅ **Action**: None - this is **normal and expected**
- **Why**: Keymaps like `ys` and `yss` are designed to work together
  - `ys` waits for a motion (e.g., `ysiw"` = surround word with quotes)
  - `yss` immediately surrounds the line

---

## 🎯 Verification

Restart Neovim and run:
```vim
:checkhealth
```

You should see:
- ✅ No more LSP sign_define warnings
- ✅ No more which-key spec warnings
- ⚠️ Only optional/informational warnings remaining

---

## 📊 What's Working

Your config is **fully functional** for:
- ✅ JavaScript/TypeScript development
- ✅ Lua development (lua_ls active)
- ✅ Go development (gopls ready)
- ✅ Rust development (rust-analyzer ready)
- ✅ PHP development (intelephense ready, needs PHP installed)
- ✅ Debugging (Go & Rust)
- ✅ Git integration
- ✅ Fuzzy finding
- ✅ File explorer
- ✅ Code completion
- ✅ Syntax highlighting

---

## 🚀 Next Steps

1. **Restart Neovim** to apply the fixes
2. **(Optional)** Authenticate AI tools if you want them
3. **(Optional)** Install PHP if working with PHP projects
4. **Start coding!** Everything else is ready to go

**Pro Tip**: Run `:Mason` to see all available LSP servers, formatters, and linters you can install for other languages!
