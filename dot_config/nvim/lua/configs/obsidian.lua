return {
	workspaces = {
		{
			name = "SyncFolder",
			path = "~/Documents/SyncFolder/",
		},
		{
			name = "Brain 2.0",
			path = "~/Documents/SyncFolder/90-99 Brain 2.0 (o--)",

			strict = true,
			overrides = {
				notes_subdir = "./",
				new_notes_location = "notes_subdir",
			},
		},
	},
	notes_subdir = "90-99 Brain 2.0 (o--)/",

	daily_notes = {
		folder = "91 Zettelkasten/050 - Daily Notes",
		date_format = "%Y-%m-%d",
		default_tags = { "daily-note" },
		template = "00-09 System/05 Templates (ot-)/daily-note-template.md",
	},

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
		-- Add the title of the note as an alias.
		-- if note.title then
		-- 	note:add_alias(note.title)
		-- end

		local out = { id = note.id, aliases = note.aliases, tags = note.tags }

		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				out[k] = v
			end
		end

		return out
	end,

	templates = {
		subdir = "00-09 System/05 Templates (ot-)",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		-- A map for custom variables, the key should be the variable and the value a function
		substitutions = {},
	},
}
