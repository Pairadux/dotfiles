local options = {
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
	},

	-- format_on_save = {
	-- 	-- These options will be passed to conform.format()
	-- 	timeout_ms = 500,
	-- 	lsp_fallback = true,
	-- },
}

require("conform").setup(options)
