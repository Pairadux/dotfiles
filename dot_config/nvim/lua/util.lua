local M = {}

function M.insert_title()
    -- grab commentstring prefix
    local cs = vim.bo.commentstring:match '^(.-)%%s' or vim.bo.commentstring
    cs = cs:gsub('%s*$', '')

    -- prompt
    local title = vim.fn.input 'Enter title: '
    if title == '' then
        return
    end

    local top, mid, bot
    if vim.bo.filetype == 'lua' then
        -- fixed-width break style for lua
        local border = string.rep('-', 60)
        top = cs .. border
        mid = cs .. ' ' .. title
        bot = top
    else
        -- dynamic box style for everything else
        local inner = #title + 2
        local border = string.rep('-', inner)
        top = cs .. ' +' .. border .. '+'
        mid = cs .. ' | ' .. title .. ' |'
        bot = top
    end

    -- insert and restore cursor
    vim.api.nvim_put({ top, mid, bot }, 'l', true, true)
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local last = vim.api.nvim_buf_line_count(0)
    if r == last then
        vim.api.nvim_buf_set_lines(0, last, last, false, { '' })
    end
    vim.api.nvim_win_set_cursor(0, { r + 1, 0 })

    -- center and drop into insert
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

function M.squeeze_interior_whitespace()
    -- Exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)

    -- Get 0-indexed start/end of the last visual selection
    local s = vim.fn.getpos "'<"
    local e = vim.fn.getpos "'>"
    local sl, sc = s[2] - 1, s[3] - 1
    local el, ec = e[2] - 1, e[3] - 1

    if sl < 0 or el < 0 then
        vim.api.nvim_err_writeln 'No valid selection found'
        return
    end

    for ln = sl, el do
        local line = vim.api.nvim_buf_get_lines(0, ln, ln + 1, false)[1] or ''
        -- compute raw range
        local lcol = (ln == sl) and sc or 0
        local rcol = (ln == el) and ec or #line

        -- clamp to [0, #line]
        lcol = math.max(0, math.min(lcol, #line))
        rcol = math.max(lcol, math.min(rcol, #line))

        if lcol < rcol then
            local segment = line:sub(lcol + 1, rcol)
            local lead = segment:match '^%s*' or ''
            local body = segment:sub(#lead + 1):gsub('%s+', ' ')
            local modified = lead .. body

            if modified ~= segment then
                local ok, err = pcall(vim.api.nvim_buf_set_text, 0, ln, lcol, ln, rcol, { modified })
                if not ok then
                    vim.api.nvim_err_writeln('Error squeezing whitespace: ' .. err)
                end
            end
        end
    end
end

function M.get_visual_selection_info()
    local mode = vim.fn.mode()

    -- If we're currently in visual mode, get the selection directly
    if mode == 'v' or mode == 'V' or mode == '\22' then -- \22 is visual block mode
        local start_pos = vim.fn.getpos '.'
        local end_pos = vim.fn.getpos 'v'

        -- Ensure start comes before end
        local sl, sc, el, ec
        if start_pos[2] < end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] <= end_pos[3]) then
            sl, sc = start_pos[2], start_pos[3]
            el, ec = end_pos[2], end_pos[3]
        else
            sl, sc = end_pos[2], end_pos[3]
            el, ec = start_pos[2], start_pos[3]
        end

        return {
            start_line = sl,
            start_col = sc,
            end_line = el,
            end_col = ec,
        }
    else
        -- Use marks from previous visual selection
        local s = vim.fn.getpos "'<"
        local e = vim.fn.getpos "'>"
        local sl, sc = s[2], s[3]
        local el, ec = e[2], e[3]

        -- Check if we have valid selection marks
        if sl == 0 or el == 0 then
            return nil
        end

        return {
            start_line = sl,
            start_col = sc,
            end_line = el,
            end_col = ec,
        }
    end
end

function M.open_claude_with_selection()
    local selection = M.get_visual_selection_info()

    if not selection then
        vim.notify('No valid visual selection found', vim.log.levels.WARN)
        return
    end

    local file_path = vim.fn.expand '%:p'
    -- Get relative path from current working directory
    local relative_path = vim.fn.fnamemodify(file_path, ':.')

    if not file_path or file_path == '' then
        vim.notify('No file found for current buffer', vim.log.levels.WARN)
        return
    end

    -- Create marker in format @filename.ext#L151-153 (or L155-155 for single line)
    local marker = string.format('@%s#L%d-%d', relative_path, selection.start_line, selection.end_line)

    -- Prompt user for their message
    local user_message = vim.fn.input('Claude Code - ' .. marker)
    if user_message == '' then
        vim.notify('No message provided, cancelling', vim.log.levels.INFO)
        return
    end

    -- Combine marker and message
    local full_message = string.format('%s: %s', marker, user_message)

    local claude_cmd = string.format('claude "%s"', full_message)

    require('snacks.terminal').toggle(claude_cmd, {
        win = {
            border = 'single',
            title = 'Claude Code - ' .. relative_path,
            width = 0.9,
            height = 0.8,
        },
    })
end

function M.open_claude_simple()
    local claude_cmd = 'claude'

    require('snacks.terminal').toggle(claude_cmd, {
        win = {
            border = 'single',
            title = 'Claude Code',
            width = 0.9,
            height = 0.8,
        },
    })
end

function M.open_claude_with_file()
    local file_path = vim.fn.expand '%:p'
    -- Get relative path from current working directory
    local relative_path = vim.fn.fnamemodify(file_path, ':.')

    local marker = string.format('@%s', relative_path)

    local user_message = vim.fn.input('Claude Code - ' .. marker .. ': ')
    if user_message == '' then
        vim.notify('No message provided, cancelling', vim.log.levels.INFO)
        return
    end

    -- Combine marker and message
    local full_message = string.format('%s: %s', marker, user_message)

    local claude_cmd = string.format('claude "%s"', full_message)

    require('snacks.terminal').toggle(claude_cmd, {
        win = {
            border = 'single',
            title = 'Claude Code - ' .. relative_path,
            width = 0.9,
            height = 0.8,
        },
    })
end

function M.open_claude_continue()
    local claude_cmd = 'claude --continue'

    require('snacks.terminal').toggle(claude_cmd, {
        win = {
            border = 'single',
            title = 'Claude Code - Continue',
            width = 0.9,
            height = 0.8,
        },
    })
end

function M.open_todo()
    local cwd = vim.fn.getcwd()
    local todo_path = cwd .. '/todo.md'
    
    if vim.fn.filereadable(todo_path) == 1 then
        vim.cmd('edit ' .. todo_path)
    else
        vim.notify('No todo.md file found in root directory: ' .. cwd, vim.log.levels.WARN)
    end
end

return M
