return {
	defaults = {
		initial_mode = "insert",
		file_ignore_patterns = { ".git/" },
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
	extensions = {
		project = {
			base_dirs = {
				"~/Dev/",
			},
			hidden_files = true,
			on_project_selected = function(prompt_bufnr)
				local project_actions = require("telescope._extensions.project.actions")
				project_actions.change_working_directory(prompt_bufnr, false)

				vim.defer_fn(function()
					require("telescope.builtin").find_files()
				end, 50)
			end,
		},
	},
}
