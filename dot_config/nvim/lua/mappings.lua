require("nvchad.mappings")


-- Global Declarations
local map = vim.keymap.set
local nomap = vim.keymap.del
-- local harpoon = require("harpoon")

-- Remove some default nvchad mappings
nomap("n", "<leader>th")
nomap("n", "<leader>n")
nomap("n", "<leader>rn")
nomap("n", "<leader>ch")
nomap("n", "<leader>b")
nomap("n", "<leader>e")
nomap("n", "<leader>v")
nomap("n", "<leader>h")

-- close nvim with q, different action based on buffer type
map("n", "q", function()
	if vim.bo.modifiable then
		vim.cmd("wq")
	else
		vim.cmd("q")
	end
end, { noremap = true, silent = true })

-- Reload nvim
map("n", "<leader>rn", function()
	require("nvchad.utils").reload()
end, { desc = "Reload nvim" })

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Insert Line Break Sequence
map("n", "<leader>ib", "80i#<ESC>", { noremap = true, silent = true, desc = "Insert 80 #'s (Line Break)" })

-- Insert Config Section Title Box
map("n", "<leader>it", "O# *-*<CR># | |<CR># *-*<ESC>", { noremap = true, silent = true, desc = "Insert Title Box" })

-- TERMS
-- Creating new toggleable terms
map({ "n", "t" }, "<A-8>", function()
	require("nvchad.term").toggle({ pos = "float", id = "1" })
end, { desc = "Terminal Toggle Floating Term 1" })
map({ "n", "t" }, "<A-9>", function()
	require("nvchad.term").toggle({ pos = "float", id = "2" })
end, { desc = "Terminal Toggle Floating Term 2" })
map({ "n", "t" }, "<A-0>", function()
	require("nvchad.term").toggle({ pos = "float", id = "3" })
end, { desc = "Terminal Toggle Floating Term 3" })

-- -- HARPOON
-- -- Harpoon Main Options
-- map("n", "<leader>a", function()
-- 	harpoon:list():add()
-- end, { desc = "Add line under cursor to Harpoon" })
-- map("n", "<C-e>", function()
-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
-- end, { desc = "Toggle Harpoon Quick Menu" })
--
-- -- Harpoon Quick Select Option
-- map("n", "<leader>1", function()
-- 	harpoon:list():select(1)
-- end, { desc = "Quick Select First Harpoon Option" })
-- map("n", "<leader>2", function()
-- 	harpoon:list():select(2)
-- end, { desc = "Quick Select Second Harpoon Option" })
-- map("n", "<leader>3", function()
-- 	harpoon:list():select(3)
-- end, { desc = "Quick Select Third Harpoon Option" })
-- map("n", "<leader>4", function()
-- 	harpoon:list():select(4)
-- end, { desc = "Quick Select Fourth Harpoon Option" })
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- map("n", "<C-S-P>", function()
-- 	harpoon:list():prev()
-- end, { desc = "Toggle Previous Buffer in Harpoon List" })
-- map("n", "<C-S-N>", function()
-- 	harpoon:list():next()
-- end, { desc = "Toggle Next Buffer in Harpoon List" })


-- TMUX NAVIGATOR
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux Window Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux Window Right" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux Window Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux Window Up" })

-- OBSIDIAN
map("n", "<leader>ooq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian Open Quick Switcher" })
map("n", "<leader>ood", "<cmd>ObsidianToday<CR>", { desc = "Obsidian Open Daily Note" })
map("n", "<leader>oit", "<cmd>ObsidianTemplate<CR>", { desc = "Obsidian Insert Template" })
map("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Obsidian Rename Note" })
map("n", "<leader>ocn", "<cmd>ObsidianNew<CR>", { desc = "Obsidian Create New Note" })
map("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Obsidian Search" })
map("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian Follow Link" })
map("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Obsidian Tags" })
map("v", "<leader>oe", "<cmd>ObsidianExtractNote<CR>", { desc = "Obsidian Extract Note" })

-- Telescope
map("n", "<leader>fp", "<cmd>Telescope project<CR>", { desc = "Telescope projects" })
map("n", "<leader>ft", "<cmd>Telescope todo-comments<CR>", { desc = "Telescope todo comments" })

-- Toggleable LazyGit Term
map({ "n", "t" }, "<A-l>", function()
	require("nvchad.term").toggle({ pos = "float", id = "lazygit", cmd = "lazygit" })
end, { desc = "Terminal Toggle Lazygit" })

-- Code Runner
map({ "n", "t" }, "<leader>rc", function()
	require("nvchad.term").runner({
		id = "coderun",
		pos = "float",

		cmd = function()
			local file = vim.fn.expand("%")

			local ft_cmds = {
				python = "python3 " .. file,
				cpp = "clear && g++ -o out " .. file .. " && ./out",
				c = 'clear && gcc -o out "' .. file .. '" && ./out',
			}

			return ft_cmds[vim.bo.ft]
		end,
	})
end, { desc = "Run Current File" })

-- Quick OO
vim.api.nvim_set_keymap("n", "OO", "O<Esc>O", { noremap = true, silent = true })
