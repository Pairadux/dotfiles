local M = {}

function M.insert_title_box()
    local cs = vim.bo.commentstring:match '^(.-)%%s' or vim.bo.commentstring
    cs = cs:gsub('%s*$', '')

    local title = vim.fn.input 'Enter title: '
    if title == '' then
        return
    end

    local inner_width = #title + 2
    local border = string.rep('-', inner_width)

    local top_line = cs .. ' +' .. border .. '+'
    local middle_line = cs .. ' | ' .. title .. ' |'
    local bottom_line = top_line

    vim.api.nvim_put({ top_line, middle_line, bottom_line }, 'l', true, true)

    local pos = vim.api.nvim_win_get_cursor(0)
    local buf_line_count = vim.api.nvim_buf_line_count(0)
    if pos[1] == buf_line_count then
        vim.api.nvim_buf_set_lines(0, buf_line_count, buf_line_count, false, { '' })
    end
    vim.api.nvim_win_set_cursor(0, { pos[1] + 1, 0 })

    vim.cmd 'normal! zz'

    vim.cmd 'startinsert'
end

function M.insert_line_break()
    local cs = vim.bo.commentstring:match '^(.-)%%s' or vim.bo.commentstring
    cs = cs:gsub('%s*$', '')

    local prefix = cs .. ' '
    local prefix_len = #prefix

    local total_width = 80

    local fill_width = total_width - prefix_len
    if fill_width < 0 then
        fill_width = 0
    end

    local break_line = prefix .. string.rep('#', fill_width)

    vim.api.nvim_put({ break_line }, 'l', true, true)
end

return M
