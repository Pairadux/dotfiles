return {

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufEnter",
		opts = {},
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			char = {
				char_actions = function()
					return {
						[";"] = "next", -- set to `right` to always go right
						[","] = "prev", -- set to `left` to always go left
						-- -- clever-f style
						-- [motion:lower()] = "next",
						-- [motion:upper()] = "prev",
					}
				end,
			},
		},
		keys = {
			{
				"s",
				function()
					require("flash").jump()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash",
			},
			{
				"S",
				function()
					require("flash").treesitter()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash Treesitter",
			},
			{
				"r",
				function()
					require("flash").remote()
				end,
				mode = "o",
				desc = "Remote Flash",
			},
			{
				"R",
				function()
					require("flash").treesitter_search()
				end,
				mode = { "o", "x" },
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				function()
					require("flash").toggle()
				end,
				mode = { "c" },
				desc = "Toggle Flash Search",
			},
		},
	},
}
