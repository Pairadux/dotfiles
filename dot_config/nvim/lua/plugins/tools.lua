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
		keys = {
			{
				"<leader>ss",
				function()
					local cwd = vim.fn.getcwd()
					require("resession").save(cwd, { dir = "dirsession", notify = true })
				end,
				desc = "[S]ession [S]ave",
			},
			{
				"<leader>sl",
				function()
					require("resession").load()
				end,
				desc = "[S]ession [L]oad",
			},
			{
				"<leader>st",
				function()
					require("resession").save_tab()
				end,
				desc = "[S]ession Save [T]ab",
			},
		},
		opts = {
			extensions = {
				tabufline = {},
			},
		},
	},

	{
		"christoomey/vim-tmux-navigator",
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Tmux Window Left"},
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Tmux Window Right"},
            { "<C-A-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Tmux Window Down"},
            { "<C-A-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Tmux Window Up"},
        },
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
        keys = {
            { "<leader>sn", "<cmd>Scratch<CR>", desc="[S]cratch [N]ew", noremap = true, silent = true},
            { "<leader>sw", "<cmd>ScratchWithName<CR>", desc="[S]cratch [W]ith Name", noremap = true, silent = true},
            { "<leader>so", "<cmd>ScratchOpen<CR>", desc="[S]cratch [O]pen", noremap = true, silent = true},
        },
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
