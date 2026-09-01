local md = require 'markdown'

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end

--- Send `keys` through without re-entering these buffer-local mappings. They go
--- to the front of the typeahead ('i') so a fallback still lands ahead of input
--- already queued behind the mapping.
--- @param mode string|nil nvim_feedkeys flags; 'nx' runs the keys before returning
local function feed(keys, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or 'ni', false)
end

-- Options
vim.wo.foldlevel = 99

-- Nested lists indent to their parent's body column, but `>`/`<` over a visual
-- block still steps by shiftwidth; 2 matches what prettier normalises lists to.
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- Wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0
vim.opt_local.colorcolumn = ''

-- Navigate display lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('n', '0', 'g0')
map('n', '$', 'g$')

-- List editing. blink.cmp re-maps <Tab>/<S-Tab> per buffer on InsertEnter and
-- falls back to whatever buffer-local mapping it found, so completion still
-- wins while the menu is open.
map('i', '<CR>', function()
    if not md.newline() then
        feed '<CR>'
    end
end, 'Continue list item')

map('i', '<Tab>', function()
    if not md.shift(vim.api.nvim_win_get_cursor(0)[1], 1) then
        feed '<C-t>'
    end
end, 'Demote list item')

map('i', '<S-Tab>', function()
    if not md.shift(vim.api.nvim_win_get_cursor(0)[1], -1) then
        feed '<C-d>'
    end
end, 'Promote list item')

map('n', 'o', function()
    if not md.open(false) then
        feed 'o'
    end
end, 'Open list item below')

map('n', 'O', function()
    if not md.open(true) then
        feed 'O'
    end
end, 'Open list item above')

map('n', '>>', function()
    if not md.shift(vim.api.nvim_win_get_cursor(0)[1], 1) then
        feed '>>'
    end
end, 'Demote list item')

map('n', '<<', function()
    if not md.shift(vim.api.nvim_win_get_cursor(0)[1], -1) then
        feed '<<'
    end
end, 'Promote list item')

for _, lhs in ipairs { '>', '<' } do
    map('x', lhs, function()
        local first = math.min(vim.fn.line 'v', vim.fn.line '.')
        vim.cmd('normal! ' .. lhs .. 'gv')
        md.renumber(first)
    end, 'Shift list items')
end

-- Checkboxes
map('n', '<CR>', function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if not md.toggle_checkbox(row) then
        feed '<CR>'
    end
end, 'Toggle checkbox')

map('x', '<CR>', function()
    local first, last = vim.fn.line 'v', vim.fn.line '.'
    feed('<Esc>', 'nx')
    md.toggle_checkbox(math.min(first, last), math.max(first, last))
end, 'Toggle checkboxes')

-- Ordered lists renumber themselves on every edit made through the mappings
-- above; this is the escape hatch for anything else (a `dd`, a yank-put, a
-- hand-written item).
vim.api.nvim_buf_create_user_command(0, 'MarkdownRenumber', function()
    md.renumber(vim.api.nvim_win_get_cursor(0)[1])
end, { desc = 'Renumber the ordered list under the cursor' })
