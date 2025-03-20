return {

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
		opts = {
			lsp_fallback = true,

			formatters_by_ft = {
				lua = { "stylua" },

				javascript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				svelte = { "prettier" },

				python = { "ruff" },

				c = { "clang-format" },
				cpp = { "clang-format" },

				markdown = { "prettier" },

				sh = { "shfmt" },

				yaml = { "prettier" },
			},

			-- format_on_save = {
			-- 	-- These options will be passed to conform.format()
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = true,
			-- },
		},
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
		opts = {
			defaults = {
				initial_mode = "insert",
				file_ignore_patterns = { ".git/" },
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = {
				project = {
					base_dirs = {
						"~/Dev/",
					},
					hidden_files = true,
					on_project_selected = function(prompt_bufnr)
						local project_actions = require("telescope._extensions.project.actions")
						project_actions.change_working_directory(prompt_bufnr, false)

						vim.defer_fn(function()
							require("telescope.builtin").find_files()
						end, 50)
					end,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("ui-select")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"gitignore",
				"hocon",
				"html",
				"ini",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"rasi",
				"regex",
				"rust",
				"svelte",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
			},
		},
	},
}
