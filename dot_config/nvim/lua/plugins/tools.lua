return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
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
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		opts = require("configs.obsidian"),
	},

	{
		"stevearc/resession.nvim",
		opts = {
			extensions = {
				tabufline = {},
			},
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = {
			max_count = 4,
			disabled_filetypes = { "markdown", "text", "txt", "NvimTree", "lazy", "mason", "netrw", "qf" },
		},
	},

	{
		"LintaoAmons/scratch.nvim",
		event = "VeryLazy",
		opts = {
			file_picker = "telescope",
			filetypes = {
				"txt",
				"md",
				"lua",
				"js",
				"sh",
			},
			filetype_details = {
				go = {
					requireDir = true, -- true if each scratch file requires a new directory
					filename = "main.go", -- the filename of the scratch file in the new directory
					content = { "package main", "", "func main() {", "    ", "}" },
					cursor = {
						location = { 4, 4 },
						insert_mode = true,
					},
				},
			},
		},
	},
}
