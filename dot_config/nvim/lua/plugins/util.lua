--[[
  util.lua
  ---------
  This file is for utility plugins that provide helper functions or extra commands.
  Include any plugins that offer additional features or integrations which don't belong to a specific category.
]]

return {

    -- Resession{{{
    {
        'stevearc/resession.nvim',
        keys = {
            {
                '<leader>ss',
                function()
                    local cwd = vim.fn.getcwd()
                    require('resession').save(cwd, { dir = 'dirsession', notify = true })
                end,
                desc = '[S]ession [S]ave',
            },
            {
                '<leader>sl',
                function()
                    local cwd = vim.fn.getcwd()
                    require('resession').load(cwd, { dir = 'dirsession', notify = true })
                end,
                desc = '[S]ession [L]oad',
            },
            {
                '<leader>st',
                function()
                    require('resession').save_tab()
                end,
                desc = '[S]ession Save [T]ab',
            },
            {
                '<leader>sd',
                function()
                    require('resession').delete(nil, { dir = 'dirsession', notify = true })
                end,
                desc = '[S]ession [D]elete',
            },
        },
        opts = { extensions = {} },
    },-- }}}

    -- Auto Save {{{
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle', -- optional for lazy loading on command
        event = { 'InsertLeave', 'TextChanged' }, -- optional for lazy loading on trigger events
        opts = {
            trigger_events = {
                immediate_save = {
                    { 'BufLeave', 'FocusLost' },
                },
                defer_save = {},
                cancel_defer_save = {},
            },
        },
    },-- }}}

}
