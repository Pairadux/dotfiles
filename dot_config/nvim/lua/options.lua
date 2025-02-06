require("nvchad.options")

-- add yours here!

local g = vim.g
local o = vim.o
local opt = vim.opt
local wo = vim.wo

g.tmux_navigator_no_mappings = 1

o.tabstop = 4
o.expandtab = true
o.softtabstop = 4
o.shiftwidth = 4
o.cursorlineopt = "both"
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.foldmethod = "marker"

opt.wrap = false

wo.relativenumber = true
