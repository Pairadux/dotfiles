require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set
local harpoon = require("harpoon")

-- Enter Command Mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Format with conform
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

-- Exit insert mode
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Insert Line Break Sequence
map("n", "<leader>ib", "80i#<ESC>", { desc = "Insert 80 #'s (Line Break)" })

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

-- HARPOON
-- Harpoon Main Options
map("n", "<leader>a", function()
	harpoon:list():append()
end, { desc = "Add line under cursor to Harpoon" })
map("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon Quick Menu" })

-- Harpoon Quick Select Option
map("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Quick Select First Harpoon Option" })
map("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Quick Select Second Harpoon Option" })
map("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Quick Select Third Harpoon Option" })
map("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Quick Select Fourth Harpoon Option" })

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<C-S-P>", function()
	harpoon:list():prev()
end, { desc = "Toggle Previous Buffer in Harpoon List" })
map("n", "<C-S-N>", function()
	harpoon:list():next()
end, { desc = "Toggle Next Buffer in Harpoon List" })

-- TODO-COMMENTS
map("n", "<leader>tt", "<cmd>Telescope todo-comments<CR>", { desc = "Telescope Todo Comments" })

-- TMUX NAVIGATOR
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux Window Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux Window Right" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux Window Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux Window Up" })

-- OBSIDIAN
map("n", "<leader>ooq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Open Obsidian Quickswitcher" })
map("n", "<leader>ood", "<cmd>ObsidianToday<CR>", { desc = "Open Obsidian Daily Note" })
map("n", "<leader>oit", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
map("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Rename Obsidian Note" })

-- Telescope
map("n", "<leader>tp", "<cmd>Telescope project<CR>", { desc = "Telescope Projects" })

-- Toggleable LazyGit Term
map({ "n", "t" }, "<A-l>", function()
	require("nvchad.term").toggle({ pos = "float", id = "lazygit", cmd ='lazygit' })
end, { desc = "Terminal Toggle Lazygit" })
