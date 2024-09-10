local M = {}

M.ui = {

	hl_add = {
		DashboardHeader = { fg = "#f7768e", bg = "NONE" },
	},

	-- transparency = "true",

	statusline = { theme = "vscode_colored" },

	theme = "tokyonight",

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},

	telescope = { style = "bordered" },

	tabufline = {
		order = { "treeOffset", "buffers", "tabs" },
	},

	term = {
		float = {
			relative = "editor",
			row = 0.1,
			col = 0.15,
			width = 0.7,
			height = 0.7,
			border = "single",
		},
	},

	mason = {
		pkgs = {
			"lua-language-server",
			"stylua",
			"rust-analyzer",
			"css-lsp",
			"html-lsp",
			"svelte-language-server",
			"tailwindcss-language-server",
			"typescript-language-server",
			"python-lsp-server",
			"bash-language-server",
			"marksman",
			"pyright",
			"ruff",
			"clangd",
			"clang-format",
		},
	},
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
