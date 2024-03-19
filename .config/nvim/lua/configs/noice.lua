require("noice").setup({
	lsp = {
		signature = {
			enabled = false,
		},
		hover = {
			enabled = false,
		},
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = false,
			["vim.lsp.util.stylize_markdown"] = false,
			["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
		},
	},
	progress = {
		enabled = false,
	},
	signature = {
		enabled = false,
	},
    routes = {
        {
            view = "notify",
            filter = { event = "msg_showmode" },
        },
    },
	presets = {
		-- you can enable a preset by setting it to true, or a table that will override the preset config
		-- you can also add custom presets that you can enable/disable with enabled=true
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
})
