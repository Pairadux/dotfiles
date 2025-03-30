--[[
  editor.lua
  -------------
  This file is for plugins that modify general editor behavior.
  Include plugins for file navigation, editing enhancements,
  and overall improvements to the editor experience.
]]

return {

    { 'echasnovski/mini.ai' },

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
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
        cmd = 'Neotree',
        keys = {
            { '<C-n>', '<cmd>Neotree toggle<CR>', desc = 'NeoTree Toggle', silent = true },
        },
        opts = {
            window = {
                width = 30,
            },
            filesystem = {
                window = {
                    mappings = {
                        ['<C-n>'] = 'close_window',
                    },
                },
            },
        },
    }, -- }}}

    -- Nvim Autopairs {{{
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        -- Optional dependency
        dependencies = { 'hrsh7th/nvim-cmp' },
        config = function()
            require('nvim-autopairs').setup {}
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            local cmp = require 'cmp'
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
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
        keys = { '<leader>', '<c-w>', '"', "'", '`', 'c', 'v', 'g' },
        opts = {
            preset = 'helix',
            keys = {
                scroll_down = '<c-Down>',
                scroll_up = '<c-Up>',
            },
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.opt.timeoutlen
            delay = 0,
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
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
                { '<leader>i', group = '[I]nsert' },
                { '<leader>l', group = '[L]azy' },
                { '<leader>m', group = '[M]ason' },
                { '<leader>s', group = '[S]ession' },
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
            -- stylua: ignore end
        },
    }, -- }}}
}
