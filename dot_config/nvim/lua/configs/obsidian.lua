return {
	workspaces = {
		{
			name = "SyncFolder",
			path = "~/Documents/SyncFolder/",
		},
	},

	notes_subdir = "90-99   Brain 2.0",

	-- daily_notes = {
	-- 	folder = "",
	-- 	date_format = "%Y-%m-%d",
	-- 	default_tags = { "daily-note" },
	-- 	template = "00-09 System/05 Templates/daily-note-template.md",
	-- },

	new_notes_location = "current_dir",

	---@param title string|?
	---@return string
	note_id_func = function(title)
		if title ~= nil then
			return title
		else
			return tostring(os.date("%Y-%m-%d-%H-%M"))
		end
	end,

	preferred_link_style = "wiki",
	disable_frontmatter = false,

	---@return table
	note_frontmatter_func = function(note)
		local jdIndex

		if note.path then
			local path_str = tostring(note.path)
			local filename = path_str:match("([^/]+)%.md$")
			if filename then
				jdIndex = tonumber(filename:match("^%d%d%.%d%d"))
			end
		end

		jdIndex = jdIndex or 0

		local out = { jdIndex = jdIndex, tags = note.tags }

		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				out[k] = v
			end
		end

		return out
	end,

	templates = {
		subdir = "00-09   System/00 System Management/00.05 Templates",

		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		-- A map for custom variables, the key should be the variable and the value a function
		substitutions = {},
	},
}
