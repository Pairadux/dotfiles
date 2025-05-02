local map = vim.keymap.set

-- stylua: ignore start

------------------------------------------------------------
-- INSERT MODE MAPPINGS
------------------------------------------------------------

-- Exit Insert Mode
map('i', 'jk', '<ESC>', { desc = 'Exit Insert Mode' })

-- Navigation in Insert Mode
map('i', '<C-b>',     '<ESC>^i', { desc = 'Move to Beginning of Line' })
map('i', '<C-e>',     '<End>',   { desc = 'Move to End of Line' })
map('i', '<C-h>',     '<Left>',  { desc = 'Move Left' })
map('i', '<C-l>',     '<Right>', { desc = 'Move Right' })
map('i', '<C-j>',     '<Down>',  { desc = 'Move Down' })
map('i', '<C-k>',     '<Up>',    { desc = 'Move Up' })
map('i', '<C-Enter>', '<C-o>o',  { desc = 'Go to next line' })
map('i', '<Tab>',     '<C-t>',   { desc = 'Indent in insert mode', buffer = true, silent = true })
map('i', '<S-Tab>',   '<C-d>',   { desc = 'Undent in insert mode',buffer = true, silent = true })

------------------------------------------------------------
-- NORMAL MODE MAPPINGS
------------------------------------------------------------

-- Window Movement
map('n', '<C-h>', '<C-w>h', { desc = 'Switch Window Left' })
map('n', '<C-l>', '<C-w>l', { desc = 'Switch Window Right' })
map('n', '<C-j>', '<C-w>j', { desc = 'Switch Window Down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Switch Window Up' })

-- Tab Management
map('n', '<leader><Tab><Tab>', '<Cmd>tabnew<CR>',   { desc = '[Tab] New Tab' })
map('n', '<leader><Tab>n',     'gt',                { desc = '[Tab] Next' })
map('n', '<leader><Tab>p',     'gT',                { desc = '[Tab] Prev' })
map('n', '<leader><Tab>x',     '<Cmd>tabclose<CR>', { desc = '[Tab] Close' })

-- Miscellaneous Normal Mappings
map('n', '<Esc>',      '<cmd>noh<CR>',            { desc = 'Clear Highlights' })
map('n', '<C-s>',      '<cmd>w<CR>',              { desc = 'Save File' })
map('n', '<leader>cc', '<cmd>%y+<CR>',            { desc = '[C]ode [C]opy' })
map('n', '<leader>od', vim.diagnostic.setloclist, { desc = '[O]pen [D]iagnostic Loclist' })

-- Open Modals
map('n', '<leader>ol', '<cmd>Lazy<CR>',  { desc = '[O]pen [L]azy',  noremap = true, silent = true })
map('n', '<leader>om', '<cmd>Mason<CR>', { desc = '[O]pen [M]ason', noremap = true, silent = true })

-- Custom Utility Functions
map('n', '<leader>ib', function() require('util').insert_line_break() end, { noremap = true, silent = true, desc = "Insert 80 #'s (Line Break)" })
map('n', '<leader>it', function() require('util').insert_title_box()  end, { noremap = true, silent = true, desc = 'Insert Title Box' })

------------------------------------------------------------
-- TERMINAL MODE MAPPINGS
------------------------------------------------------------

map('t', '<C-x>', '<C-\\><C-N>', { desc = 'Exit Terminal Mode' })

------------------------------------------------------------
-- ARCHIVED/DEPRECATED MAPPINGS
------------------------------------------------------------

-- map({ 'n', 'v' }, 'zt', 'zt2<C-y>', { noremap = true, silent = true })
-- map("n", "<C-d>", "Lzz", { noremap = true, silent = true })
-- map("n", "<C-u>", "Hzz", { noremap = true, silent = true })
-- map({ 'n', 'v' }, '<C-j>', '5j', { noremap = true, silent = true })
-- map({ 'n', 'v' }, '<C-k>', '5k', { noremap = true, silent = true })
-- map('n', '<C-q>', 'ZZ', { noremap = true, silent = true })
--- NvChad Code Runner {{{
-- -- Code Runner
-- map("n", "<leader>rc", function()
-- 	vim.schedule(function()
-- 		require("nvchad.term").runner({
-- 			id = "coderun",
-- 			pos = "float",
--
-- 			cmd = function()
-- 				local file = vim.fn.expand("%<Cmd>p")
-- 				local ft = vim.bo.ft
--
-- 				local ft_cmds = {
-- 					c = string.format("clear && gcc -o out %q && ./out", file),
-- 					cpp = string.format("clear && g++ -o out %q && ./out", file),
-- 					python = string.format("python3 %q", file),
-- 					rust = "cargo run",
-- 					go = string.format("clear && go run %q", file),
-- 				}
--
-- 				return ft_cmds[ft]
-- 			end,
-- 		})
-- 	end)
-- end, { desc = "[R]un [C]urrent File", noremap = true, silent = true })}}}- map("n", "<leader>qa", "<cmd>wqa<CR>", { desc = "Quit all" })

-- stylua: ignore end
