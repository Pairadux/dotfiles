return {

	-- ######################################## Custom Plugins ########################################

	-- {
	--     "AustinCGause/custom-plugin",
	--     opts = {}
	--     dev = true,
	-- },

	-- ######################################## Nvchad Plugins ########################################

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = {
				enable = true,
				ignore = true,
			},
			filters = {
				dotfiles = true,
				git_ignored = true,
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
	},

	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},

	-- TODO: add gitsigns

	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "single",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{ -- optional completion source for require statements and module annotations: lazydev
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = require("configs.telescope"),
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("project")
			require("telescope").load_extension("ui-select")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.treesitter"),
	},

	-- ######################################## My Plugins ########################################

	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	dependencies = {
	-- 		"rcarriga/nvim-dap-ui",
	-- 		"nvim-neotest/nvim-nio",
	-- 		"williamboman/mason.nvim",
	-- 		"jay-babu/mason-nvim-dap.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("configs.dap")
	-- 	end,
	-- },

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		"nvim-telescope/telescope-project.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},

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
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				"nvim-dap-ui",
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

	-- TODO: review additional notes on rustaceanvim
	-- https://github.com/mrcjkb/rustaceanvim
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufEnter",
		opts = {},
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		cmd = { "ObsidianNew", "ObsidianSearch", "ObsidianToday", "ObsidianQuickSwitch" },
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		config = function()
			require("configs.obsidian")
		end,
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
		"tpope/vim-obsession",
		event = "VeryLazy",
		config = function()
			vim.cmd("silent! helptags ALL")
		end,
	},

	{
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		opts = require("configs.zenmode"),
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
			disabled_filetypes = { "markdown", "text", "txt" },
		},
	},

	{ "echasnovski/mini.icons", version = false },
}
