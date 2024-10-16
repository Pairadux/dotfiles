return {

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
		opts = require("configs.treesitter")
	},

	-- lsp stuff
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "single",
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
        opts = {},
	},

	{
		"MunifTanjim/nui.nvim",
		event = "VeryLazy",
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = require("configs.telescope"),
        config = function (_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("project")
            require("telescope").load_extension("ui-select")
        end,
	},

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
		"folke/noice.nvim",
		event = "VeryLazy",
        cmd = { "Noice" },
        opts = require("configs.noice"),
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
		              opts = {
		                  -- background_colour = "#000000",
		                  fps = 60,
		                  render = "minimal",
		                  stages = "fade",
		              }
			},
		},
		-- init = function()
		-- 	vim.g.lsp_handlers_enabled = false
		-- end,
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
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

	{ -- optional completion source for require statements and module annotations
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},

	-- {
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^4", -- Recommended
	-- 	ft = { "rust" },
	-- },

	-- {
	-- 	"nvimdev/dashboard-nvim",
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		require("configs.dashboard")
	-- 	end,
	-- 	dependencies = { { "nvim-tree/nvim-web-devicons" } },
    --
	-- },

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
        opts = require("configs.obsidian")
	},

	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
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
		opts = {},
	},

	{ "echasnovski/mini.icons", version = false },
}
