local has_tabby, tabby_name = pcall(require, 'tabby.feature.tab_name')

local M = {}

M.on_save = function()
    if not has_tabby then
        return {}
    end

    local tab_names = {}
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        -- fallback returns an empty string, not nil
        local name = tabby_name.get(tab, {
            name_fallback = function()
                return ''
            end,
        })
        if name ~= '' then
            tab_names[tostring(vim.api.nvim_tabpage_get_number(tab))] = name
        end
    end

    return { tab_names = tab_names }
end

M.on_post_load = function(data)
    if not has_tabby then
        return
    end
    local tab_names = data.tab_names or {}
    if vim.tbl_count(tab_names) == 0 then
        return
    end

    -- map tab numbers → tabpage IDs
    local num2id = {}
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        num2id[vim.api.nvim_tabpage_get_number(tab)] = tab
    end

    for num, name in pairs(tab_names) do
        local tab = num2id[tonumber(num)]
        if tab and vim.api.nvim_tabpage_is_valid(tab) then
            tabby_name.set(tab, name)
        end
    end
end

return M
