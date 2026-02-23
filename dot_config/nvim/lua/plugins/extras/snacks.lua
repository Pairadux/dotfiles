--[[
    extras/snacks.lua
    ------------------
    This file is for snacks.nvim
]]

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = false },
        dashboard = {
            preset = {
                keys = {
                    { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = ' ', key = 'e', desc = 'Empty Buffer', action = ':enew | startinsert' },
                    { icon = '󰁴 ', key = 'o', desc = 'Open Oil', action = ':Oil --preview' },
                    { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
                    { icon = '󰟾 ', key = 'M', desc = 'Mason', action = ':Mason', enabled = package.loaded.lazy ~= nil },
                    { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
                },
                header = [[
 ██████   ▄▄▄       ██▓ ██▀███   ▄▄▄      ▓█████▄  █    ██ ▒██   ██▒
▓██░  ██▒▒████▄    ▓██▒▓██ ▒ ██▒▒████▄    ▒██▀ ██▌ ██  ▓██▒▒▒ █ █ ▒░
▓██░ ██▓▒▒██  ▀█▄  ▒██▒▓██ ░▄█ ▒▒██  ▀█▄  ░██   █▌▓██  ▒██░░░  █   ░
▒██▄█▓▒ ▒░██▄▄▄▄██ ░██░▒██▀▀█▄  ░██▄▄▄▄██ ░▓█▄   ▌▓▓█  ░██░ ░ █ █ ▒
▒██▒ ░  ░ ▓█   ▓██▒░██░░██▓ ▒██▒ ▓█   ▓██▒░▒████▓ ▒▒█████▓ ▒██▒ ▒██▒
▒▓▒░ ░  ░ ▒▒   ▓▒█░░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░▒▓▒ ▒ ▒ ▒▒ ░ ░▓ ░
░▒ ░       ▒   ▒▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ░ ▒  ▒ ░░▒░ ░ ░ ░░   ░▒ ░
░░         ░   ▒    ▒ ░  ░░   ░   ░   ▒    ░ ░  ░  ░░░ ░ ░  ░    ░
               ░  ░ ░     ░           ░  ░   ░       ░      ░    ░
                                           ░                        ]],
            },
        },
        explorer = { enabled = false },
        image = { enabled = true },
        indent = { enabled = false },
        input = { enabled = false },
        lazygit = { enabled = true },
        picker = {
            enabled = true,
            show_delay = 0,
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-q>'] = { 'close', mode = { 'n', 'i' } },
                    },
                },
            },
        },
        notifier = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = true },
        scratch = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = true },
        terminal = { enabled = true },
        zen = {
            win = {
                backdrop = {
                    transparent = false,
                },
            },
        },
        styles = {
            dashboard = {
                wo = {
                    fillchars = 'eob: ',
                },
            },
        },
    },
    keys = {
        -- Top Pickers & Explorer
        -- stylua: ignore start
        { '<leader>ff', function() require('snacks').picker.files()                                   end, desc = '[F]ind [F]iles', },
        { '<leader>fs', function() require('snacks').picker.smart()                                   end, desc = '[F]ind [S]mart' },
        { '<leader>fb', function() require('snacks').picker.buffers({ current = false, matcher = { frecency = true, sort_empty = true } }) end, desc = '[F]ind [B]uffers', },
        { '<C-p>',      function() require('snacks').picker.smart()                                   end, desc = 'Smart Picker', },
        { '<leader>fr', function() require('snacks').picker.recent()                                  end, desc = '[F]ind [R]ecent', },
        { '<leader>fg', function() require('snacks').picker.grep()                                    end, desc = '[F]ind [G]rep', },
        { '<leader>fm', function() require('snacks').picker.files { ft = 'md' }                       end, desc = '[F]ind [M]arkdown', },
        { '<leader>ii', function() require('snacks').picker.icons { layout = { preset = 'default' } } end, desc = '[I]nsert [I]cons', },
        { '<leader>fh', function() require('snacks').picker.highlights()                              end, desc = '[F]ind [H]ighlights', },
        -- Other
        { '<C-c>',       function() require('snacks').bufdelete()                                      end, desc = 'Buffer Close', },
        { '<leader>.',   function() require('snacks').scratch()                                        end, desc = 'Scratch', },
        { '<leader>os',  function() require('snacks').scratch.select()                                 end, desc = '[O]pen [S]cratch selector', },
        { '<leader>cr',  function() require('snacks').rename.rename_file()                             end, desc = '[C]urrent [R]ename', },
        { '<leader>gg',  function() require('snacks').lazygit()                                        end, desc = '[G]it [G]UI', },
        { 'gd',          function() require("snacks").picker.lsp_definitions()                         end, desc = 'Goto Definition', },
        { ']]',          function() require('snacks').words.jump(vim.v.count1)                         end, desc = 'Next Reference', mode = { 'n', 't' }, },
        { '[[',          function() require('snacks').words.jump(-vim.v.count1)                        end, desc = 'Prev Reference', mode = { 'n', 't' }, },
        { '<leader>oz',  function() require('snacks').zen()                                            end, desc = '[O]pen [Z]en', },
        { 'gZ',          function() require('snacks').zen.zoom()                                       end, desc = '[Z]oom', },
        -- stylua: ignore end
        {
            '<A-i>',
            function()
                require('snacks.terminal').toggle(vim.o.shell, { win = { border = 'single', title = 'Terminal' } })
            end,
            desc = 'Toggle Terminal',
            mode = { 'n', 't' },
        },
        -- Git {{{
        -- TODO: add some of these to a nested "git" section
        -- {
        --     '<leader>gb',
        --     function()
        --         require("snacks").picker.git_branches()
        --     end,
        --     desc = 'Git Branches',
        -- },
        -- { '<leader>gB', function() require("snacks").gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' }, },
        -- {
        --     '<leader>gl',
        --     function()
        --         require("snacks").picker.git_log()
        --     end,
        --     desc = 'Git Log',
        -- },
        -- {
        --     '<leader>gL',
        --     function()
        --         require("snacks").picker.git_log_line()
        --     end,
        --     desc = 'Git Log Line',
        -- },
        -- {
        --     '<leader>gs',
        --     function()
        --         require("snacks").picker.git_status()
        --     end,
        --     desc = 'Git Status',
        -- },
        -- {
        --     '<leader>gS',
        --     function()
        --         require("snacks").picker.git_stash()
        --     end,
        --     desc = 'Git Stash',
        -- },
        -- {
        --     '<leader>gd',
        --     function()
        --         require("snacks").picker.git_diff()
        --     end,
        --     desc = 'Git Diff (Hunks)',
        -- },
        -- {
        --     '<leader>gf',
        --     function()
        --         require("snacks").picker.git_log_file()
        --     end,
        --     desc = 'Git Log File',
        -- },}}}
        -- Grep {{{
        -- {
        --     '<leader>sb',
        --     function()
        --         require("snacks").picker.lines()
        --     end,
        --     desc = 'Buffer Lines',
        -- },
        -- {
        --     '<leader>sB',
        --     function()
        --         require("snacks").picker.grep_buffers()
        --     end,
        --     desc = 'Grep Open Buffers',
        -- },
        -- {
        --     '<leader>sw',
        --     function()
        --         require("snacks").picker.grep_word()
        --     end,
        --     desc = 'Visual selection or word',
        --     mode = { 'n', 'x' },
        -- },}}}
        -- Search {{{
        -- TODO: add some of these to a nested "other/extra" section
        -- {
        --     '<leader>s"',
        --     function()
        --         require("snacks").picker.registers()
        --     end,
        --     desc = 'Registers',
        -- },
        -- {
        --     '<leader>s/',
        --     function()
        --         require("snacks").picker.search_history()
        --     end,
        --     desc = 'Search History',
        -- },
        -- {
        --     '<leader>sa',
        --     function()
        --         require("snacks").picker.autocmds()
        --     end,
        --     desc = 'Autocmds',
        -- },
        -- {
        --     '<leader>sb',
        --     function()
        --         require("snacks").picker.lines()
        --     end,
        --     desc = 'Buffer Lines',
        -- },
        -- {
        --     '<leader>sc',
        --     function()
        --         require("snacks").picker.command_history()
        --     end,
        --     desc = 'Command History',
        -- },
        -- {
        --     '<leader>sC',
        --     function()
        --         require("snacks").picker.commands()
        --     end,
        --     desc = 'Commands',
        -- },
        -- {
        --     '<leader>sd',
        --     function()
        --         require("snacks").picker.diagnostics()
        --     end,
        --     desc = 'Diagnostics',
        -- },
        -- {
        --     '<leader>sD',
        --     function()
        --         require("snacks").picker.diagnostics_buffer()
        --     end,
        --     desc = 'Buffer Diagnostics',
        -- },
        -- {
        --     '<leader>sh',
        --     function()
        --         require("snacks").picker.help()
        --     end,
        --     desc = 'Help Pages',
        -- },
        -- {
        --     '<leader>sj',
        --     function()
        --         require("snacks").picker.jumps()
        --     end,
        --     desc = 'Jumps',
        -- },
        -- {
        --     '<leader>sk',
        --     function()
        --         require("snacks").picker.keymaps()
        --     end,
        --     desc = 'Keymaps',
        -- },
        -- {
        --     '<leader>sl',
        --     function()
        --         require("snacks").picker.loclist()
        --     end,
        --     desc = 'Location List',
        -- },
        -- {
        --     '<leader>sm',
        --     function()
        --         require("snacks").picker.marks()
        --     end,
        --     desc = 'Marks',
        -- },
        -- {
        --     '<leader>sM',
        --     function()
        --         require("snacks").picker.man()
        --     end,
        --     desc = 'Man Pages',
        -- },
        -- {
        --     '<leader>sp',
        --     function()
        --         require("snacks").picker.lazy()
        --     end,
        --     desc = 'Search for Plugin Spec',
        -- },
        -- {
        --     '<leader>sq',
        --     function()
        --         require("snacks").picker.qflist()
        --     end,
        --     desc = 'Quickfix List',
        -- },
        -- {
        --     '<leader>sR',
        --     function()
        --         require("snacks").picker.resume()
        --     end,
        --     desc = 'Resume',
        -- },
        -- {
        --     '<leader>su',
        --     function()
        --         require("snacks").picker.undo()
        --     end,
        --     desc = 'Undo History',
        -- },
        -- {
        --     '<leader>uC',
        --     function()
        --         require("snacks").picker.colorschemes()
        --     end,
        --     desc = 'Colorschemes',
        -- },
        -- -- LSP
        -- {
        --     'gD',
        --     function()
        --         require("snacks").picker.lsp_declarations()
        --     end,
        --     desc = 'Goto Declaration',
        -- },
        -- {
        --     'gr',
        --     function()
        --         require("snacks").picker.lsp_references()
        --     end,
        --     nowait = true,
        --     desc = 'References',
        -- },
        -- {
        --     'gI',
        --     function()
        --         require("snacks").picker.lsp_implementations()
        --     end,
        --     desc = 'Goto Implementation',
        -- },
        -- {
        --     'gy',
        --     function()
        --         require("snacks").picker.lsp_type_definitions()
        --     end,
        --     desc = 'Goto T[y]pe Definition',
        -- },
        -- {
        --     '<leader>ss',
        --     function()
        --         require("snacks").picker.lsp_symbols()
        --     end,
        --     desc = 'LSP Symbols',
        -- },
        -- {
        --     '<leader>sS',
        --     function()
        --         require("snacks").picker.lsp_workspace_symbols()
        --     end,
        --     desc = 'LSP Workspace Symbols',
        -- },}}}
    },
}
