-- Global Declarations
local map = vim.keymap.set

-- Tabufline
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer Goto Next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer Goto Prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer Close" })

-- Nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle Window" })

-- Telescope
map("n", "<leader>tg", "<cmd>Telescope live_grep<CR>", { desc = "[T]elescope Live [G]rep" })
map("n", "<leader>tb", "<cmd>Telescope buffers<CR>", { desc = "[T]elescope Find [B]uffers" })
map("n", "<leader>th", "<cmd>Telescope help_tags<CR>", { desc = "[T]elescope [H]elp Page" })
map("n", "<leader>tm", "<cmd>Telescope marks<CR>", { desc = "[T]elescope Find [M]arks" })
map("n", "<leader>to", "<cmd>Telescope oldfiles<CR>", { desc = "[T]elescope Find [O]ldfiles" })
map("n", "<leader>tz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[T]elescope Fu[z]zy Find in Current Buffer" })
map("n", "<leader>tc", "<cmd>Telescope git_commits<CR>", { desc = "[T]elescope Git [C]ommits" })
map("n", "<leader>ts", "<cmd>Telescope git_status<CR>", { desc = "[T]elescope Git [S]tatus" })
map("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "[T]elescope [F]ind Files" })
map("n", "<leader>ta", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "[T]elescope Find [A]ll Files" })
map("n", "<leader>tt", "<cmd>Telescope todo-comments<CR>", { desc = "[T]elescope [T]odo Comments" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape Terminal Mode" })

-- Toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Terminal Toggleable Vertical Term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Terminal Toggleable Horizontal Term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating Term" })

map({ "n", "t" }, "<A-8>", function()
	require("nvchad.term").toggle({ pos = "float", id = "1" })
end, { desc = "Terminal Toggle Floating Term 1" })

map({ "n", "t" }, "<A-9>", function()
	require("nvchad.term").toggle({ pos = "float", id = "2" })
end, { desc = "Terminal Toggle Floating Term 2" })

map({ "n", "t" }, "<A-0>", function()
	require("nvchad.term").toggle({ pos = "float", id = "3" })
end, { desc = "Terminal Toggle Floating Term 3" })

-- Toggleable LazyGit Term
map({ "n", "t" }, "<A-l>", function()
	require("nvchad.term").toggle({ pos = "float", id = "lazygit", cmd = "lazygit" })
end, { desc = "Terminal Toggle Lazygit" })

-- Whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey All Keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Whichkey Query Lookup" })

-- AutoSession
map("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "[S]ession [S]ave", noremap = true, silent = true })
map("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "[S]ession [R]estore", noremap = true, silent = true })
map("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "[S]ession [D]elete", noremap = true, silent = true })
map("n", "<leader>sl", "<cmd>SessionSearch<CR>", { desc = "[S]ession [L]oad", noremap = true, silent = true })

-- TMUX NAVIGATOR
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux Window Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux Window Right" })
map("n", "<C-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux Window Down" })
map("n", "<C-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux Window Up" })

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
