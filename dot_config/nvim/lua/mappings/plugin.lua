-- Global Declarations
local map = vim.keymap.set

-- LSP Formatting
map("n", "<leader>gf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "[G]eneral [F]ormat File" })

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

map("n", "<S-Right>", function()
	require("nvchad.tabufline").move_buf(1)
end, { desc = "Move Buffer" })

map("n", "<S-Left>", function()
	require("nvchad.tabufline").move_buf(-1)
end, { desc = "Move Buffer" })

-- Nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle Window" })

-- Telescope
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "[F]ind Live [G]rep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "[F]ind [B]uffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "[F]ind [H]elp Page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "[F]ind [M]arks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "[F]ind [O]ldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[F]u[z]zy Find in Current Buffer" })
map("n", "<leader>fc", "<cmd>Telescope git_commits<CR>", { desc = "[F]ind Git [C]ommits" })
map("n", "<leader>fs", "<cmd>Telescope git_status<CR>", { desc = "[F]ind Git [S]tatus" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[F]ind [F]iles" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "[F]ind [A]ll Files" }
)
map("n", "<leader>ft", "<cmd>Telescope todo-comments<CR>", { desc = "[F]ind [T]odo Comments" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape Terminal Mode" })

-- Toggleable
map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "Terminal Toggleable Vertical Term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "Terminal Toggleable Horizontal Term" })

map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
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

-- Code Runner
map("n", "<leader>rc", function()
    vim.schedule(function()
        require("nvchad.term").runner({
            id = "coderun",
            pos = "float",

            cmd = function()
                local file = vim.fn.expand("%:p")
                local ft = vim.bo.ft

                local ft_cmds = {
                    c       = string.format("clear && gcc -o out %q && ./out", file),
                    cpp     = string.format("clear && g++ -o out %q && ./out", file),
                    python  = string.format("python3 %q", file),
                    rust    = "cargo run",
                    go      = string.format("clear && go run %q", file),
                }

                return ft_cmds[ft]
            end,
        })
    end)
end, { desc = "[R]un [C]urrent File", noremap = true, silent = true })

-- Whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey All Keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "Whichkey Query Lookup" })

-- AutoSession
map("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "[S]ession [S]ave", noremap = true, silent = true })
map("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "[S]ession [R]estore", noremap = true, silent = true })
map("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "[S]ession [D]elete", noremap = true, silent = true })
map("n", "<leader>sl", "<cmd>SessionSearch<CR>", { desc = "[S]ession [L]oad", noremap = true, silent = true })

-- TMUX NAVIGATOR
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux Window Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux Window Right" })
map("n", "<C-A-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux Window Down" })
map("n", "<C-A-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux Window Up" })

-- Reload nvim
map("n", "<leader>rn", function()
	require("nvchad.utils").reload()
end, { desc = "[R]eload [N]vim", noremap = true, silent = true })

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

-- Lazy Update
map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "[L]azy [U]pdate", noremap = true, silent = true })

-- Mason Open
map("n", "<leader>mo", "<cmd>Mason<CR>", { desc = "[M]ason [O]pen", noremap = true, silent = true })
