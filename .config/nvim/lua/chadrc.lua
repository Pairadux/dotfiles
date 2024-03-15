local M = {}

M.ui = {
	theme = "onedark",

    statusline = {
        theme = "vscode_colored",
    },

    nvdash = {
        load_on_startup = true,
    },
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
