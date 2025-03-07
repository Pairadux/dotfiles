local autocmd = vim.api.nvim_create_autocmd

autocmd("Filetype", {
	pattern = { "*" },
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
	desc = "Don't continue comments with o and O",
})

autocmd("VimEnter", {
	callback = function()
		local cwd = vim.fn.getcwd()
		local ok, _ = pcall(function()
			require("resession").load(cwd, { dir = "dirsession", silent = true })
		end)
		if not ok then
			vim.notify("No session found for " .. cwd, vim.log.levels.INFO)
		end
	end,
})
