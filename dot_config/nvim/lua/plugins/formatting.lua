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
            -- stylua: ignore start
            { 'gw',         function() require('conform').format { async = true, lsp_format = 'fallback' } end, mode = '', desc = 'Format buffer', },
            { '<leader>lf', function() require('conform').format { async = true, lsp_format = 'fallback' } end, desc = '[L]anguage [F]ormat', },
            -- stylua: ignore end
        },
        opts = {
            notify_on_error = true,
            format_on_save = false,
            formatters_by_ft = {
                lua = { 'stylua' },
                go = { 'gofumpt' },

                javascript = { 'prettier' },
                typescript = { 'prettier' },
                css = { 'prettier' },
                html = { 'prettier' },
                svelte = { 'prettier' },

                python = { 'ruff' },

                c = { 'clang-format' },
                cpp = { 'clang-format' },

                java = { 'google-java-format' },

                markdown = { 'prettier' },

                sh = { 'shfmt' },

                zsh = { 'beautysh' },

                yaml = { 'prettier' },
            },
        },
    },
}
