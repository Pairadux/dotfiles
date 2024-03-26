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

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"html",
				"css",
				"javascript",
				"rust",
				"svelte",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"typescript",
				"c",
				"bash",
				"python",
				"json",
			},
		},
	},

	-- lsp stuff
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"rust-analyzer",
				"css-lsp",
				"html-lsp",
				"svelte-language-server",
				"tailwindcss-language-server",
				"typescript-language-server",
				"python-lsp-server",
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
				fps = 60,
				render = "minimal",
				stages = "fade",
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
			require("configs.noice")
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
			require("configs.dashboard")
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.harpoon")
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufEnter",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/Documents/Brain 2.0/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/Documents/Brain 2.0/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		opts = {
			workspaces = {
				{
					name = "Brain 2.0",
					path = "~/Documents/Brain 2.0",
				},
			},
			daily_notes = {
				folder = "000 - Zettelkasten/050 - Daily Notes",
				date_format = "%Y-%m-%d", -- CHANGE
				template = nil, -- CHANGE
			},
			mappings = {},
			preferred_link_style = "wiki",
			templates = {
				subdir = "900 - Templates",
			},
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
