require("nvchad.mappings")

-- Global Declarations
local map = vim.keymap.set
local nomap = vim.keymap.del
-- local harpoon = require("harpoon")

-- Remove some default nvchad mappings
nomap("n", "<leader>n")
nomap("n", "<leader>rn")
nomap("n", "<leader>ch")
nomap("n", "<leader>b")
nomap("n", "<leader>e")
nomap("n", "<leader>v")
nomap("n", "<leader>h")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Adjusted default zt behavior
map({ "n", "v" }, "zt", "zt2<C-y>", { noremap = true, silent = true })

-- Quicker navigation
map({ "n", "v" }, "<C-j>", "5j", { noremap = true, silent = true })
map({ "n", "v" }, "<C-k>", "5k", { noremap = true, silent = true })

-- close nvim with q, different action based on buffer type
map("n", "<C-q>", "ZZ", { noremap = true, silent = true })

-- Reload nvim
map("n", "<leader>rn", function()
	require("nvchad.utils").reload()
end, { desc = "Reload nvim", noremap = true, silent = true })

-- -- DAP
-- local dap = require("dap")
-- local dapui = require("dapui")
-- map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
-- map("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
-- map("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
-- map("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
-- map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
-- map("n", "<leader>B", function()
-- 	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
-- end, { desc = "Debug: Set Breakpoint" })
-- map("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result" })

-- AutoSession
map("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Session Save", noremap = true, silent = true })
map("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Session Restore", noremap = true, silent = true })
map("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "Session Delete", noremap = true, silent = true })
map("n", "<leader>sl", "<cmd>SessionSearch<CR>", { desc = "Session Load", noremap = true, silent = true })

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
map("n", "<C-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux Window Down" })
map("n", "<C-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux Window Up" })

-- OBSIDIAN
map( "n", "<leader>ooq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian Open Quick Switcher", noremap = true, silent = true })
map("n", "<leader>ood", "<cmd>ObsidianToday<CR>", { desc = "Obsidian Open Daily Note", noremap = true, silent = true })
map( "n", "<leader>oit", "<cmd>ObsidianTemplate<CR>", { desc = "Obsidian Insert Template", noremap = true, silent = true })
map("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Obsidian Rename Note", noremap = true, silent = true })
map("n", "<leader>ocn", "<cmd>ObsidianNew<CR>", { desc = "Obsidian Create New Note", noremap = true, silent = true })
map("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Obsidian Search", noremap = true, silent = true })
map("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "Obsidian Follow Link", noremap = true, silent = true })
map("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Obsidian Tags", noremap = true, silent = true })
map( "v", "<leader>oe", "<cmd>ObsidianExtractNote<CR>", { desc = "Obsidian Extract Note", noremap = true, silent = true })

-- Telescope
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
				c = 'clear && gcc -o out "' .. file .. '" && ./out',
				cpp = "clear && g++ -o out " .. file .. " && ./out",
				python = "python3 " .. file,
				rust = "cargo run",
			}

			return ft_cmds[vim.bo.ft]
		end,
	})
end, { desc = "Run Current File", noremap = true, silent = true })

-- Lazy Update
map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy Update", noremap = true, silent = true })

-- Mason Open
map("n", "<leader>mo", "<cmd>Mason<CR>", { desc = "Mason Open", noremap = true, silent = true })
