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
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				background_colour = "#000000",
				render = "minimal",
			})
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					signature = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = false,
						["vim.lsp.util.stylize_markdown"] = false,
						["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
					},
				},
				progress = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
				presets = {
					-- you can enable a preset by setting it to true, or a table that will override the preset config
					-- you can also add custom presets that you can enable/disable with enabled=true
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
        init = function()
            vim.g.lsp_handlers_enabled = false
        end,
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
