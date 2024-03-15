local M = {}

M.ui = {
	theme = "onedark",

    statusline = {
        theme = "vscode_colored",
    },

    nvdash = {
        load_on_startup = true,
    },

    term = {
        sizes = { sp = 0.3, vsp = 0.3 },
    },
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
