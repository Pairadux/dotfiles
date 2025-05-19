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
o.number         = true  -- Absolute line numbers
o.relativenumber = true  -- Relative line numbers
o.numberwidth    = 2     -- Set width of number column
o.ruler          = false -- Disable the ruler
o.mouse          = "a"   -- Enable mouse support
o.showmode       = false -- Don't show mode (already in status line)
o.laststatus     = 3     -- Use global statusline
o.scrolloff      = 3     -- Minimal lines of context
o.signcolumn     = "yes"
o.showtabline    = 2

-----------------------------------------------------------
-- Clipboard
-----------------------------------------------------------
-- Set clipboard after UIEnter to avoid startup delays
vim.schedule(function() o.clipboard = "unnamedplus" end)

-----------------------------------------------------------
-- Performance & Timings
-----------------------------------------------------------
o.updatetime = 250 -- Faster completion, update time in ms
o.timeoutlen = 400 -- Mapped sequence wait time (ms)

-----------------------------------------------------------
-- Window Splitting
-----------------------------------------------------------
o.splitright = true -- Vertical splits open to the right
o.splitbelow = true -- Horizontal splits open below

-----------------------------------------------------------
-- Search Settings
-----------------------------------------------------------
o.ignorecase = true -- Case-insensitive searching...
o.smartcase  = true -- ...unless uppercase is used

-----------------------------------------------------------
-- File Handling & Undo
-----------------------------------------------------------
o.undofile = true -- Enable persistent undo

-----------------------------------------------------------
-- Indentation
-----------------------------------------------------------
o.expandtab   = true -- Use spaces instead of tabs
o.tabstop = 4        -- Tab Stop
o.shiftwidth  = 4    -- Indent width
o.smartindent = true -- Autoindent based on syntax

-----------------------------------------------------------
-- Visual & Display Options
-----------------------------------------------------------
o.termguicolors = true                                    -- Enable true colors for plugins like bufferline
o.cursorline    = true                                    -- Highlight current line
o.cursorlineopt = "both"                                  -- Highlight line and number column
o.inccommand    = "split"                                 -- Live preview for substitutions
o.wrap          = false                                   -- Disable line wrapping
o.spell         = false                                   -- Disable spell checking
o.list          = false                                   -- Hide whitespace characters
opt.listchars   = { tab = '» ', trail = '·', nbsp = '␣' } -- Whitespace characters (keep opt, not o)
opt.fillchars   = { eob = " " }                           -- End-of-buffer filler (keep opt, not o)
opt.whichwrap:append("<>[]hl")                            -- Allow cursor wrapping with these keys (keep opt, not o)

-----------------------------------------------------------
-- Session & Folding Options (Global Options)
-----------------------------------------------------------
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.foldmethod     = "marker" -- Use markers for folding

-----------------------------------------------------------
-- Confirmation Dialogs
-----------------------------------------------------------
o.confirm = true -- Confirm on unsaved changes when quitting

-----------------------------------------------------------
-- Disable Intro Message
-----------------------------------------------------------
opt.shortmess:append("sI") -- Disable Neovim intro (keep opt, not o)

-----------------------------------------------------------
-- PATH Update for Mason.nvim
-----------------------------------------------------------
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
-- stylua: ignore end
