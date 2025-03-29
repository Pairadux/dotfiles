--[[
  formatting.lua
  ------------------
  This file is for plugins that handle code formatting.
  Include tools that automatically format your code or integrate with external formatters.
]]

return {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            -- stylua: ignore
            { 'gw', function() require('conform').format { async = true, lsp_format = 'fallback' } end, mode = '', desc = 'Format buffer', },
        },
        opts = {
            notify_on_error = true,
            format_on_save = false,
            formatters_by_ft = {
                lua = { 'stylua' },
                go = { 'gofumpt' },

                javascript = { 'prettier' },
                css = { 'prettier' },
                html = { 'prettier' },
                svelte = { 'prettier' },

                python = { 'ruff' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },

                markdown = { 'prettier' },

                sh = { 'shfmt' },

                yaml = { 'prettier' },
            },
        },
    },
}
