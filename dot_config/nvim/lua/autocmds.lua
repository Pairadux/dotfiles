local autocmd = vim.api.nvim_create_autocmd

autocmd("Filetype", {
	pattern = { "*" },
	callback = function()
		vim.opt.formatoptions:remove("o")
	end,
	desc = "Don't continue comments with o and O",
})

-- local function open_dashboard()
--     local status, err = pcall(require("nvchad.nvdash").open)
--     if not status then
--         vim.notify("Failed to open nvdash: " .. err, vim.log.levels.ERROR)
--     end
-- end
--
-- local function show_dashboard_if_no_buffers()
-- 	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
--
-- 	bufs = vim.tbl_filter(function(b)
-- 		local ft = vim.api.nvim_get_option_value("filetype", { buf = b.bufnr })
-- 		local is_dash = (ft == "nvdash")
-- 		local is_empty_name = (b.name == "")
-- 		return (not is_dash) and not is_empty_name
-- 	end, bufs)
--
-- 	if #bufs == 0 then
-- 		vim.schedule(function()
--             vim.cmd("enew")
-- 			open_dashboard()
-- 		end)
-- 	end
-- end

-- autocmd("BufDelete", {
-- 	callback = function(args)
-- 		vim.notify("BufDelete triggered for buffer ID " .. args.buf)
-- 		show_dashboard_if_no_buffers()
-- 	end,
-- 	desc = "Show nvdash if no real buffers remain",
-- })
