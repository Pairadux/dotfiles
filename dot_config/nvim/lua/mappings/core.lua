-- Global Declarations
local map = vim.keymap.set

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Adjusted default zt behavior
map({ "n", "v" }, "zt", "zt2<C-y>", { noremap = true, silent = true })

-- Adjusted default C-d & C-u behavior
map("n", "<C-d>", "Lzz", { noremap = true, silent = true })
map("n", "<C-u>", "Hzz", { noremap = true, silent = true })

-- Quicker navigation
map({ "n", "v" }, "<C-j>", "5j", { noremap = true, silent = true })
map({ "n", "v" }, "<C-k>", "5k", { noremap = true, silent = true })

-- close nvim with q, different action based on buffer type
map("n", "<C-q>", "ZZ", { noremap = true, silent = true })

-- Insert Mode Mappings
map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of Line" })
map("i", "<C-e>", "<End>", { desc = "Move End of Line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

-- Window Movement
map("n", "<C-h>", "<C-w>h", { desc = "Switch Window Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch Window Right" })
map("n", "<C-S-j>", "<C-w>j", { desc = "Switch Window Down" })
map("n", "<C-S-k>", "<C-w>k", { desc = "Switch Window Up" })

-- Tab Management
map("n", "<leader><Tab>", "<Cmd>tabnew<CR>", { desc = "Create New Tab" })
map("n", "<leader>n", "gt", { desc = "Next Tab" })
map("n", "<leader>p", "gT", { desc = "Previous Tab" })

-- Clear Highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear Highlights" })

-- General Bindings
map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save File" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy Whole File" })

-- LSP Formatting
map("n", "<leader>gf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "[G]eneral [F]ormat File" })

-- Global lsp mappings
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "LSP [D]iagnostic [L]oclist" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle Comment", remap = true })

-- Reload nvim
map("n", "<leader>rn", function()
	require("nvchad.utils").reload()
end, { desc = "[R]eload [N]vim", noremap = true, silent = true })

-- Insert Line Break Sequence
map("n", "<leader>ib", "80i#<ESC>", { noremap = true, silent = true, desc = "[I]nsert 80 #'s (Line [B]reak)" })

-- Insert Config Section Title Box
map(
	"n",
	"<leader>it",
	"O# *-*<CR># | |<CR># *-*<ESC>",
	{ noremap = true, silent = true, desc = "[I]nsert [T]itle Box" }
)

-- Code Runner
map("n", "<leader>rc", function()
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
end, { desc = "[R]un [C]urrent File", noremap = true, silent = true, expr = true })

-- Lazy Update
map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "[L]azy [U]pdate", noremap = true, silent = true })

-- Mason Open
map("n", "<leader>mo", "<cmd>Mason<CR>", { desc = "[M]ason [O]pen", noremap = true, silent = true })
