---@type ChadrcConfig
local M = {}

M.base46 = {

	theme = "tokyonight",

---@diagnostic disable-next-line: missing-fields
	hl_override = {
		NvDashAscii = { fg = "#f7768e" },
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},

	transparency = false,
}

M.ui = {
	cmp = {
		icons_left = true,
        style = "default",
		format_colors = {
			tailwind = true,
		},
	},

	telescope = { style = "bordered" },

	statusline = {
		theme = "vscode_colored",
	},

	tabufline = {
		order = { "treeOffset", "buffers", "tabs" },
	},
}

M.nvdash = {
	load_on_startup = true,
	header = {
		"",
		" ██████   ▄▄▄       ██▓ ██▀███   ▄▄▄      ▓█████▄  █    ██ ▒██   ██▒",
		"▓██░  ██▒▒████▄    ▓██▒▓██ ▒ ██▒▒████▄    ▒██▀ ██▌ ██  ▓██▒▒▒ █ █ ▒░",
		"▓██░ ██▓▒▒██  ▀█▄  ▒██▒▓██ ░▄█ ▒▒██  ▀█▄  ░██   █▌▓██  ▒██░░░  █   ░",
		"▒██▄█▓▒ ▒░██▄▄▄▄██ ░██░▒██▀▀█▄  ░██▄▄▄▄██ ░▓█▄   ▌▓▓█  ░██░ ░ █ █ ▒ ",
		"▒██▒ ░  ░ ▓█   ▓██▒░██░░██▓ ▒██▒ ▓█   ▓██▒░▒████▓ ▒▒█████▓ ▒██▒ ▒██▒",
		"▒▓▒░ ░  ░ ▒▒   ▓▒█░░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░▒▓▒ ▒ ▒ ▒▒ ░ ░▓ ░",
		"░▒ ░       ▒   ▒▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ░ ▒  ▒ ░░▒░ ░ ░ ░░   ░▒ ░",
		"░░         ░   ▒    ▒ ░  ░░   ░   ░   ▒    ░ ░  ░  ░░░ ░ ░  ░    ░  ",
		"               ░  ░ ░     ░           ░  ░   ░       ░      ░    ░  ",
		"                                           ░                        ",
		"",
	},

	buttons = {
		{ txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
		{ txt = "  Todo", keys = "Spc f t", cmd = "Telescope todo-comments" },
		{ txt = "󰒲  Lazy", keys = "Spc l u", cmd = "Lazy update" },
		{ txt = "󰟾  Mason", keys = "Spc m o", cmd = "Mason" },


		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

		{
			txt = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime) .. " ms"
				return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
			end,
			hl = "NvDashFooter",
			no_gap = true,
		},

		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
	},
}

M.term = {
    sizes = { sp = 0.4, vsp = 0.3, ["bo sp"] = 0.4, ["bo vsp"] = 0.3 },
	float = {
		relative = "editor",
		row = 0.1,
		col = 0.15,
		width = 0.7,
		height = 0.7,
		border = "single",
	},
}

M.lsp = { signature = false }

M.mason = {
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
}

M.colorify = {
    enabled = true,
    mode = "bg",
}

return M
