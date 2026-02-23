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
            condition = function(buf)
                if vim.bo[buf].filetype == 'harpoon' then
                    return false
                end
                return true
            end,
        },
    }, -- }}}
}
