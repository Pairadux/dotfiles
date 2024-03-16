local M = {}

M.ui = {
	theme = "tokyonight",

	transparency = "true",

	statusline = {
		theme = "vscode_colored",
	},

	term = {
		sizes = { sp = 0.3, vsp = 0.3 },
	},
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
