-- Aliases for options and globals
local opt = vim.opt
local o = vim.o
local g = vim.g

-- stylua: ignore start
-----------------------------------------------------------
-- Global Variables & Providers
-----------------------------------------------------------
g.tmux_navigator_no_mappings = 1

-- Disable unused language providers
g.loaded_node_provider    = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider    = 0
g.loaded_ruby_provider    = 0

-----------------------------------------------------------
-- Basic UI Settings
-----------------------------------------------------------
opt.number         = true  -- Absolute line numbers
opt.relativenumber = true  -- Relative line numbers
opt.numberwidth    = 2     -- Set width of number column
opt.ruler          = false -- Disable the ruler
opt.mouse          = "a"   -- Enable mouse support
opt.showmode       = false -- Don't show mode (already in status line)
opt.laststatus     = 3     -- Use global statusline
opt.scrolloff      = 5     -- Minimal lines of context
opt.signcolumn     = "yes"
opt.showtabline    = 2

-----------------------------------------------------------
-- Clipboard
-----------------------------------------------------------
-- Set clipboard after UIEnter to avoid startup delays
vim.schedule(function() opt.clipboard = "unnamedplus" end)

-----------------------------------------------------------
-- Performance & Timings
-----------------------------------------------------------
opt.updatetime = 250 -- Faster completion, update time in ms
opt.timeoutlen = 400 -- Mapped sequence wait time (ms)

-----------------------------------------------------------
-- Window Splitting
-----------------------------------------------------------
opt.splitright = true -- Vertical splits open to the right
opt.splitbelow = true -- Horizontal splits open below

-----------------------------------------------------------
-- Search Settings
-----------------------------------------------------------
opt.ignorecase = true -- Case-insensitive searching...
opt.smartcase  = true -- ...unless uppercase is used

-----------------------------------------------------------
-- File Handling & Undo
-----------------------------------------------------------
opt.undofile = true -- Enable persistent undo

-----------------------------------------------------------
-- Indentation
-----------------------------------------------------------
opt.expandtab   = true -- Use spaces instead of tabs
vim.opt.tabstop = 4    -- Tab Stop
opt.shiftwidth  = 4    -- Indent width
opt.smartindent = true -- Autoindent based on syntax

-----------------------------------------------------------
-- Visual & Display Options
-----------------------------------------------------------
opt.termguicolors = true          -- Enable true colors for plugins like bufferline
opt.cursorline    = true          -- Highlight current line
opt.cursorlineopt = "both"        -- Highlight line and number column
opt.list          = false         -- Hide whitespace characters
opt.fillchars     = { eob = " " } -- End-of-buffer filler
opt.inccommand    = "split"       -- Live preview for substitutions
opt.wrap          = false         -- Disable line wrapping
opt.spell         = false         -- Disable spell checking
opt.whichwrap:append("<>[]hl")    -- Allow cursor wrapping with these keys

-----------------------------------------------------------
-- Session & Folding Options (Global Options)
-----------------------------------------------------------
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.foldmethod     = "marker" -- Use markers for folding

-----------------------------------------------------------
-- Confirmation Dialogs
-----------------------------------------------------------
opt.confirm = true -- Confirm on unsaved changes when quitting

-----------------------------------------------------------
-- Disable Intro Message
-----------------------------------------------------------
opt.shortmess:append("sI") -- Disable Neovim intro

-----------------------------------------------------------
-- PATH Update for Mason.nvim
-----------------------------------------------------------
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
-- stylua: ignore end
