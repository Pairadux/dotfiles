return {
	defaults = { lazy = true },

    dev = {
        path = "~/Dev/",
        patterns = {
            "Pairadux",
        }
    },

	install = { colorscheme = { "nvchad" } },

	ui = {
		border = "single",
        backdrop = 100,
		icons = {
			ft = "",
			lazy = "󰂠 ",
			loaded = "",
			not_loaded = "",
		},
	},

	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"ftplugin",
			},
		},
	},
}
