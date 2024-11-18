return {
	window = {
		backdrop = 0.95,
		width = 120,
		height = 1,
		-- by default, no options are changed for the Zen window
		-- uncomment any of the options below, or add other vim.wo options you want to apply
		options = {
			wrap = true,
			linebreak = true,
			spell = true,
			conceallevel = 1,
			-- signcolumn = "no", -- disable signcolumn
			-- number = false, -- disable number column
			-- relativenumber = false, -- disable relative numbers
			-- cursorline = false, -- disable cursorline
			-- cursorcolumn = false, -- disable cursor column
			-- foldcolumn = "0", -- disable fold column
			-- list = false, -- disable whitespace characters
		},
	},
	plugins = {
		options = {
			enabled = true,
			ruler = false,
			showcmd = false,
			laststatus = 0,
		},
		twilight = { enabled = true },
		gitsigns = { enabled = false },
		tmux = { enabled = false },
		todo = { enabled = false },
		wezterm = {
			enabled = true,
			font = "+2",
		},
	},

	-- -- callback where you can add custom code when the Zen window opens
	-- on_open = function(win) end,
	-- -- callback where you can add custom code when the Zen window closes
	-- on_close = function() end,
}
