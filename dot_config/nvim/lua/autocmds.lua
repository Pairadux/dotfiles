local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

autocmd('Filetype', {
    pattern = { '*' },
    callback = function()
        vim.opt.formatoptions:remove 'o'
    end,
    desc = "Don't continue comments with o and O",
})

autocmd('VimEnter', {
    callback = function()
        local cwd = vim.fn.getcwd()
        local ok, _ = pcall(function()
            require('resession').load(cwd, { dir = 'dirsession', silent = true })
        end)

        if not ok then
            vim.notify('No session found for ' .. cwd, vim.log.levels.INFO)
        end
    end,
})

autocmd('FileType', {
    pattern = { 'markdown', 'text' },
    callback = function()
        vim.opt_local.spell = true
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
