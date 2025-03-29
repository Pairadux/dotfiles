--[[
  colorscheme.lua
  ------------------
  This file is for plugins that provide and manage color schemes.
  Add any themes or color customization plugins here.
]]

return {
    {
        'folke/tokyonight.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            require('tokyonight').setup {
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            }
            vim.cmd.colorscheme 'tokyonight-night'
        end,
    },
}
