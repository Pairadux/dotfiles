--[[
    util.lua
    ---------
    This file is for utility plugins that provide helper functions or extra commands.
    Include any plugins that offer additional features or integrations which don't belong to a specific category.
]]

return {

    -- Scope {{{
    {
        'tiagovla/scope.nvim',
        cond = false,
        event = { 'TabNew', 'TabEnter', 'TabLeave' },
        config = function()
            require('scope').setup {
                hooks = {
                    pre_tab_leave = function()
                        vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
                    end,
                    post_tab_enter = function()
                        vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
                    end,
                },
            }
        end,
    }, -- }}}

    -- Resession {{{
    {
        'stevearc/resession.nvim',
        dependencies = {
            { 'akinsho/bufferline.nvim' },
            -- 'romgrk/barbar.nvim',
            -- 'tiagovla/scope.nvim',
            -- { 'Pairadux/platter.nvim', dev = true },
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
            extensions = {
                -- bufferline = {},
                -- scope = {},
            },
        },
    }, -- }}}

    -- Auto Save {{{
    {
        'okuuva/auto-save.nvim',
        cmd = 'ASToggle', -- optional for lazy loading on command
        event = { 'InsertLeave' }, -- optional for lazy loading on trigger events
        opts = {
            trigger_events = { -- See :h events
                immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' }, -- vim events that trigger an immediate save
                defer_save = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
                cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
            },
            debounce_delay = 1000,
        },
    }, -- }}}
}
