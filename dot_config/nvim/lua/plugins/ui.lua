return {

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		cmd = { "Noice" },
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					fps = 30,
					render = "minimal",
					stages = "fade",
				},
			},
		},
		opts = require("configs.noice"),
	},

	{
		"karb94/neoscroll.nvim",
		enabled = function()
			return not vim.g.neovide
		end,
		event = "VeryLazy",
		opts = {
			mappings = {
				"<C-d>",
				"<C-u>",
				"<C-b>",
				"<C-f>",
				"<C-y>",
				"<C-e>",
				"zz",
			},
			hide_cursor = false,
		},
	},

	{
		"3rd/image.nvim",
		enabled = function()
			return not vim.g.neovide
		end,
		ft = "markdown",
		opts = {},
	},

	{ "echasnovski/mini.icons", version = false },
}
