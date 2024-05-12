require("obsidian").setup({
	workspaces = {
        -- {
        --     name = "Brain-2.0",
        --     path = "~/Documents/Brain 2.0/"
        -- },
        {
            name = "Brain-2.0",
            path = "~/Brain 2.0/"
        }
	},
	notes_subdir = "000 - Zettelkasten/010 - Fleeting",
	daily_notes = {
		folder = "000 - Zettelkasten/050 - Daily Notes",
		date_format = "%m-%d-%Y",
		template = "900 - Templates/daily-note-template.md",
	},
	mappings = {},
	new_notes_location = "notes_subdir",

	note_id_func = function(title)
		if title ~= nil then
			return title
		else
			return tostring(os.date("%m-%d-%Y-%H-%M"))
		end
	end,

	preferred_link_style = "wiki",
	disable_frontmatter = false,

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
		subdir = "900 - Templates",
	},
})
-- TODO: Make wikilinks with aliases function correctly
