--[[
    coding.lua
    -------------
    This file is for plugins that enhance your coding workflow.
    Include plugins for code navigation, autocompletion, snippet management,
    and any other coding productivity tools.
]]

return {

    { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings

    {
        'mfussenegger/nvim-jdtls',
        enabled = false,
    },

    -- Lazy Dev {{{
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                'nvim-dap-ui',
            },
        },
    }, -- }}}

    -- Go Nvim {{{
    {
        'ray-x/go.nvim',
        dependencies = {
            'ray-x/guihua.lua',
            'neovim/nvim-lspconfig',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {},
        ft = { 'go', 'gomod' },
        build = ':lua require("go.install").update_all_sync()',
    }, -- }}}

    -- Flutter Tools {{{
    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('flutter-tools').setup {
                ui = {
                    border = 'rounded',
                },
                decorations = {
                    statusline = {
                        app_version = true,
                        device = true,
                    },
                },
                debugger = {
                    enabled = false, -- Can enable later if you want
                },
                lsp = {
                    color = {
                        enabled = true, -- Shows colors in editor
                        background = false,
                        foreground = false,
                        virtual_text = true,
                    },
                    settings = {
                        showTodos = true,
                        completeFunctionCalls = true,
                    },
                },
            }
        end,
    }, -- }}}

    -- Blink {{{
    {
        'saghen/blink.cmp',
        version = '1.*',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
                config = function()
                    require('luasnip').setup {
                        region_check_events = 'CursorHold,InsertLeave,InsertEnter',
                        delete_check_events = 'TextChanged,InsertEnter',
                    }
                    require('luasnip.loaders.from_vscode').lazy_load()
                end,
            },
        },
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = 'super-tab',
                ['<C-j>'] = { 'select_next', 'fallback' },
                ['<C-k>'] = { 'select_prev', 'fallback' },
            },
            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },
            snippets = { preset = 'luasnip' },
            completion = {
                menu = { border = 'single' },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = { border = 'single' },
                },
                -- ghost_text = { enabled = true },
            },
            signature = {
                enabled = true,
                window = { border = 'single' },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                per_filetype = {
                    lua = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
        },
        opts_extend = { 'sources.default' },
    }, --}}}

}
