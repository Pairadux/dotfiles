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
        dependencies = {
            {
                'tiagovla/scope.nvim',
                config = true,
            },
        },
        keys = {
            -- stylua: ignore start
            { '<leader>ss', function() local cwd = vim.fn.getcwd() require('resession').save(cwd, { dir = 'dirsession', notify = true }) end, desc = '[S]ession [S]ave', },
            { '<leader>sl', function() local cwd = vim.fn.getcwd() require('resession').load(cwd, { dir = 'dirsession', notify = true }) end, desc = '[S]ession [L]oad', },
            { '<leader>st', function() require('resession').save_tab() end, desc = '[S]ession Save [T]ab', },
            { '<leader>sd', function() require('resession').delete(nil, { dir = 'dirsession', notify = true }) end, desc = '[S]ession [D]elete', },
            -- stylua: ignore end
        },
        opts = {
            -- override default filter
            buf_filter = function(bufnr)
                local buftype = vim.bo[bufnr].buftype
                if buftype == 'help' then
                    return true
                end
                if buftype ~= '' and buftype ~= 'acwrite' then
                    return false
                end
                if vim.api.nvim_buf_get_name(bufnr) == '' then
                    return false
                end
                -- this is required, since the default filter skips nobuflisted buffers
                return true
            end,
            extensions = { scope = {} },
        },
    }, -- }}}

    -- Auto Save {{{
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle', -- optional for lazy loading on command
        event = { 'InsertLeave' }, -- optional for lazy loading on trigger events
        opts = {
            trigger_events = {
                immediate_save = {
                    { 'BufLeave', 'FocusLost' },
                },
                defer_save = {},
                cancel_defer_save = {},
            },
        },
    }, -- }}}
}
