-- ~/.config/nvim/ftplugin/norg.lua
local map = vim.keymap.set

-- Options
vim.wo.foldlevel = 99

-- Wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0
vim.opt_local.colorcolumn = ""

-- Navigate display lines
map("n", "j", "gj", { buffer = true, silent = true })
map("n", "k", "gk", { buffer = true, silent = true })
map("n", "0", "g0", { buffer = true, silent = true })
map("n", "$", "g$", { buffer = true, silent = true })
