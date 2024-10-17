local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set

map("n", "<leader>a", function()
    vim.cmd.RustLsp('codeAction')
end, { silent = true, buffer = bufnr })
