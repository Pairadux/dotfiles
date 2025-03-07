local M = {}

M.on_save = function()
	local api = vim.api
	local list_tabpages = api.nvim_list_tabpages
	local tabpage_get_var = api.nvim_tabpage_get_var
	local tabpage_get_number = api.nvim_tabpage_get_number
	local buf_is_valid = api.nvim_buf_is_valid
	local buf_get_name = api.nvim_buf_get_name

	local tab_bufs = {}
	for _, tab in ipairs(list_tabpages()) do
		local ok, buflist = pcall(tabpage_get_var, tab, "bufs")
		if ok and type(buflist) == "table" then
			local tabnr = tabpage_get_number(tab)
			local files = {}
			for i = 1, #buflist do
				local buf = buflist[i]
				if buf_is_valid(buf) then
					files[#files + 1] = buf_get_name(buf)
				end
			end
			tab_bufs[tabnr] = files
		end
	end
	return tab_bufs
end

M.on_post_load = function(tab_bufs)
	if type(tab_bufs) ~= "table" then
		return
	end
	local api = vim.api
	local fn = vim.fn
	local list_tabpages = api.nvim_list_tabpages
	local tabpage_set_var = api.nvim_tabpage_set_var

	local tabs = list_tabpages()
	for tabnr, filelist in pairs(tab_bufs) do
		local tab = tabs[tonumber(tabnr)]
		if tab and type(filelist) == "table" then
			local new_bufs = {}
			for i = 1, #filelist do
				local file = filelist[i]
				local bufid = fn.bufnr(file, false)
				if bufid == -1 then
					bufid = fn.bufadd(file)
				end
				new_bufs[#new_bufs + 1] = bufid
			end
			pcall(tabpage_set_var, tab, "bufs", new_bufs)
		end
	end
end

return M
