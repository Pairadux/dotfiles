local autocmd = vim.api.nvim_create_autocmd

autocmd("Filetype", {
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions:remove("o")
    end,
    desc = "Don't continue comments with o and O",
})
