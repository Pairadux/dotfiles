return {

	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = {
				enable = true,
				ignore = true,
			},
			renderer = {
				highlight_git = true,
				icons = {
					show = {
						git = true,
					},
				},
			},
		},
	},

	-- In order to modify the `lspconfig` configuration:
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},

	{
		"MunifTanjim/nui.nvim",
		lazy = false,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			trigger_events = {
				immediate_save = {
					{ "BufLeave", "FocusLost" },
				},
				defer_save = {},
				cancel_defer_save = {},
			},
		},
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					header = {
						"",
						"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
						"⣿⣏⣛⡛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⢛⣛⣿⣿",
						"⣿⣿⡏⠛⠛⠻⠶⠶⣶⣤⣤⣤⣭⣭⣭⣭⣭⣭⣤⣤⣤⣶⠶⠶⠟⠛⠛⣹⣿⣿",
						"⣿⣿⣿⣤⣤⣤⣄⣀⣀⣀⣀⣀⣈⣉⣉⣉⣉⣁⣀⣀⣀⣀⣀⣀⣤⣤⣴⣿⣿⣿",
						"⣿⣿⣿⣿⣿⠉⠉⠉⣿⣿⣿⣿⣿⣿⠃⠘⣿⣿⣿⣿⣿⣿⠉⠉⠉⣿⣿⣿⣿⣿",
						"⣿⣿⣿⠛⣿⠀⠀⠀⣿⠛⠛⠛⠻⠿⠤⠤⠿⠟⠛⠛⠛⣿⠀⠀⠀⣿⠛⣿⣿⣿",
						"⣿⣿⣿⣶⣿⠀⠀⠀⣿⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⠀⠀⠀⣿⣶⣿⣿⣿",
						"⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿",
						"⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿",
						"⣿⣧⠀⣿⣿⠀⠀⠀⣿⣿⡄⣼⣿⣿⣿⣿⣿⣿⣧⢠⣿⣿⠀⠀⠀⣿⣿⠀⣼⣿",
						"⣿⡟⠀⠛⠛⠀⠀⠀⠛⠛⠃⢻⣿⣿⣿⣿⣿⣿⡟⠘⠛⠛⠀⠀⠀⠛⠛⠀⢻⣿",
						"⣿⣿⠀⣿⣿⠀⠀⠀⣿⣿⡇⣾⣿⣿⣿⣿⣿⣿⣷⢸⣿⣿⠀⠀⠀⣿⣿⠀⣿⣿",
						"⣿⣿⠀⣿⣿⠀⠀⠀⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⠀⠀⠀⣿⣿⠀⣿⣿",
						"⣿⣧⠀⣭⣭⠀⠀⠀⣭⣭⡄⣸⣿⣿⣿⣿⣿⣿⣇⢠⣭⣭⠀⠀⠀⣭⣭⠀⣼⣿",
						"⣿⣿⣤⣿⣿⣶⣶⣶⣿⣿⣧⣿⣿⣿⣿⣿⣿⣿⣿⣼⣿⣿⣶⣶⣶⣿⣿⣤⣿⣿",
						"",
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							icon = "󱊈 ",
							icon_hl = "@property",
							desc = "Mason",
							action = "Mason",
							key = "m",
						},
					},
					mru = {
						cwd_only = true,
					},
					footer = {},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
