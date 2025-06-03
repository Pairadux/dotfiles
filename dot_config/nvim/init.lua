vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'config.options'
require 'config.autocmds'
vim.schedule(function()
    require 'config.mappings'
end)
require 'config.lazy'
