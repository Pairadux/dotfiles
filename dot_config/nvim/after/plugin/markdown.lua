-- local o = vim.opt
local ol = vim.opt_local
local wo = vim.wo

-- Make writing paragraphs niceer
-- o.wrap = true
-- o.textwidth = 0
-- o.wrapmargin = 0
-- o.linebreak = true
-- o.columns = 100

-- Option for Obsidian to hide markdown stuff
ol.conceallevel = 1

-- Enable spell checking
wo.spell = true

-- Update formatoptions
ol.formatoptions = ol.formatoptions + "nro"
