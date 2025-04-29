--[[
    editor.lua
    -------------
    This file is for plugins that modify general editor behavior.
    Include plugins for file navigation, editing enhancements,
    and overall improvements to the editor experience.
]]

return {

    { 'echasnovski/mini.ai', opts = {} },

    { 'echasnovski/mini.align', opts = {} },

    -- Todo Comments {{{
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
        keys = {
            -- stylua: ignore 
            ---@diagnostic disable-next-line: undefined-field
            { '<leader>ft', function() require('snacks').picker.todo_comments() end, desc = '[F]ind [T]odo', },
        },
    }, -- }}}

    -- Nvim Surround {{{
    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        event = 'VeryLazy',
        opts = {},
    }, -- }}}

    -- Neo Tree {{{
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = '*',
        cond = false,
        cmd = 'Neotree',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
        keys = {
            { '<C-n>', '<cmd>Neotree toggle reveal<CR>', desc = 'NeoTree Toggle', silent = true },
        },
        opts = {
            close_if_last_window = true,
            window = {
                width = 30,
            },
            -- filesystem = {
            --     window = {
            --         mappings = {
            --             ['<C-n>'] = 'close_window',
            --         },
            --     },
            -- },
        },
    }, -- }}}

    -- Oil {{{
    {
        'stevearc/oil.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cmd = 'Oil',
        keys = {
            { '<leader>oo', '<cmd>Oil<CR>', desc = '[O]pen [O]il' },
        },
        opts = {
            default_file_explorer = true,
            columns = {
                'permissions',
                'size',
                'icon',
            },
            delete_to_trash = true,
        },
    }, -- }}}

    -- Yazi {{{
    {
        'mikavilpas/yazi.nvim',
        cmd = 'Yazi',
        dependencies = { 'folke/snacks.nvim' },
        keys = {
            {
                '<leader>oy',
                mode = { 'n', 'v' },
                '<cmd>Yazi<cr>',
                desc = '[O]pen [Y]azi',
            },
        },
        opts = {
            open_for_directories = false,
            keymaps = {
                show_help = '<f1>',
            },
        },
    }, -- }}}

    -- GrugFar {{{
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        opts = {
            headerMaxWidth = 80,
            keymaps = {
                close = { n = '<C-c>' },
            },
        },
        keys = {
            {
                '<leader>gf',
                function()
                    local grug = require 'grug-far'
                    local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
                    grug.open {
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                        },
                    }
                end,
                mode = { 'n', 'v' },
                desc = '[G]rug [F]ar',
            },
        },
    }, -- }}}

    -- Nvim Autopairs {{{
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    }, -- }}}

    -- Vim Tmux Navigator {{{
    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { '<C-h>', '<cmd>TmuxNavigateLeft<CR>', desc = 'Tmux Window Left' },
            { '<C-l>', '<cmd>TmuxNavigateRight<CR>', desc = 'Tmux Window Right' },
            { '<C-A-j>', '<cmd>TmuxNavigateDown<CR>', desc = 'Tmux Window Down' },
            { '<C-A-k>', '<cmd>TmuxNavigateUp<CR>', desc = 'Tmux Window Up' },
        },
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
    }, -- }}}

    -- WhichKey {{{
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            preset = 'helix',
            keys = {
                scroll_down = '<c-Down>',
                scroll_up = '<c-Up>',
            },
            filter = function(mapping)
                -- example to exclude mappings without a description
                return mapping.desc and mapping.desc ~= ''
            end,
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.opt.timeoutlen
            delay = 0,
            icons = {
                mappings = vim.g.have_nerd_font,
            },
            -- Document existing key chains
            spec = {
                { '<leader><tab>', group = '[Tab]' },
                { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>r', group = '[R]ename' },
                { '<leader>f', group = '[F]ind' },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = '[H]unk', mode = { 'n', 'v' } },
                { '<leader>g', group = '[G]rug', mode = { 'n', 'v' } },
                { '<leader>i', group = '[I]nsert' },
                { '<leader>o', group = '[O]pen' },
                { '<leader>s', group = '[S]ession' },
                { '[', group = 'Prev' },
                { ']', group = 'Next' },
                { 'g', group = 'Goto' },
                { 'z', group = 'Fold' },
                { 'gx', desc = 'Open with system app' },
            },
        },
    }, -- }}}

    -- Flash {{{
    {
        'folke/flash.nvim',
        opts = {
            highlight = {
                backdrop = false,
            },
            modes = {
                char = {
                    multi_line = false,
                    char_actions = function()
                        return {
                            [';'] = 'next', -- set to `right` to always go right
                            [','] = 'prev', -- set to `left` to always go left
                        }
                    end,
                    highlight = { backdrop = false },
                },
            },
        },
        keys = {
            -- stylua: ignore start
            { 's', function() require('flash').jump() end, mode = { 'n' }, desc = 'Flash', },
            { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter', },
            -- NOTE: I cannot figure out what these 2 do, so I am just not using them
            -- { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash', },
            -- { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search', },
            --
            -- stylua: ignore end
        },
    }, -- }}}
}
