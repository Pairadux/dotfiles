local M = {}

function M.open()
    local cwd = vim.fn.getcwd()
    local todo_path = cwd .. '/todo.md'

    if vim.fn.filereadable(todo_path) == 0 then
        vim.notify('No todo.md file found in root directory: ' .. cwd, vim.log.levels.WARN)
        return
    end

    -- Parse todo items and headings from file
    local items = {}
    local todo_count = 0
    local max_width = 0
    local file = io.open(todo_path, 'r')
    if not file then
        vim.notify('Could not read todo.md file', vim.log.levels.ERROR)
        return
    end

    local line_num = 0
    for line in file:lines() do
        line_num = line_num + 1

        -- Check for headings
        local heading = line:match '^(#+%s*.+)$'
        if heading then
            local item = {
                type = 'heading',
                line_num = line_num,
                text = heading:gsub('^#+%s*', ''),
                original_line = line,
                level = #(heading:match '^#+' or ''),
            }
            table.insert(items, item)
            max_width = math.max(max_width, #item.text + 2) -- +2 for indentation
        else
            -- Check for todos
            local checked, text = line:match '^%s*- %[([%sx])%] (.*)$'
            if checked and text then
                local item = {
                    type = 'todo',
                    line_num = line_num,
                    completed = (checked == 'x'),
                    text = text,
                    original_line = line,
                }
                table.insert(items, item)
                todo_count = todo_count + 1
                -- Calculate display width (checkbox + space + text)
                local display_text = (item.completed and '✓' or '☐') .. ' ' .. text
                max_width = math.max(max_width, #display_text)
            end
        end
    end
    file:close()

    if todo_count == 0 then
        vim.notify('No todo items found in todo.md', vim.log.levels.WARN)
        return
    end

    -- Calculate window dimensions
    local screen_width = vim.o.columns
    local screen_height = vim.o.lines
    local width = math.min(max_width + 2, screen_width - 4) -- Minimal padding
    local height = math.min(#items, math.floor(screen_height * 0.8)) -- Exact height for content

    -- Position in top-right corner
    local row = 1
    local col = screen_width - width - 2

    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Set up highlight groups using your colorscheme's markdown colors
    local heading_colors = {
        [1] = '#7aa2f7', -- H1 - blue
        [2] = '#e0af68', -- H2 - yellow
        [3] = '#9ece6a', -- H3 - green
        [4] = '#1abc9c', -- H4 - teal
        [5] = '#bb9af7', -- H5 - light purple
        [6] = '#9d7cd8', -- H6 - darker purple
    }

    -- Set up heading highlights
    for level, color in pairs(heading_colors) do
        vim.api.nvim_set_hl(0, 'TodoHeading' .. level, { fg = color, bold = true })
    end

    vim.api.nvim_set_hl(0, 'TodoCompleted', { fg = '#98C379', bold = true })
    vim.api.nvim_set_hl(0, 'TodoPending', { fg = '#E06C75', bold = true })
    vim.api.nvim_set_hl(0, 'TodoCompletedText', { fg = '#5C6370', italic = true })
    vim.api.nvim_set_hl(0, 'TodoPendingText', { fg = '#ABB2BF' })

    -- Set buffer content and highlights
    local lines = {}
    local highlights = {}
    for i, item in ipairs(items) do
        if item.type == 'heading' then
            table.insert(lines, '  ' .. item.text)
            -- Use our custom heading highlight based on level
            local heading_hl = 'TodoHeading' .. math.min(item.level, 6)
            table.insert(highlights, { line = i - 1, hl_group = heading_hl })
        else -- todo item
            local checkbox = item.completed and '✓' or '☐'
            local line_text = checkbox .. ' ' .. item.text
            table.insert(lines, line_text)
            -- Add highlight for checkbox
            local checkbox_hl = item.completed and 'TodoCompleted' or 'TodoPending'
            table.insert(highlights, { line = i - 1, col_start = 0, col_end = 1, hl_group = checkbox_hl })
            -- Add highlight for text
            local text_hl = item.completed and 'TodoCompletedText' or 'TodoPendingText'
            table.insert(highlights, { line = i - 1, col_start = 2, col_end = #line_text, hl_group = text_hl })
        end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Apply highlights
    local ns_id = vim.api.nvim_create_namespace 'todo_highlights'
    for _, hl in ipairs(highlights) do
        if hl.col_start then
            vim.api.nvim_buf_set_extmark(buf, ns_id, hl.line, hl.col_start, {
                end_col = hl.col_end,
                hl_group = hl.hl_group,
            })
        else
            vim.api.nvim_buf_set_extmark(buf, ns_id, hl.line, 0, {
                end_line = hl.line + 1,
                hl_group = hl.hl_group,
            })
        end
    end

    -- Window options
    local completed_count = 0
    for _, item in ipairs(items) do
        if item.type == 'todo' and item.completed then
            completed_count = completed_count + 1
        end
    end

    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = string.format(' TODO (%d/%d) ', completed_count, todo_count),
        title_pos = 'center',
    }

    -- Create window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set window-local options
    vim.wo[win].signcolumn = 'no'
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].cursorline = true

    -- Make buffer read-only
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true

    -- Set up keymaps for the todo window
    local function toggle_todo()
        local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
        local item = items[cursor_line]
        if not item or item.type ~= 'todo' then
            return
        end

        -- Toggle completion status
        item.completed = not item.completed

        -- Update display and highlights
        local checkbox = item.completed and '✓' or '☐'
        local new_line = checkbox .. ' ' .. item.text
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, cursor_line - 1, cursor_line, false, { new_line })
        vim.bo[buf].modifiable = false

        -- Update highlights (get existing extmarks on current line and clear only those)
        local line_extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, {cursor_line - 1, 0}, {cursor_line - 1, -1}, {})
        for _, mark in ipairs(line_extmarks) do
            vim.api.nvim_buf_del_extmark(buf, ns_id, mark[1])
        end
        
        local checkbox_hl = item.completed and 'TodoCompleted' or 'TodoPending'
        local text_hl = item.completed and 'TodoCompletedText' or 'TodoPendingText'
        vim.api.nvim_buf_set_extmark(buf, ns_id, cursor_line - 1, 0, {
            end_col = 1,
            hl_group = checkbox_hl,
        })
        vim.api.nvim_buf_set_extmark(buf, ns_id, cursor_line - 1, 2, {
            end_col = #new_line,
            hl_group = text_hl,
        })

        -- Write back to file asynchronously
        vim.schedule(function()
            M._write_async(todo_path, items)
        end)

        -- Update title with completion count
        local new_completed_count = 0
        for _, i in ipairs(items) do
            if i.type == 'todo' and i.completed then
                new_completed_count = new_completed_count + 1
            end
        end
        vim.api.nvim_win_set_config(win, { title = string.format(' TODO (%d/%d) ', new_completed_count, todo_count) })
    end

    -- Set up buffer-local keymaps
    vim.keymap.set('n', '<CR>', toggle_todo, { buffer = buf, silent = true })
    vim.keymap.set('n', '<Space>', toggle_todo, { buffer = buf, silent = true })
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
end

function M._write_async(todo_path, items)
    vim.uv.fs_open(todo_path, 'r', 438, function(err, fd)
        if err or not fd then
            return
        end

        vim.uv.fs_fstat(fd, function(stat_err, stat)
            if stat_err or not stat then
                vim.uv.fs_close(fd)
                return
            end

            vim.uv.fs_read(fd, stat.size, 0, function(read_err, data)
                vim.uv.fs_close(fd)
                if read_err or not data then
                    return
                end

                local lines = vim.split(data, '\n')

                -- Update todo lines
                for _, item in ipairs(items) do
                    if item.type == 'todo' then
                        local new_checkbox = item.completed and '[x]' or '[ ]'
                        local new_line = item.original_line:gsub('%[([%sx])%]', new_checkbox)
                        lines[item.line_num] = new_line
                    end
                end

                -- Write back to file
                local content = table.concat(lines, '\n')
                vim.uv.fs_open(todo_path, 'w', 438, function(open_err, write_fd)
                    if open_err or not write_fd then
                        return
                    end

                    vim.uv.fs_write(write_fd, content, 0, function(_)
                        vim.uv.fs_close(write_fd)
                    end)
                end)
            end)
        end)
    end)
end

return M
