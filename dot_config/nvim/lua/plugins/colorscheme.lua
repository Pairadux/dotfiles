--[[
  colorscheme.lua
  ------------------
  This file is for plugins that provide and manage color schemes.
  Add any themes or color customization plugins here.
]]

return {
    {
        'folke/tokyonight.nvim',
        priority = 1500, -- Make sure to load this before all the other start plugins.
        config = function()
            require('tokyonight').setup {
                style = 'night',
                transparent = false,
                styles = {
                    comments = { italic = true }, -- Disable italics in comments
                    sidebars = 'dark', -- keeps sidebar bg darker
                    floats = 'dark',
                },
                -- on_colors = function(colors)
                --     -- you can tweak palette here if you want
                --     -- e.g. colors.blue1 = "#89b4fa"
                -- end,
                on_highlights = function(highlights, colors)
                    -- make the separator pop with one of the theme’s blues:
                    highlights.WinSeparator = {
                        fg = colors.blue1,
                        bg = 'NONE',
                    }
                    -- fallback for older Neovim:
                    highlights.VertSplit = {
                        fg = colors.blue1,
                        bg = 'NONE',
                    }
                    -- restore visible EOB tildes (tokyonight hides them by default)
                    highlights.EndOfBuffer = {
                        fg = colors.dark3,
                    }
                end,
            }
            vim.cmd.colorscheme 'tokyonight-night'
        end,
    },
}
