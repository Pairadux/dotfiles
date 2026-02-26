-- ~/.config/nvim/ftplugin/norg.lua
local map = vim.keymap.set

-- Options
vim.wo.foldlevel = 99

-- Which-key groups (buffer-local)
require('which-key').add({
    { '<LocalLeader>t', group = '[T]ask',   buffer = true },
    { '<LocalLeader>l', group = '[L]ist',   buffer = true },
    { '<LocalLeader>i', group = '[I]nsert', buffer = true },
    { '<LocalLeader>c', group = '[C]ode',   buffer = true },
}, { buffer = true })

-- Task mappings
map('n', '<LocalLeader>tu', '<Plug>(neorg.qol.todo-items.todo.task-undone)',    { buffer = true, desc = '[T]ask mark [U]ndone' })
map('n', '<LocalLeader>tp', '<Plug>(neorg.qol.todo-items.todo.task-pending)',   { buffer = true, desc = '[T]ask mark [P]ending' })
map('n', '<LocalLeader>td', '<Plug>(neorg.qol.todo-items.todo.task-done)',      { buffer = true, desc = '[T]ask mark [D]one' })
map('n', '<LocalLeader>tc', '<Plug>(neorg.qol.todo-items.todo.task-cancelled)', { buffer = true, desc = '[T]ask mark [C]ancelled' })
map('n', '<LocalLeader>th', '<Plug>(neorg.qol.todo-items.todo.task-on-hold)',   { buffer = true, desc = '[T]ask mark on [H]old' })
map('n', '<LocalLeader>ti', '<Plug>(neorg.qol.todo-items.todo.task-important)', { buffer = true, desc = '[T]ask mark [I]mportant' })
map('n', '<LocalLeader>ta', '<Plug>(neorg.qol.todo-items.todo.task-ambiguous)', { buffer = true, desc = '[T]ask mark [A]mbiguous' })
map('n', '<LocalLeader>tr', '<Plug>(neorg.qol.todo-items.todo.task-recurring)', { buffer = true, desc = '[T]ask mark [R]ecurring' })
map('n', '<C-Space>',       '<Plug>(neorg.qol.todo-items.todo.task-cycle)',     { buffer = true, desc = '[T]ask cycle state' })

-- List mappings
map('n', '<LocalLeader>lt', '<Plug>(neorg.pivot.list.toggle)', { buffer = true, desc = '[L]ist [T]oggle ordered/unordered' })
map('n', '<LocalLeader>li', '<Plug>(neorg.pivot.list.invert)', { buffer = true, desc = '[L]ist [I]nvert items' })

-- Insert mappings
map('n', '<LocalLeader>id', '<Plug>(neorg.tempus.insert-date)',             { buffer = true, desc = '[I]nsert [D]ate' })
map('i', '<M-d>',           '<Plug>(neorg.tempus.insert-date.insert-mode)', { buffer = true, desc = '[I]nsert [D]ate' })

-- Code
map('n', '<LocalLeader>cm', '<Plug>(neorg.looking-glass.magnify-code-block)', { buffer = true, desc = '[C]ode [M]agnify' })

-- Navigation
map('n', '<CR>',   '<Plug>(neorg.esupports.hop.hop-link)',          { buffer = true, desc = 'Follow link' })
map('n', '<M-CR>', '<Plug>(neorg.esupports.hop.hop-link.vsplit)',   { buffer = true, desc = 'Follow link in vsplit' })
map('n', '<M-t>',  '<Plug>(neorg.esupports.hop.hop-link.tab-drop)', { buffer = true, desc = 'Follow link in tab' })
map('n', '<C-n>',  '<cmd>Neorg toc<CR>',                            { buffer = true, desc = '[N]eorg [T]OC' })

-- Promote/Demote
map('n', '>.',        '<Plug>(neorg.promo.promote)',        { buffer = true, desc = 'Promote object' })
map('n', '>>',        '<Plug>(neorg.promo.promote.nested)', { buffer = true, desc = 'Promote object recursively' })
map('n', '<,',        '<Plug>(neorg.promo.demote)',         { buffer = true, desc = 'Demote object' })
map('n', '<<',        '<Plug>(neorg.promo.demote.nested)',  { buffer = true, desc = 'Demote object recursively' })
map('v', '>',         '<Plug>(neorg.promo.promote.range)',  { buffer = true, desc = 'Promote range' })
map('v', '<',         '<Plug>(neorg.promo.demote.range)',   { buffer = true, desc = 'Demote range' })
map('i', '<C-Right>', '<Plug>(neorg.promo.demote)',         { buffer = true, desc = 'Demote object' })
map('i', '<C-Left>',  '<Plug>(neorg.promo.promote)',        { buffer = true, desc = 'Promote object' })
map('i', '<M-CR>',    '<Plug>(neorg.itero.next-iteration)', { buffer = true, desc = 'New list iteration' })
