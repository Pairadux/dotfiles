return {
	workspaces = {
		{
			name = "JDex",
			path = "~/Documents/SyncFolder/00-09   System/00 System Management/00.00 JDex/",
			overrides = {
				notes_subdir = "",
				templates = {
					subdir = "00.05 Templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
					substitutions = {},
				},
				daily_notes = {
					folder = "00.06 Daily Notes",
					date_format = "%Y-%m-%d",
					default_tags = { "daily" },
					template = "daily-note-template",
				},
			},
		},
		{
			name = "Atomica",
			path = "~/Documents/SyncFolder/90-99 󰝨  Atomica/",
			overrides = {
				notes_subdir = "",
				templates = {
					subdir = "templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
					substitutions = {},
				},
				daily_notes = {
					folder = "daily/",
					date_format = "%Y-%m-%d",
					default_tags = { "daily" },
					template = "daily-note-template",
				},
			},
		},
	},

	notes_subdir = "",

	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},

	new_notes_location = "notes_subdir",

	mappings = {
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		["<leader>ch"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
		["<leader>oq"] = {
			action = function()
				vim.cmd("ObsidianQuickSwitch")
			end,
			opts = {
				desc = "[O]bsidian Open [Q]uick Switcher",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>od"] = {
			action = function()
				vim.cmd("ObsidianToday")
			end,
			opts = {
				desc = "[O]bsidian Open [D]aily",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>oit"] = {
			action = function()
				vim.cmd("ObsidianTemplate")
			end,
			opts = {
				desc = "[O]bsidian [I]nsert [T]emplate",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>or"] = {
			action = function()
				vim.cmd("ObsidianRename")
			end,
			opts = {
				desc = "[O]bsidian [R]ename",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>on"] = {
			action = function()
				vim.cmd("ObsidianNew")
			end,
			opts = {
				desc = "[O]bsidian Create [N]ew Note",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>os"] = {
			action = function()
				vim.cmd("ObsidianSearch")
			end,
			opts = {
				desc = "[O]bsidian [S]earch",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>ot"] = {
			action = function()
				vim.cmd("ObsidianTags")
			end,
			opts = {
				desc = "[O]bsidian [T]ags",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>ol"] = {
			action = function()
				vim.cmd("ObsidianLinks")
			end,
			opts = {
				desc = "[O]bsidian [L]inks Picker",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
		["<leader>ont"] = {
			action = function()
				vim.cmd("ObsidianNewFromTemplate")
			end,
			opts = {
				desc = "[O]bsidian [N]ew From [T]emplates",
                buffer = true,
				noremap = true,
				silent = true,
			},
		},
	},

	---@param title string|?
	---@return string
	note_id_func = function(title)
		if title ~= nil then
			return title
		else
			return tostring(os.date("%Y-%m-%d-%H-%M"))
		end
	end,

	wiki_link_func = "use_alias_only",

	preferred_link_style = "wiki",
	disable_frontmatter = true,

	-- ---@return table
	-- note_frontmatter_func = function(note)
	-- 	local jdIndex
	--
	-- 	if note.path then
	-- 		local path_str = tostring(note.path)
	-- 		local filename = path_str:match("([^/]+)%.md$")
	-- 		if filename then
	-- 			jdIndex = tonumber(filename:match("^%d%d%.%d%d"))
	-- 		end
	-- 	end
	--
	-- 	jdIndex = jdIndex or 0
	--
	-- 	local out = { tags = note.tags, jdIndex = jdIndex }
	--
	-- 	if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
	-- 		for k, v in pairs(note.metadata) do
	-- 			out[k] = v
	-- 		end
	-- 	end
	--
	-- 	return out
	-- end,
}
