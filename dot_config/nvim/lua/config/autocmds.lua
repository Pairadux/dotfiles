local autocmd = vim.api.nvim_create_autocmd

-- Remove comment "spreading" with o and O
-- autocmd('Filetype', {
--     desc = "Don't continue comments with o and O",
--     pattern = { '*' },
--     callback = function()
--         vim.opt.formatoptions:remove 'o'
--     end,
-- })


-- Open snacks picker on dir open
-- autocmd('VimEnter', {
--     callback = function()
--         local args = vim.fn.argv()
--         if #args >= 1 and vim.fn.isdirectory(args[1]) == 1 then
--             vim.schedule(function()
--                 vim.cmd 'bdelete %'
--             end)
--             require('snacks').picker.files()
--         end
--     end,
-- })

-- Configure text file specific options and mappings
autocmd('FileType', {
    pattern = { 'markdown', 'text' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.formatoptions:append 'n'
        -- local map = vim.keymap.set
        -- -- Autolist
        -- -- map({ 'i' }, '<tab>', '<cmd>AutolistTab<cr>')
        -- -- map({ 'i' }, '<s-tab>', '<cmd>AutolistShiftTab<cr>')
        -- map({ 'i' }, '<CR>', '<CR><cmd>AutolistNewBullet<cr>')
        -- map({ 'n' }, 'o', 'o<cmd>AutolistNewBullet<cr>')
        -- map({ 'n' }, 'O', 'O<cmd>AutolistNewBulletBefore<cr>')
        -- map({ 'n' }, '<CR>', '<cmd>AutolistToggleCheckbox<cr><CR>')
        -- map({ 'n' }, '<C-r>', '<cmd>AutolistRecalculate<cr>')
        -- -- { mode="i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
        -- -- cycle list types with dot-repeat
        -- -- { mode={'n'}, '<leader>cn', require('autolist').cycle_next_dr, { expr = true })
        -- -- { mode={'n'}, '<leader>cp', require('autolist').cycle_prev_dr, { expr = true })
        -- -- if you don't want dot-repeat
        -- -- { "n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
        -- -- { "n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")
        -- -- functions to recalculate list on edit
        -- map({ 'n' }, '>>', '>><cmd>AutolistRecalculate<cr>')
        -- map({ 'n' }, '<<', '<<<cmd>AutolistRecalculate<cr>')
        -- map({ 'n' }, 'dd', 'dd<cmd>AutolistRecalculate<cr>')
        -- map({ 'v' }, 'd', 'd<cmd>AutolistRecalculate<cr>')
    end,
})

-- user event that loads after UIEnter + only if file buf is there
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('NvFilePost', { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

        if not vim.g.ui_entered and args.event == 'UIEnter' then
            vim.g.ui_entered = true
        end

        if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
            vim.api.nvim_del_augroup_by_name 'NvFilePost'

            vim.schedule(function()
                vim.api.nvim_exec_autocmds('FileType', {})

                if vim.g.editorconfig then
                    require('editorconfig').config(args.buf)
                end
            end)
        end
    end,
})

-- wipe non-snacks terminals on hide
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(ev)
        if vim.bo[ev.buf].filetype ~= "snacks_terminal" then
            vim.opt_local.bufhidden = "wipe"
        end
    end,
})

-- force kill snacks terminals on quit
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "snacks_terminal" then
                vim.cmd("bwipeout! " .. buf)
            end
        end
    end,
})

autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
