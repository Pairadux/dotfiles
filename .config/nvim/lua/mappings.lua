require "nvchad.mappings"

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

-- TERMS
-- Creating new toggleable terms
map({ "n", "t" }, "<A-8>", function()
    require("nvchad.term").toggle { pos = "float", id = "1" }
end, { desc = "Terminal Toggle Floating Term 1" })
map({ "n", "t" }, "<A-9>", function()
    require("nvchad.term").toggle { pos = "float", id = "2" }
end, { desc = "Terminal Toggle Floating Term 2" })
map({ "n", "t" }, "<A-0>", function()
    require("nvchad.term").toggle { pos = "float", id = "3" }
end, { desc = "Terminal Toggle Floating Term 3" })

-- HARPOON
-- Harpoon Main Options
map("n", "<leader>a", function() harpoon:list():append() end, { desc = "Add line under cursor to Harpoon"})
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon Quick Menu"})

-- Harpoon Quick Select Option
map("n", "<C->", function() harpoon:list():select(1) end, { desc = "Quick Select First Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(2) end, { desc = "Quick Select Second Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(3) end, { desc = "Quick Select Third Harpoon Option"})
map("n", "<C->", function() harpoon:list():select(4) end, { desc = "Quick Select Fourth Harpoon Option"})

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Toggle Previous Buffer in Harpoon List"})
map("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Toggle Next Buffer in Harpoon List"})

-- TODO-COMMENTS
map("n", "<leader>tt", ":TodoTelescope", { desc = "Telescope Todo Comments" })
