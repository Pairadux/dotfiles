return {

	-- CUSTOM PLUGINS {{{

	-- {
	--     "Pairadux/custom-plugin",
	--     opts = {}
	--     dev = true,
	-- },

	-- }}}

	-- NVCHAD PLUGINS {{{

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
			keys = {
				scroll_down = "<c-s-d>",
				scroll_up = "<c-s-u>",
			},
		},
	},

	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
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
			require("telescope").load_extension("ui-select")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.treesitter"),
	},

	-- }}}

	-- MY PLUGINS {{{

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
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
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
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

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

	-- {
	-- 	"sphamba/smear-cursor.nvim",
	--        enabled = false,
	-- 	-- enabled = function()
	-- 	-- 	return not vim.g.neovide
	-- 	-- end,
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		legacy_computing_symbols_support = true,
	-- 	},
	-- },

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
		"3rd/image.nvim",
        ft = "markdown",
		opts = {},
	},

	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			auto_create = false,
			allowed_dirs = {
				"~/Dev/taskcrab",
				"~/Dev/my-portfolio",
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
			max_count = 4,
			disabled_filetypes = { "markdown", "text", "txt" },
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
		},
	},

	{ "echasnovski/mini.icons", version = false },

	-- }}}
}
