local M = {}

M.ui = {

	transparency = "true",

	statusline = { theme = "vscode_colored" },

	theme = "tokyonight",

    telescope = { style = "bordered" },

	term = {
		sizes = { sp = 0.3, vsp = 0.3 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
