--[[
  ui.lua
  -------
  This file is for plugins that affect the user interface.
  Include plugins that enhance visual components, layout adjustments, and overall UI improvements.
]]

return {

    -- Indent Blankline {{{
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'VeryLazy',
        main = 'ibl',
        opts = {},
    }, -- }}}

    -- Lualine {{{
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                theme = 'tokyonight',
            },
        },
    }, -- }}}

    -- Barbar {{{
    -- local map = vim.api.nvim_set_keymap
    -- local opts = { noremap = true, silent = true }
    --
    -- -- Move to previous/next
    -- map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    -- map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    --
    -- -- Re-order to previous/next
    -- map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    -- map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
    --
    -- -- Goto buffer in position...
    -- map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    -- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    -- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    -- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    -- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    -- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    -- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    -- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    -- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    -- map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    --
    -- -- Pin/unpin buffer
    -- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    --
    -- -- Goto pinned/unpinned buffer
    -- --                 :BufferGotoPinned
    -- --                 :BufferGotoUnpinned
    --
    -- -- Close buffer
    -- map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    --
    -- -- Wipeout buffer
    -- --                 :BufferWipeout
    --
    -- -- Close commands
    -- --                 :BufferCloseAllButCurrent
    -- --                 :BufferCloseAllButPinned
    -- --                 :BufferCloseAllButCurrentOrPinned
    -- --                 :BufferCloseBuffersLeft
    -- --                 :BufferCloseBuffersRight
    --
    -- -- Magic buffer-picking mode
    -- map('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
    -- map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)
    --
    -- -- Sort automatically by...
    -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
    -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    --
    -- -- Other:
    -- -- :BarbarEnable - enables barbar (enabled by default)
    -- -- :BarbarDisable - very bad command, should never be used
    {
        'romgrk/barbar.nvim',
        enabled = false,
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
            -- 'tiagovla/scope.nvim',
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            animation = false,
            clickable = false,
            icons = {
                button = '',
            },
            sidebar_filetypes = {
                ['neo-tree'] = true,
            },
        },
        keys = {
            -- stylua: ignore start
            { '<S-tab>', '<Cmd>BufferPrevious<CR>', noremap = true, silent = true, desc = 'Buffer Goto Previous'},
            { '<tab>', '<Cmd>BufferNext<CR>', noremap = true, silent = true, desc = 'Buffer Goto Next'},
            { '<S-Left>', '<Cmd>BufferMovePrevious<CR>', noremap = true, silent = true, desc = 'Move Buffer Left'},
            { '<S-Right>', '<Cmd>BufferMoveNext<CR>', noremap = true, silent = true, desc = 'Move Buffer Right'},
            { '<Leader>x', '<Cmd>BufferClose<CR>', noremap = true, silent = true, desc = 'Close Buffer'},
            -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
            -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
            -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
            -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
            -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
            --         { '<S-tab>',   '<cmd>BufferLineCyclePrev<CR>', desc = 'Buffer Goto Prev'  },
            --         { '<tab>',     '<cmd>BufferLineCycleNext<CR>', desc = 'Buffer Goto Next'  },
            --         { '<S-Left>',  '<cmd>BufferLineMovePrev<CR>',  desc = 'Move Buffer Left'  },
            --         { '<S-Right>', '<cmd>BufferLineMoveNext<CR>',  desc = 'Move Buffer Right' },
            -- stylua: ignore end
        },
    }, -- }}}

    -- Bufferline {{{
    {
        'akinsho/bufferline.nvim',
        priority = 100,
        version = '*',
        event = 'VimEnter',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                buffer_close_icon = '',
                close_icon = '',
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = 'NeoTree',
                        text_align = 'center',
                        separator = true,
                    },
                },
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
        },
        keys = {
            -- stylua: ignore start
            { '<S-tab>',        '<cmd>BufferLineCyclePrev<CR>', desc = 'Buffer Goto Prev'  },
            { '<tab>',          '<cmd>BufferLineCycleNext<CR>', desc = 'Buffer Goto Next'  },
            { '<S-Left>',       '<cmd>BufferLineMovePrev<CR>',  desc = 'Move Buffer Left'  },
            { '<S-Right>',      '<cmd>BufferLineMoveNext<CR>',  desc = 'Move Buffer Right' },
            { '<leader><Tab>r', '<cmd>BufferLineTabRename<CR>', desc = '[Tab] [R]ename' },
            -- stylua: ignore end
        },
    }, -- }}}

    -- Neoscroll {{{
    {
        'karb94/neoscroll.nvim',
        enabled = false,
        cond = function()
            return not vim.g.neovide
        end,
        event = 'VeryLazy',
        opts = {
            mappings = {
                '<C-d>',
                '<C-u>',
                '<C-b>',
                '<C-f>',
                '<C-y>',
                '<C-e>',
                'zz',
            },
            hide_cursor = false,
        },
    }, -- }}}

    -- Gitsigns {{{
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },

            on_attach = function(bufnr)
                local gitsigns = require 'gitsigns'

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { ']c', bang = true }
                    else
                        gitsigns.nav_hunk 'next'
                    end
                end, { desc = 'Jump to next git [c]hange' })

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk 'prev'
                    end
                end, { desc = 'Jump to previous git [c]hange' })

                -- Actions
                -- visual mode
                map('v', '<leader>hs', function()
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'git [s]tage hunk' })
                map('v', '<leader>hr', function()
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'git [r]eset hunk' })
                -- normal mode
                map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
                map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
                map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
                map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
                map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
                map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
                map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
                map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
                map('n', '<leader>hD', function()
                    gitsigns.diffthis '@'
                end, { desc = 'git [D]iff against last commit' })
                -- Toggles
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
                map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
            end,
        },
    }, -- }}}

    -- Noice {{{
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        cmd = { 'Noice' },
        dependencies = {
            'MunifTanjim/nui.nvim',
            {
                'rcarriga/nvim-notify',
                opts = {
                    fps = 30,
                    render = 'minimal',
                    stages = 'fade',
                },
            },
        },
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = false, -- requires hrsh7th/nvim-cmp
                },
                -- hover = {
                -- 	enabled = false,
                -- },
                -- signature = {
                --     enabled = true,
                -- },
            },
            presets = {
                -- you can enable a preset by setting it to true, or a table that will override the preset config
                -- you can also add custom presets that you can enable/disable with enabled=true
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            -- views = {
            --
            -- },
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                        },
                    },
                    view = 'mini',
                },
                {
                    filter = {
                        event = 'notify',
                        kind = 'info',
                    },
                    view = 'mini',
                },
                {
                    view = 'cmdline',
                    filter = { event = 'msg_showmode' },
                },
            },
        },
    }, -- }}}
}
