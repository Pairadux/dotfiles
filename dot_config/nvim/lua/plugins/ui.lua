--[[
    ui.lua
    -------
    This file is for plugins that affect the user interface.
    Include plugins that enhance visual components, layout adjustments, and overall UI improvements.
]]

return {

    {
        'Pairadux/platter.nvim',
        cond = false,
        dev = true,
        event = 'VimEnter',
        opts = {},
    },

    {
        'nanozuki/tabby.nvim',
        lazy = false,
        opts = {
            line = function(line)
                local theme = {
                    fill = 'TabLineFill',
                    head = 'PMenuSel',
                    current_tab = 'TabLineSel',
                    tab = 'PMenuSel',
                    win = 'PMenuSel',
                    tail = 'PMenuSel',
                }
                return {
                    {
                        { ' ', hl = theme.head },
                        line.sep('', theme.head, theme.fill),
                    },
                    line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current_tab or theme.tab
                        return {
                            line.sep('', hl, theme.fill),
                            tab.is_current() and '' or '󰆣',
                            tab.number(),
                            tab.name(),
                            tab.close_btn '',
                            line.sep('', hl, theme.fill),
                            hl = hl,
                            margin = ' ',
                        }
                    end),
                    line.spacer(),
                    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                        return {
                            line.sep('', theme.win, theme.fill),
                            win.is_current() and '' or '',
                            win.buf_name(),
                            line.sep('', theme.win, theme.fill),
                            hl = theme.win,
                            margin = ' ',
                        }
                    end),
                    {
                        line.sep('', theme.tail, theme.fill),
                        { ' ', hl = theme.tail },
                    },
                    hl = theme.fill,
                }
            end,
        },
        keys = {
            { '<S-Tab>', '<cmd>bprev<CR>', desc = 'Buffer Goto Prev' },
            { '<Tab>', '<cmd>bnext<CR>', desc = 'Buffer Goto Next' },
            {
                '<leader><Tab>r',
                function()
                    local name = vim.fn.input '  New tab name: '
                    require('tabby').tab_rename(name)
                end,
                desc = '[Tab] [R]ename',
            },
        },
    },

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
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
            },
        },
    }, -- }}}

    -- Bufferline {{{
    {
        'akinsho/bufferline.nvim',
        cond = false,
        priority = 100,
        version = '*',
        lazy = false,
        -- event = 'VimEnter',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                mode = 'tabs',
                indicator = {
                    style = 'underline',
                },
                offsets = {
                    -- {
                    --     filetype = 'neo-tree',
                    --     text = 'NeoTree',
                    --     text_align = 'center',
                    --     separator = true,
                    -- },
                },
                show_buffer_close_icons = false,
                show_close_icon = false,
                -- persist_buffer_sort = true,
                move_wraps_at_ends = true,
                separator_style = { '', '' },
            },
        },
        keys = {
            -- stylua: ignore start
            { '<S-tab>',        '<cmd>BufferLineCyclePrev<CR>', desc = 'Buffer Goto Prev'  },
            { '<tab>',          '<cmd>BufferLineCycleNext<CR>', desc = 'Buffer Goto Next'  },
            -- { '<S-Left>',       '<cmd>BufferLineMovePrev<CR>',  desc = 'Move Buffer Left'  },
            -- { '<S-Right>',      '<cmd>BufferLineMoveNext<CR>',  desc = 'Move Buffer Right' },
            -- { '<leader><Tab>r', '<cmd>BufferLineTabRename<CR>', desc = '[Tab] [R]ename' },
            -- stylua: ignore end
        },
    }, -- }}}

    -- Neoscroll {{{
    {
        'karb94/neoscroll.nvim',
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
                map('v', '<leader>Hs', function()
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'git [s]tage hunk' })
                map('v', '<leader>Hr', function()
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'git [r]eset hunk' })
                -- normal mode
                map('n', '<leader>Hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
                map('n', '<leader>Hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
                map('n', '<leader>HS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
                map('n', '<leader>Hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
                map('n', '<leader>HR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
                map('n', '<leader>Hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
                map('n', '<leader>Hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
                map('n', '<leader>Hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
                map('n', '<leader>HD', function()
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
