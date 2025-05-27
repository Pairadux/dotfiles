--[[
    editor.lua
    -------------
    This file is for plugins that modify general editor behavior.
    Include plugins for file navigation, editing enhancements,
    and overall improvements to the editor experience.
]]

return {

    { 'NMAC427/guess-indent.nvim' }, -- Detect tabstop and shiftwidth automatically

    -- Mini {{{
    { 'echasnovski/mini.ai', opts = {} },

    { 'echasnovski/mini.align', opts = {} },

    { 'echasnovski/mini.move', event = 'VeryLazy', opts = {} }, -- }}}

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
        lazy = false,
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

    -- Harpoon {{{
    {
        'ThePrimeagen/harpoon',
        cond = false,
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        keys = {
            -- stylua: ignore start
            { '<leader>hl',      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = '[H]arpoon [L]ist' },
            { '<leader><space>', function() require('harpoon'):list():add()     end, desc = 'Harpoon Add' },
            { '<leader>hr',      function() require('harpoon'):list():remove()  end, desc = '[H]arpoon [R]emove' },
            { '<C-n>',           function() require('harpoon'):list():next()    end, desc = 'Harpoon Next Location' },
            { '<C-p>',           function() require('harpoon'):list():prev()    end, desc = 'Harpoon Previous Location' },
            { '<leader>1',       function() require('harpoon'):list():select(1) end, desc = 'Harpoon 1' },
            { '<leader>2',       function() require('harpoon'):list():select(2) end, desc = 'Harpoon 2' },
            { '<leader>3',       function() require('harpoon'):list():select(3) end, desc = 'Harpoon 3' },
            { '<leader>4',       function() require('harpoon'):list():select(4) end, desc = 'Harpoon 4' },
            { '<leader>5',       function() require('harpoon'):list():select(5) end, desc = 'Harpoon 5' },
            -- stylua: ignore end
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
                '<leader>sr',
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
                desc = '[S]earch and [R]eplace',
            },
            {
                '<leader>si',
                function()
                    local grug = require 'grug-far'
                    grug.open { visualSelectionUsage = 'operate-within-range' }
                end,
                mode = { 'n', 'v' },
                desc = '[S]earch and Replace [I]n Range',
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
            -- this setting is independent of vim.o.timeoutlen
            delay = 0,
            icons = {
                mappings = vim.g.have_nerd_font,
            },
            -- Document existing key chains
            spec = {
                { '<leader><tab>', group = '[Tab]' },
                { '<leader>fe', group = '[E]xtras', icon = { icon = '', color = 'orange' } },
                { '<leader>f', group = '[F]ind', icon = { icon = '', color = 'orange' } },
                { '<leader>c', group = '[C]ode', mode = { 'n', 'x' }, icon = { icon = '', color = 'orange' } },
                { '<leader>d', group = '[D]ocument', icon = { icon = '󰈙', color = 'orange' } },
                { '<leader>h', group = '[H]arpoon' },
                { '<leader>H', group = '[H]unk', mode = { 'n', 'v' } },
                { '<leader>o', group = '[O]pen', icon = { icon = '', color = 'orange' } },
                { '<leader>S', group = '[S]ession', icon = { icon = '', color = 'orange' } },
                { '<leader>s', group = '[S]earch', icon = { icon = '󰛔', color = 'orange' } },
                { '<leader>e', group = '[E]xtras', icon = { icon = '', color = 'orange' } },
                { '<leader>ei', group = '[I]nsert', icon = { icon = '', color = 'orange' } },
                { '<leader>et', group = '[T]oggle', icon = { icon = '', color = 'orange' } },
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
        event = 'VeryLazy',
        opts = {
            -- jump = {
            --     autojump = true,
            -- },
            highlight = {
                backdrop = false,
            },
            modes = {
                char = {
                    highlight = { backdrop = false },
                },
            },
        },
        keys = {
            -- stylua: ignore start
            { 's', function() require('flash').jump() end, mode = { 'n' }, desc = 'Flash', },
            { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter', },
            -- NOTE: I cannot figure out what these 2 do, so I am just not using them
            { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash', },
            { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search', },
            -- stylua: ignore end
        },
        config = function(_, opts)
            require('flash').setup(opts)
            vim.api.nvim_set_hl(0, 'FlashLabel', { link = 'IncSearch' })
        end,
    }, -- }}}
}
