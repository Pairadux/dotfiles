require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local harpoon = require("harpoon")

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "File Format with conform" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("n", "<leader>a", function() harpoon:list():append() end, { desc = "Add line under cursor to Harpoon"})
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon Quick Menu"})

map("n", "<C->", function() harpoon:list():select(1) end, { desc = "Quick Select First Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(2) end, { desc = "Quick Select Second Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(3) end, { desc = "Quick Select Third Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(4) end, { desc = "Quick Select Fourth Harpoon Option"})

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Toggle Previous Buffer in Harpoon List"})
map("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Toggle Next Buffer in Harpoon List"})

-- map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { "Window left"} )
-- map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { "Window right"} )
-- map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { "Window Down"} )
-- map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { "Window Up"} )
