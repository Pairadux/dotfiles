# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Plugin Management
- `nvim +Lazy` - Open the Lazy.nvim plugin manager
- `nvim +Mason` - Open Mason for LSP/formatter/linter management

### Testing & Development
This configuration doesn't include specific test frameworks. The setup uses:
- Mason for automatic installation of LSP servers, formatters, and linters
- Stylua for Lua formatting (auto-installed via Mason)

## Architecture Overview

This is a modern Neovim configuration built on the Lazy.nvim plugin manager with a well-organized modular structure.

### Configuration Structure

**Entry Point (`init.lua`)**:
- Sets up leader keys (space) and essential globals
- Loads config modules in sequence: options → autocmds → mappings → lazy

**Core Configuration (`lua/config/`)**:
- `options.lua` - All vim options, UI settings, and performance configurations
- `mappings.lua` - Custom keybindings organized by mode (insert, normal, visual, terminal)
- `autocmds.lua` - Autocommands for editor behavior
- `lazy.lua` - Lazy.nvim setup with plugin imports from `plugins/` and `plugins/extras/`

**Plugin Organization (`lua/plugins/`)**:
Each file handles a specific aspect of the editor:
- `lsp/init.lua` - Complete LSP setup with Mason integration, servers, and keybindings
- `coding.lua` - Code completion (Blink.cmp), snippets (LuaSnip), and language-specific tools (flutter-tools loads on `dart`, go.nvim on `go`/`gomod`)
- `editor.lua` - Editor enhancements (surround, autopairs, file navigation, search/replace)
- `ui.lua` - Interface plugins (statusline, bufferline, notifications)
- `treesitter.lua` - Syntax highlighting and code parsing
- `formatting.lua` - Code formatting setup
- `linting.lua` - Code linting configuration
- `colorscheme.lua` - Theme configuration (tokyonight with custom EndOfBuffer highlight for visible `~` tildes)

**Extras (`lua/plugins/extras/`)**:
- Optional plugins that can be easily enabled/disabled
- `debug.lua` - Debugging tools (DAP)
- `snacks.lua` - Snacks.nvim utility collection (picker, dashboard, lazygit, terminal, etc.)

### Disabled Plugins

The following plugins are present but disabled via `cond = false`:
- harpoon - File mark navigation (replaced by `<C-p>` smart picker)
- scope.nvim - Tab-scoped buffers
- neo-tree - File tree explorer (replaced by oil.nvim)
- yazi.nvim - Terminal file manager
- vim-tmux-navigator - Tmux pane navigation
- mini.files - Mini file explorer

### Key Architectural Patterns

**Plugin Configuration Pattern**:
Each plugin file returns a table of plugin specifications following Lazy.nvim's format with clear comments and fold markers for organization.

**Lazy Loading Strategy**:
- Event-based loading (`BufReadPre`, `InsertEnter`, `VeryLazy`)
- Command-based loading for tools like Mason and Oil
- Filetype-specific loading for language tools (`dart`, `go`, `lua`)

**LSP Integration**:
- Centralized LSP configuration in `lsp/init.lua`
- Mason handles automatic installation of servers and tools
- Blink.cmp provides completion with LSP integration
- Consistent keybinding pattern with `<leader>l` prefix for LSP actions

**File Management Approach**:
- Oil.nvim as the primary file explorer (opens with preview pane via `<leader>oo`)
- `<C-p>` for frecency-powered smart file finding (snacks.picker.smart)
- `<leader>fb` for buffer switching with frecency sorting (excludes current buffer)

**Utility Functions**:
Custom utilities in `lua/util.lua` for text manipulation and formatting helpers (insert_title, insert_line_break, squeeze_interior_whitespace).

### Important Configuration Details

- Uses space as leader key
- Nerd Font support with graceful fallbacks
- Persistent undo enabled
- Mason PATH integration for tool availability
- Performance optimizations with disabled default plugins
- Global statusline and consistent UI borders
- EOB tildes (`~`) visible in muted gray below file content
