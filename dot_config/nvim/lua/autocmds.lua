local autocmd = vim.api.nvim_create_autocmd

autocmd("Filetype", {
	pattern = { "*" },
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
	desc = "Don't continue comments with o and O",
})

local function setup_resession_hooks()
	local resession = require("resession")

	resession.add_hook("post_load", function()
		vim.o.showtabline = 2
		vim.cmd("redraw!")
	end)
end

-- Set up hooks as early as possible
vim.defer_fn(function()
	pcall(setup_resession_hooks)
end, 0)

autocmd("VimEnter", {
	callback = function()
		vim.o.showtabline = 0

		local cwd = vim.fn.getcwd()
		local ok, _ = pcall(function()
			require("resession").load(cwd, { dir = "dirsession", silent = true })
		end)

		if not ok then
			vim.notify("No session found for " .. cwd, vim.log.levels.INFO)
			vim.o.showtabline = 1
			vim.cmd("redraw!")
		end
	end,
})

autocmd("FileType", {
    pattern = "markdown",
    callback = function ()
        -- Insert mode
        vim.api.nvim_buf_set_keymap(0, 'i', '<Tab>', '<C-t>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
    end
})
